//
//  VerificationCodeViewModel.m
//  NightclubLive
//
//  Created by WanBo on 16/12/26.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "VerificationCodeViewModel.h"
#import "LoginAndRegistRequest.h"


@interface  VerificationCodeViewModel()

@property (nonatomic, strong, readwrite) RACSignal *doneEnableSignal;
@property (nonatomic, strong, readwrite) RACCommand *reuqesCodeCommand;
@property (nonatomic, strong, readwrite) RACCommand *reuqesRegistCommand;

@end


@implementation VerificationCodeViewModel
- (void)initialize {
    
    [super initialize];
    
    self.doneEnableSignal = [[RACSignal combineLatest:@[ RACObserve(self, code) ]reduce:^(NSString *code){
        if (![self isValidCode:code]) {
            //请输入正确的手机号码
            return @(1);
        }else  if([self isValidCode:code]){
            return @(666);
            
        }else{
            return @(0);
        }
    }]distinctUntilChanged];
    //请求
    _reuqesCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //****用户注册获取验证码
            
            GetCodeRequest *request = [GetCodeRequest new];
            request.param = @{@"phonenum":self.params[@"phone"],@"type":@1};
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
            return dict;

        }];
        
    }];
    
    _reuqesRegistCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //****用户注册
            RegisterRequest *request = [RegisterRequest new];
            //invitationCode
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"phonenum":self.params[@"phone"],@"password":self.params[@"pwd"],@"verifyCode":self.code}];
            
            if (self.params[@"invaitionCode"])
                [params setValue:self.params[@"invaitionCode"] forKey:@"invitationCode"];
            request.param = [params copy];
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
            if ([dict[@"msg"] isEqualToString:@"注册成功"]) {
            }
            
            if (!dict)
                return @{@"isSuccess":@(NO),@"msg":@"错误"};
            return @{@"isSuccess":@([dict[@"msg"] isEqualToString:@"注册成功"]),@"msg":dict[@"msg"]};
        }];
        
    }];
    
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
