//
//  NCSysConst.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/10/14.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NCSysConst.h"

@implementation NCSysConst

#pragma mark - NOTIFICATION

NSString * const NOTIFICATION_SLRELEASEDYNAMIC  = @"yd2019.cn.slreleasedynamic";

NSString * const NOTIFICATION_SLPAIPAILIST  = @"yd2019.cn.slpaipailist";

NSString * const NOTIFICATION_LOGINFINISH  = @"yd2019.cn.loginfinish";

NSString * const NOTIFICATION_LOGINOUT  = @"yd2019.cn.loginout";

/** 支付宝支付结果回调通知 */
NSString * const NOTIFICATION_ALIPAYREBACK  = @"yd2019.cn.alipayreback";

/** 微信支付回调通知 */
NSString * const NOTIFICATION_WEICHATREBACK  = @"yd2019.cn.weichatreback";

NSString * const NOTIFICATION_SWITCHHEAERT  = @"yd2019.cn.switchheaert";





#pragma mark - USERDEFAULT

NSString * const USERDEFAULT_PHONE  = @"yd2019.cn.phone";

NSString * const USERDEFAULT_PASSWORD  = @"yd2019.cn.password";

NSString * const USERDEFAULT_THIRDUID  = @"yd2019.cn.thirduid";

NSString * const USERDEFAULT_SOURCE  = @"yd2019.cn.source"; // no yong

NSString * const USERDEFAULT_KEYCHAIN_SERVERNAME  = @"com.GD.Wanbo.NightclubLive";

NSString * const USERDEFAULT_USERDATAKEY1  = @"yd2019.cn.userdatakey1";

NSString * const USERDEFAULT_USERDATAKEY2  = @"yd2019.cn.userdatakey2";

NSString * const USERDEFAULT_YUNXINTOKEN  = @"yd2019.cn.yunxin";

NSString * const USERDEFAULT_USERTOKEN  = @"yd2019.cn.usertoken";

NSString * const USERDEFAULT_LAST_RUN_VERSION  = @"yd2019.cn.lastrunversion";






#pragma mark - 推送Rcommand

NSString * const RCOMMAND_AC_CARD_SEND_HONGBAO = @"ac_card_send_hongbao";





#pragma mark - URL

// 线上
NSString * const URL_ONLINE = @"https://apit.yd2019.cn/";

//NSString * const URL_ONLINE = @"http://120.77.63.106:8080/NightclubWebApp/";

// 开发
//NSString * const URL_DEV = @"http://yd2019.cn:8080/NightclubWebApp/";
NSString * const URL_DEV = @"https://apit.yd2019.cn/";

// 小程序
NSString * const URL_TTPBASE = @"http://ywbt.yd2019.cn:8080";

// 七牛资源地址
NSString * const URL_QINIU = @"http://odp9ddz40.bkt.clouddn.com/";


@end
