//
//  ChangePwdViewModel.h
//  NightclubLive
//
//  Created by WanBo on 16/12/27.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "MRCViewModel.h"

@interface ChangePwdViewModel : MRCViewModel

@property (nonatomic, copy)NSString *newpwd;
@property (nonatomic, copy)NSString *surePwd;
@property (nonatomic, copy) NSString *invitaionCode;
@property (nonatomic, strong, readonly) RACSignal *doneEnableSignal;

@property (nonatomic, strong, readonly) RACCommand *reuqesChangePwdCommand;

@end
