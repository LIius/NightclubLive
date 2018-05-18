//
//  ForgetPwdViewModel.m
//  NightclubLive
//
//  Created by WanBo on 16/12/27.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "ForgetPwdViewModel.h"
#import "LoginAndRegistRequest.h"

@interface  ForgetPwdViewModel()

@property (nonatomic, strong, readwrite) RACSignal *nextEnableSignal;
// 请求验证码
@property (nonatomic, strong, readwrite) RACCommand *reuqesCodeCommand;

@end

@implementation ForgetPwdViewModel

- (void)initialize {
    
    [super initialize];
    
    self.nextEnableSignal = [[RACSignal combineLatest:@[RACObserve(self, code),RACObserve(self, phone) ]reduce:^(NSString *code,NSString *phone){
       
        if (![self isValidPhone:phone]) {
            //请输入正确的手机号码
            return @(1);
        }else if (![self isValidCode:code]) {
            //请输入正确的手机号码
            return @(2);
        }else  if([self isValidCode:code]&&[self isValidPhone:phone]){
            return @(666);
            
        }else{
            return @(0);
        }
    }]distinctUntilChanged];
}

- (RACCommand *)reuqesCodeCommand{
    if (!_reuqesCodeCommand){
        
        //请求
        _reuqesCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                //****用户注册获取验证码
                
                GetCodeRequest *request = [GetCodeRequest new];
                request.param = @{@"phonenum":self.phone,@"type":@2};
                [request startWithCompletedBlock:^(GJBaseRequest *request) {
                    NSDictionary *dict = (NSDictionary*)request.responseObject;
                    NSLog(@"%@",dict);
                    [subscriber sendNext:dict];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            // 在返回数据信号时，把数据中的字典映射成模型信号，传递出去
            return [requestSignal map:^id(NSDictionary *dict) {
                //chenggong
                return dict[@"msg"];
                
            }];
            
        }];

    }
    return _reuqesCodeCommand;
}

- (BOOL)isValidPhone:(NSString *)phone {
    return [self isPureInt:phone]&&phone.length==11;
}

- (BOOL)isValidCode:(NSString *)code {
    return [self isPureInt:code]&&code.length>0;
}
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

@end
