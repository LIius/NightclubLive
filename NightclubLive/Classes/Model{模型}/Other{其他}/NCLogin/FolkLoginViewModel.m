//
//  FolkLoginViewModel.m
//  NightclubLive
//
//  Created by RDP on 2017/2/25.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "FolkLoginViewModel.h"
#import "LoginAndRegistRequest.h"

@implementation FolkLoginViewModel


- (instancetype)init{
    
    if (self = [super init]){
        
        _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                FolkLoginRequest *request = [FolkLoginRequest new];
                request.param = @{@"uid":self.uid,@"user_name":self.userName,@"user_location":self.userLocation,@"user_img":self.userImg,@"user_sex":@(self.sex),@"user_type":@(self.loginType)};
                
                [request startWithCompletedBlock:^(GJBaseRequest *request) {
                    
                    NSDictionary *responseDic = request.responseObject;
                    
                    DLog(@"%@",responseDic);
                    
                    [subscriber sendNext:responseDic];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return [signal map:^id(id value) {
                
                NSDictionary *responseDic = value;
                
                NSInteger resultCode = [responseDic[@"code"] integerValue];
                if (resultCode == 0){
                    
                    /*DataBaseManager *manager = [DataBaseManager defaultManager];
                    
                    LoginModel *loginModel =  [[LoginModel alloc] init];
                    
                    NSDictionary *userDic = responseDic[@"data"];
                    
                    loginModel.phonenum = @"";
                    loginModel.password = @"";
                    loginModel.token = [NSString stringWithFormat:@"%@",userDic[@"id"]];
                    loginModel.address = userDic[@"user_location"];
                    loginModel.userName = userDic[@"user_name"];
                    loginModel.isccert = @(0);
                    loginModel.ispcert = @(0);
                    loginModel.isbcert = @(0);
                    loginModel.carlogo = @"";
                    
                    loginModel.sex = userDic[@"user_sex"];
                    loginModel.logo = userDic[@"user_img"];*/


               //     [manager insertLoginModels:loginModel];
                    
                }
                
                return @{@"result":@(resultCode == 0 ? YES : NO),@"msg":resultCode == 1 ? @"登录成功":responseDic[@"msg"]};
            }];
        }];
    }
    return self;
}
@end
