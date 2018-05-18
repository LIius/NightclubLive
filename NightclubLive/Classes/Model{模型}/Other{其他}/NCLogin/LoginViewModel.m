//
//  LoginViewModel.m
//  NightclubLive
//
//  Created by WanBo on 16/12/26.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "LoginViewModel.h"
#import "LoginAndRegistRequest.h"
#import "LocationTool.h"


@interface  LoginViewModel()

@property (nonatomic, strong, readwrite) RACSignal *loginEnableSignal;
@property (nonatomic, strong, readwrite) RACCommand *reuqesLoginCommand;

@end

@implementation LoginViewModel

- (instancetype)init{
    
    if (self = [super init]){
        self.loginEnableSignal = [[RACSignal combineLatest:@[ RACObserve(self, password), RACObserve(self, phone) ]reduce:^(NSString *password,NSString *phone){
            if (![self isValidPhone:phone]) {
                //请输入正确的手机号码
                return @(1);
            }else if(![self isValidPassword:password]){
                //请输入正确的注册密码
                return @(2);
            }else  if([self isValidPhone:phone]&&[self isValidPassword:password]){
                return @(666);
                
            }else{
                return @(0);
            }
        }]distinctUntilChanged];
        
        //请求
        _reuqesLoginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                LoginRequest *request = [LoginRequest new];

                NSMutableDictionary *loginParam = [[NSMutableDictionary alloc] initWithDictionary:@{@"passWord":_password,@"phoneNum":_phone}];
                
                if (_uid){
                    [loginParam setValue:_uid forKey:@"thirdparty_uid"];
                }
                
                request.param = [loginParam copy];
                
                [request startWithCompletedBlock:^(GJBaseRequest *request) {
                    NSDictionary *dict = (NSDictionary*)request.responseObject;
                    NSLog(@"%@",dict);
                    if(request.error){
                        NSLog(@"-----%@",request.error);
                    }
                    [subscriber sendNext:dict];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            // 在返回数据信号时，把数据中的字典映射成模型信号，传递出去
            return [requestSignal map:^id(NSDictionary *dict) {
                //chenggong
                if ([dict[@"code"] integerValue] == 0) {
                    
                }
                return @{@"result":dict[@"code"],@"msg":dict[@"msg"]};
                
            }];
            
        }];
    }
    return self;
}

- (void)initialize {
    
    [super initialize];
    
}

// 这两个判断都属于逻辑范畴，和UI无关
- (BOOL)isValidPhone:(NSString *)phone {
    return phone.length == 11&&[self isPureInt:phone];
}

- (BOOL)isValidPassword:(NSString *)password {
    return [self isPureInt:password];
}
- (BOOL)isPureInt:(NSString*)string{
  //  NSScanner* scan = [NSScanner scannerWithString:string];
   // int val;
   // return[scan scanInt:&val] && [scan isAtEnd];
    
    return YES;
}

@end
