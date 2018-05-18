//
//  NCPushManager.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/10/10.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NCPushManager.h"
#import "ObjectNavigationController.h"
#import "CommentListViewController.h"
#import "NTESSessionViewController.h"
#import "SAMKeychain.h"


@interface NCPushManager()<NIMLoginManagerDelegate>

@end

@implementation NCPushManager

+ (instancetype)shareInsatance
{
    static NCPushManager * instance = nil;
    static dispatch_once_t dispatch;
    dispatch_once(&dispatch, ^{
        instance = [[NCPushManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self autoLoginNIM];
        
        NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
        [defaults setValue:@1 forKey:@"FinishLaunch"];
        [defaults synchronize];
    }
    
    return self;
}

#pragma mark - 自动登录云信
- (void)autoLoginNIM
{
    NSString *yunxinToken = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_YUNXINTOKEN];
    NSString *name = [SAMKeychain passwordForService:USERDEFAULT_KEYCHAIN_SERVERNAME account:USERDEFAULT_PHONE];
    // 自动登录云信{会读取云信缓存信息}
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
    loginData.account = name;
    loginData.token = yunxinToken;
    [[NIMSDK sharedSDK].loginManager autoLogin:loginData];
}

#pragma mark - 手动登录云信
- (void)handLoginNIM
{
    NSString *yunxinToken = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULT_YUNXINTOKEN];
    NSString *name = [SAMKeychain passwordForService:USERDEFAULT_KEYCHAIN_SERVERNAME account:USERDEFAULT_PHONE];
    
    [[NIMSDK sharedSDK].loginManager login:name token:yunxinToken completion:^(NSError * _Nullable error) {

    }];
}

- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepLoginOK)
    {
        NSLog(@"-------ok");
    }
}

- (void)onAutoLoginFailed:(NSError *)error
{
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        // 自动登录失败，启用手动登录
        [self handLoginNIM];
    });
}

- (BOOL) runningInForeground
{
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    BOOL result = (state == UIApplicationStateActive);
    return result;
}

#pragma mark - 处理送礼物、评论推送
- (void)handelPushMessage:(NIMCustomSystemNotification *)notification
{
    NSDictionary *contentDic = [NSJSONSerialization JSONObjectWithData:[notification.content dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    DLog(@"[contentDic=]%@",notification.content);
    
    if ([contentDic[@"From"] isEqualToString:@"gift"])
    {
        NIMSession *session = [NIMSession session:@"礼物管家" type:NIMSessionTypeP2P];
        NIMMessage *messge = [[NIMMessage alloc] init];
        messge.from = @"礼物管家";
        messge.apnsContent = notification.apnsContent;
        
        messge.text = [NSString stringWithFormat:@"%@给你送了%@ x%@ 魅力值: +%@, 零钱: +%@",contentDic[@"giver"],contentDic[@"gift_name"],contentDic[@"gift_count"],contentDic[@"charm_v"],contentDic[@"rmb"]];
        messge.remoteExt = contentDic;
        messge.messageExt = contentDic;
        messge.localExt = contentDic;
        messge.messageExt = notification.content;
        
        [[NIMSDK sharedSDK].conversationManager saveMessage:messge forSession:session completion:^(NSError * _Nullable error)
         {
             // 聊天+礼物管家+充值
             NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
             [self goVC:vc];
         }];
        
    }else if ([contentDic[@"From"] isEqualToString:@"commentary"])
    {
        NIMSession *session = [NIMSession session:@"评论" type:NIMSessionTypeP2P];
        NIMMessage *message =  [[NIMMessage alloc] init];
        message.from = @"评论";
        message.apnsContent = notification.apnsContent;
        message.text = contentDic[@"content"];
        message.localExt = contentDic;
        
        [[NIMSDK sharedSDK].conversationManager saveMessage:message forSession:session completion:^(NSError * _Nullable error)
        {
            CommentListViewController *vc = [CommentListViewController initSBWithSBName:@"CommentListSB"];
            vc.model = session;
            [self goVC:vc];
        }];
    }
    
}

#pragma mark - 处理聊天推送
- (void)handelChatMessage:(UNNotificationResponse *)response
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSString *userID = [userInfo stringForKey:@"fromUser"];
    if (userID.length > 0)
    {
        NIMSession *session = [NIMSession session:userID type:NIMSessionTypeP2P];
        
        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
        [self goVC:vc];
    }
}

- (void)goVC:(UIViewController *)vc
{
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    NSNumber *value = [defaults objectForKey:@"FinishLaunch"];
    if ([value boolValue]) {
        return;
    }
    
    UITabBarController *tabC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    ObjectNavigationController *baseNav = tabC.selectedViewController;
    [baseNav.childViewControllers.firstObject.navigationController pushViewController:vc animated:YES];
}

@end
