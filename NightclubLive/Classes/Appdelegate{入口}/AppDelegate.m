//
//  AppDelegate.m
//  NightclubLive
//
//  Created by WanBo on 16/11/26.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "AppDelegate.h"
#import "NC3rdManager.h"
#import "NCPayOpenURL.h"
#import "NCPushManager.h"

#import "NIMSDK.h"
#import "NTESLoginManager.h"
//微信SDK头文件
#import "WXApi.h"
#import "NSString+NTES.h"

#import "ObjectNavigationController.h"


#import "LoginViewModel.h"
#import "BaseTabBarController.h"

#import "OpenShareHeader.h"
#import "SystemTool.h"
#import "LeadView.h"

//项目追踪文件
//#import "UIViewController+Swizzled.h"
#import <UserNotifications/UserNotifications.h>

//#import <AlipaySDK/AlipaySDK.h>
#import "RMStore.h"
#import "XLPhotoBrowser.h"


@interface AppDelegate () <UNUserNotificationCenterDelegate,WXApiDelegate,NIMSystemNotificationManagerDelegate>

@property (nonatomic, strong) Reachability *reachability;

@end

@implementation AppDelegate

#pragma mark - 重新启动APP会调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window = [[UIWindow alloc]init];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.rootViewController = [BaseTabBarController instance];
    [self.window makeKeyAndVisible];
    
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    [defaults setValue:@0 forKey:@"FinishLaunch"];
    [defaults synchronize];
    
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    
    // 第三方启动配置
    [NC3rdManager start3rdService];
    [self configureReachability];
    
    // 请求发送通知权限
    [self registerUserNotificationSettings:application];

    
    
    // 引导页添加到窗口
    if ([SystemTool isOneOpen])
    {
        LeadView *leadV = [[LeadView alloc] initWithFrame:KEYWINDOW.bounds];
        [KEYWINDOW addSubview:leadV];
        [KEYWINDOW bringSubviewToFront:leadV];
    }

    // 设置APPSTOREID
    [SystemTool setToolConfigWithAppID:APPStoreID];

    // 延长加载时间
    [NSThread sleepForTimeInterval:1];
    
    // 用户自动登录
    [UserInfo autoLogin];
    
    return YES;
}

- (void)registerUserNotificationSettings:(UIApplication *)application
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {

                }];
            }
        }];
    }else{
        // iOS8 - iOS10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil]];
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    [[NCPushManager shareInsatance]  handelPushMessage:notification];
    DLog(@"[onReceiveCustomSystemNotification=]%@",notification.content);
}

#pragma mark - 【通知】注册远程通知成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    if (deviceToken)
    {
       [[NIMSDK sharedSDK] updateApnsToken:deviceToken];
    }
}

#pragma mark - iOS8-iOS9{前台不展示自动执行，后台展示及点击执行}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark- iOS10及以上{前台展示}
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    DLog(@"[ willPresentNotification --handelPushMessage=]%@",userInfo);
    
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    [[NCPushManager shareInsatance]  handelChatMessage:response];
    
    DLog(@"[handelPushMessage=]%@",userInfo);
    completionHandler();
}

#pragma mark - APP跳转
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ([url.host isEqualToString:@"safepay"])
    {
        [NCPayOpenURL showAlipayWithURL:url];
    }else{
        [WXApi handleOpenURL:url delegate:self];
    }

    return YES;
}

#pragma mark - APP跳转{iOS9之前}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // 这里可以写上其他OpenShare不支持的客户端的回调，比如支付宝等。
    if ([OpenShare handleOpenURL:url]) {
        return YES;
    }
    
    if ([url.host isEqualToString:@"safepay"])
    {
        [NCPayOpenURL showAlipayWithURL:url];
    }else
    {
        [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}

#pragma mark - APP跳转{iOS9之前}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    [WXApi handleOpenURL:url delegate:self];
    
    return YES;
}

#pragma mark -微信支付结果回调
- (void)onResp:(BaseResp *)resp
{
    [NCPayOpenURL payResult:resp];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    {
        // 进行自动登录,每次启动都要自动更新token
        [UserInfo autoLoginServer];
    }
    
    
    {
        // 程序打开后，消除通知的角标
        [application setApplicationIconBadgeNumber:0];
    }
    
#warning 检查fir 版本号 正式要去掉
    [SystemTool share].firID = @"59794186ca87a810a30000e3";
    [SystemTool share].firToken = @"07b1897b0d9feeaf0931b3a89835533d";
    [[SystemTool share] autoCheckFirVersion];
}

- (void)configureReachability
{
    self.reachability = Reachability.reachabilityForInternetConnection;
    
    RAC(self, networkStatus) = [[[[[NSNotificationCenter defaultCenter]
                                   rac_addObserverForName:kReachabilityChangedNotification object:nil]
                                  map:^(NSNotification *notification) {
                                      return @([notification.object currentReachabilityStatus]);
                                  }]
                                 startWith:@(self.reachability.currentReachabilityStatus)]
                                distinctUntilChanged];
    
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @strongify(self)
        [self.reachability startNotifier];
    });
}

@end
