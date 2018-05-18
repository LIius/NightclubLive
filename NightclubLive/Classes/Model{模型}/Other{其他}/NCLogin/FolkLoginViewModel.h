//
//  FolkLoginViewModel.h
//  NightclubLive
//
//  第三方登录ViewModel
//
//  Created by RDP on 2017/2/25.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MRCViewModel.h"

@interface FolkLoginViewModel : MRCViewModel
/** 第三方返回的UID */
@property (nonatomic, copy) NSString *uid;
/** 用户名 */
@property (nonatomic, copy) NSString *userName;
/** 用户地区 */
@property (nonatomic, copy) NSString *userLocation;
/** 用户头像 */
@property (nonatomic, assign) NSInteger sex;
/** 用户头像 */
@property (nonatomic, copy) NSString *userImg;
/** 登录类型 */
@property (nonatomic, assign) NSInteger loginType;

/** 登录事件 */
@property (nonatomic, strong, readonly) RACCommand *loginCommand;
@end
