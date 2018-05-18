//
//  NC3rdMap.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/10/9.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NC3rdMap.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

//高德地图
#define GaoDe_APP_Key @"0ceaa9e494c262e11ca4b4d3ac0159af"

@implementation NC3rdMap

+ (void)startMap
{
    // 高德地图初始化
    [AMapServices sharedServices].apiKey = GaoDe_APP_Key;
}

@end
