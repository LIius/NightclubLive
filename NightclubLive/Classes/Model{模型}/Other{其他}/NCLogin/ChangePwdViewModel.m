//
//  ChangePwdViewModel.m
//  NightclubLive
//
//  Created by WanBo on 16/12/27.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "ChangePwdViewModel.h"
#import "LoginAndRegistRequest.h"

@interface  ChangePwdViewModel()

@property (nonatomic, strong, readwrite) RACSignal *doneEnableSignal;
// 请求验证码
@property (nonatomic, strong, readwrite) RACCommand *reuqesChangePwdCommand;

@end

@implementation ChangePwdViewModel

- (void)initialize {
    
    [super initialize];
    self.doneEnableSignal = [[RACSignal combineLatest:@[RACObserve(self, newpwd),RACObserve(self, surePwd),RACObserve(self, invitaionCode) ]reduce:^(NSString *newpwd,NSString *surePwd,NSString *invitaionCode){
        
        if(newpwd.length>0&&newpwd.length>0&&[newpwd isEqualToString:surePwd]){
            return @(666);
            
        }else{
            return @(1);
        }
    }]distinctUntilChanged];
    
    //请求
    _reuqesChangePwdCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            //****用户注册获取验证码
            
            UserResetRequest *request = [UserResetRequest new];
            request.param = @{@"phonenum":self.params[@"phone"],@"password":_surePwd,@"verifyCode":self.params[@"code"]};
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
            if([dict[@"msg"] isEqualToString:@"success"]){

            }
            
            BOOL result = @([dict[@"msg"] isEqualToString:@"success"]);
            
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithDictionary:@{@"result":@(result)}];
            
            NSString *msg;
            
            if (result){
                msg = @"修改成功";
            }
            else
                msg = @"修改失败";
            
            [resultDic setObject:msg forKey:@"msg"];
            
            return [resultDic copy];

        }];
        
    }];
}



@end
