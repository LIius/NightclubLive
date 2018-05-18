//
//  NCPushManager.h
//  NightclubLive
//
//  Created by CodeRiding on 2017/10/10.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface NCPushManager : NSObject

+ (instancetype)shareInsatance;

- (void)handelPushMessage:(NIMCustomSystemNotification *)notification;

// 处理聊天推送
- (void)handelChatMessage:(UNNotificationResponse *)notification;

@end
