//
//  NC3rdManager.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/10/9.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NC3rdManager.h"
#import "NC3rdShare.h"
#import "NC3rdNetwork.h"
#import "NC3rdChat.h"
#import "NC3rdMap.h"

@implementation NC3rdManager

+ (void)start3rdService
{
    // 开启第三方分享
    [NC3rdShare startShare];
    
    // 配置网络地址
    [NC3rdNetwork configNetwork];
    
    // 配置聊天
    NC3rdChat *chat = [[NC3rdChat alloc] init];
    [chat configChat];
    
    // 开启地图
    [NC3rdMap startMap];
}

@end
