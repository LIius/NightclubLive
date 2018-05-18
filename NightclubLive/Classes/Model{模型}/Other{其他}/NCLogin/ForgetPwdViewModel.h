//
//  ForgetPwdViewModel.h
//  NightclubLive
//
//  Created by WanBo on 16/12/27.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "MRCViewModel.h"

@interface ForgetPwdViewModel : MRCViewModel

@property (nonatomic, copy)NSString *code;
@property (nonatomic, copy)NSString *phone;


@property (nonatomic, strong, readonly) RACSignal *nextEnableSignal;
// 请求验证码
@property (nonatomic, strong, readonly) RACCommand *reuqesCodeCommand;

@end
