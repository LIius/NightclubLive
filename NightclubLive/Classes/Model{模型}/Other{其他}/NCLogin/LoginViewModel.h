//
//  LoginViewModel.h
//  NightclubLive
//
//  Created by WanBo on 16/12/26.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "MRCViewModel.h"

@interface LoginViewModel : MRCViewModel
/** 密码 */
@property (nonatomic, copy) NSString *password;
/** 手机号码 */
@property (nonatomic, copy) NSString *phone;
/** 第三方登录UID */
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, strong, readonly) RACSignal *loginEnableSignal;
@property (nonatomic, strong, readonly) RACCommand *reuqesLoginCommand;

@end
