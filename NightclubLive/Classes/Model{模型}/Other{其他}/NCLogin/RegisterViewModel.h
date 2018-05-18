//
//  RegisterViewModel.h
//  NightclubLive
//
//  Created by WanBo on 16/12/26.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "MRCViewModel.h"

@interface RegisterViewModel : MRCViewModel

//密码
@property (nonatomic, copy)NSString *password;
//手机号码
@property (nonatomic, copy)NSString *phone;
//邀请码
@property (nonatomic, copy) NSString *invationCode;
@property (nonatomic, strong, readonly) RACSignal *nextEnableSignal;

@end
