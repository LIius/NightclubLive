//
//  NC3rdShare.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/10/9.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NC3rdShare.h"
#import "OpenShareHeader.h"
#import "WeiboSDK.h" // 新浪微博SDK头文件
//微信SDK头文件
#import "WXApi.h"
//第三方SDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//QQ 开发者ID
#define QQ_ID @"1105814693"
#define QQ_KEY @"E1I7psj9JynGK69o"
//微博 APP Key
#define Weibo_Key @"1356920443"
#define Weibo_App_Secret @"1dd82d68ddd7b5ca9a5a39bd6f062f70"
//微信 App Id
#define Weixin_ID @"wxe21fe93b266c7e73"

#define Weixin_App_Secret @"1227673bd6c2dbc508b4ca7f41242cbc"
//Share SDK
#define ShareSDK_APP_SDK @"1b99c205bfb5a"

#define Office_WebSite @"http://www.yd2019.cn"

@implementation NC3rdShare

+ (void)startShare
{

    [WXApi registerApp:Weixin_ID];
    
    // 1105814693
    [OpenShare connectQQWithAppId:QQ_ID];
    // 1356920443
    
    [OpenShare connectWeiboWithAppKey:Weibo_Key];
    //wxe3567cdf1f8bd709
    
    [OpenShare connectWeixinWithAppId:Weixin_ID];
    
    //配置SDK
    [ShareSDK registerApp:ShareSDK_APP_SDK activePlatforms:@[
                                                             @(SSDKPlatformTypeQQ),//QQ
                                                             @(SSDKPlatformTypeWechat),//微信
                                                             @(SSDKPlatformTypeSinaWeibo)//微博
                                                             ]
                 onImport:^(SSDKPlatformType platformType)
    {
                     
             switch (platformType) {
                 case SSDKPlatformTypeSinaWeibo:{
                     [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 }break;
                 case SSDKPlatformTypeWechat:{
                     [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 }break;
                 case SSDKPlatformTypeQQ:{
                     [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 }break;
                 default:
                     break;
             }
        
         } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
             
             switch (platformType) {
                 case SSDKPlatformTypeSinaWeibo:
                     //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                     [appInfo SSDKSetupSinaWeiboByAppKey:Weibo_Key
                                               appSecret:Weibo_App_Secret                                        redirectUri:Office_WebSite
                                                authType:SSDKAuthTypeSSO];
                     break;
                 case SSDKPlatformTypeWechat:
                     [appInfo SSDKSetupWeChatByAppId:Weixin_ID
                                           appSecret:Weixin_App_Secret];
                     break;
                 case SSDKPlatformTypeQQ:
                     [appInfo SSDKSetupQQByAppId:QQ_ID
                                          appKey:QQ_KEY
                                        authType:SSDKAuthTypeBoth];
                 default:
                     break;
             }
             
         }
     ];
}

@end
