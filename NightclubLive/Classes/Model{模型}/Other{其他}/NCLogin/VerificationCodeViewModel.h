//
//  VerificationCodeViewModel.h
//  NightclubLive
//
//  Created by WanBo on 16/12/26.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "MRCViewModel.h"

@interface VerificationCodeViewModel : MRCViewModel
@property (nonatomic, copy)NSString *code;


@property (nonatomic, strong, readonly) RACSignal *doneEnableSignal;
// 请求注册密码验证码
@property (nonatomic, strong, readonly) RACCommand *reuqesCodeCommand;

@property (nonatomic, strong, readonly) RACCommand *reuqesRegistCommand;

@end
