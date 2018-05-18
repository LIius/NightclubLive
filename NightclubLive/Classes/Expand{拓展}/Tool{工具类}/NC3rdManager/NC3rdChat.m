//
//  NC3rdChat.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/10/9.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NC3rdChat.h"
#import "NIMKit.h"
#import "NIMSessionViewController.h"
#import "NTESCellLayoutConfig.h"
#import "NTESCustomAttachmentDecoder.h"

// 网易云信AppKey
#define kNIM_AppKey      @"4f297177b261291390b512628ad4fb4e"
#define Push_Key_Develop @"NightclubLivePushDev"
#define Push_Key         @"NightclubLivePush"

@interface NC3rdChat()<NIMLoginManagerDelegate,NIMSystemNotificationManagerDelegate>

@end

@implementation NC3rdChat

- (void)configChat
{
    NSString *pushName = nil;
#ifdef DEBUG
    pushName = Push_Key_Develop;
#else
    pushName = Push_Key;
#endif
    
    // 注册 NIMKit 自定义排版配置，在注册接口前配置
    [[NIMKit sharedKit] registerLayoutConfig:[NTESCellLayoutConfig class]];
    
    [[NIMSDK sharedSDK] registerWithAppID:kNIM_AppKey cerName:pushName];
    [NIMCustomObject registerCustomDecoder:[NTESCustomAttachmentDecoder new]];
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
}

/**
 *  检测到有其他客户端登录
 */
- (void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
    // 提示用户重新登录
    // [UserInfo loginChange];
}

@end
