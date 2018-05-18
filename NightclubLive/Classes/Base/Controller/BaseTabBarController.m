//
//  BaseTabBarController.m
//  AgileCarRental
//
//  Created by WanBo on 16/10/24.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "BaseTabBarController.h"
#import "ObjectNavigationController.h"
#import "NIMSDK.h"
#import "NetRedCircleHomeVC.h"
#import "NetRedCircleHomeViewModel.h"
#import "MineViewController.h"
#import "NIMSessionListViewController.h"
#import "NCRedCircleViewController.h"

#import "ClubCircleHomeVC.h"
#import "UIView+YYAdd.h"

#import "NCRedCircleViewController.h"

//#import "NTESCustomNotificationDB.h"

typedef NS_ENUM(NSInteger,NTESMainTabType) {
    NTESMainTabTypeNetRedCircle,    //红人圈
    NTESMainTabTypeClubCircle,      //夜店圈
    NTESMainTabTypeLive,            //Live
    NTESMainTabTypeMessage,         //消息
    NTESMainTabTypeMine,            //我的
};

@interface BaseTabBarController () <NIMSystemNotificationManagerDelegate,NIMConversationManagerDelegate, UITabBarControllerDelegate>

@property (nonatomic,assign) NSInteger sessionUnreadCount;
@property (nonatomic,assign) NSInteger systemUnreadCount;

//@property (nonatomic,assign) NSInteger customSystemUnreadCount;

@end

@implementation BaseTabBarController

+ (instancetype)instance {
    
    static BaseTabBarController *sharedVC = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedVC = [[BaseTabBarController alloc]init];
        sharedVC.delegate = sharedVC;
    });
    return sharedVC;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    
    self.sessionUnreadCount = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
    self.systemUnreadCount = [NIMSDK sharedSDK].systemNotificationManager.allUnreadCount;
    //    self.customSystemUnreadCount = [[NTESCustomNotificationDB sharedInstance] unreadCount];
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tabbar-bar"];
    self.tabBar.translucent = NO;
    
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:@""],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal] ;
    

    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys: [UIColor colorWithHexString:@"F711FF"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

    // 添加子控制器F711FF
    [self setupChildVC];
    
//    UINavigationController *nav = self.viewControllers[0];
//    NetRedCircleHomeVC *homeVC = nav.viewControllers[0];
//    homeVC.viewModel = [[NetRedCircleHomeViewModel alloc] initWithParams:nil];
    
    //判断系统版本然后设置颜色
   // [self.tabBar setTintColor:RGBCOLOR(247, 17, 255)];
}

- (UIViewController *)loadStoryboardWithName:(NSString *)name identify:(NSString *)identify
{
   return  [[UIStoryboard storyboardWithName:name bundle:nil] instantiateViewControllerWithIdentifier:identify];
}

- (void)setupChildVC
{
//    NCRedCircleViewController *vc2 = [[NCRedCircleViewController alloc]init];
//
//    [self addChildNavigationController:[ObjectNavigationController class]
//                    rootViewController:vc2
//                                 title:@"红人圈"
//                       tabBarImageName:@"bg_main_used_car_normal"
//                 tabBarSelectImageName:@"bg_main_used_car_checked"];
    
    [self addChildNavigationController:[ObjectNavigationController class]
                    rootViewController:[self loadStoryboardWithName:@"RedCircleHome" identify:@"NetRedCircleHomeVC"]
                                 title:@"红人圈"
                       tabBarImageName:@"bg_main_used_car_normal"
                 tabBarSelectImageName:@"bg_main_used_car_checked"];

    
//    [self addChildNavigationController:[ObjectNavigationController class]
//                    rootViewController:vc
//                                 title:@"红人圈"
//                       tabBarImageName:@"bg_main_used_car_normal"
//                 tabBarSelectImageName:@"bg_main_used_car_checked"];

    
    ClubCircleHomeVC *vc = (ClubCircleHomeVC *)[self loadStoryboardWithName:@"ClubCircleHome" identify:@"ClubCircleHomeVC"];
    vc.menuViewStyle = WMMenuViewStyleFlood;
    vc.menuItemWidth = self.view.frame.size.width/2;
    vc.titleColorSelected = [UIColor whiteColor];
    vc.titleColorNormal = [UIColor whiteColor];
    vc.progressColor = [UIColor colorWithHexString:@"fb44ff"];
    vc.showOnNavigationBar = YES;
    vc.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
    vc.titleSizeSelected = 15;
    CGFloat h = 28;
    vc.menuItemHeight = h;
    vc.progressHeight = h;
    vc.menuCornerRadius = h/2;
    vc.menuScrollviewColor = [UIColor colorWithHexString:@"755a9d"];
    
    [self addChildNavigationController:[ObjectNavigationController class]
                    rootViewController:vc
                                 title:@"夜店圈"
                       tabBarImageName:@"bg_main_service_normal"
                 tabBarSelectImageName:@"bg_main_service_pressed"];

    [self addChildNavigationController:[ObjectNavigationController class]
                    rootViewController:[self loadStoryboardWithName:@"ClubLiveHome" identify:@"PaiPaiVC"]
                                 title:@"夜生活"
                       tabBarImageName:@"btn_live"
                 tabBarSelectImageName:@"btn_live_press"];

    [self addChildNavigationController:[ObjectNavigationController class]
                    rootViewController:[self loadStoryboardWithName:@"ClubMessageHome" identify:@"ClubMessageHome"]
                                 title:@"夜信"
                       tabBarImageName:@"bg_main_message_normal"
                 tabBarSelectImageName:@"bg_main_message_pressed"];

    [self addChildNavigationController:[ObjectNavigationController class]
                    rootViewController:[self loadStoryboardWithName:@"MineHome" identify:@"MineViewController"]
                                 title:@"我的"
                       tabBarImageName:@"bg_main_mine_normal"
                 tabBarSelectImageName:@"bg_main_mine_pressed"];
}

//#pragma mark 添加导航控制器
- (void)addChildNavigationController:(Class)navigationControllerClass
                  rootViewController:(UIViewController *)rootViewController
                               title:(NSString *)title
                     tabBarImageName:(NSString *)name
               tabBarSelectImageName:(NSString *)selectName
{
    // 创建导航控制器
    UINavigationController *naviViewController = [[navigationControllerClass  alloc] initWithRootViewController:rootViewController];
    rootViewController.title = title;

    // 正常样式
//    UIColor *normalColor = [UIColor whiteColor];
//    UIFont *noramlFont = [UIFont boldSystemFontOfSize:12];
//    [rootViewController.tabBarItem setTitleTextAttributes:
//                            @{NSFontAttributeName:noramlFont,
//                   NSForegroundColorAttributeName:normalColor}
//                                                 forState:UIControlStateNormal];

    // 选中样式
    UIColor *selectColor = [UIColor colorWithHexString:@"F711FF"];
    UIFont *selectFont = [UIFont boldSystemFontOfSize:12];
    [rootViewController.tabBarItem setTitleTextAttributes:
                           @{NSFontAttributeName:selectFont,
                  NSForegroundColorAttributeName:selectColor}
                                                 forState:UIControlStateSelected];

    // 标签栏图片
    rootViewController.tabBarItem.image = [[UIImage imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    rootViewController.tabBarItem.selectedImage = [[UIImage imageNamed:selectName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    // 主标签控制器中添加子导航控制器
    [self addChildViewController:naviViewController];
}

#pragma mark - NIMConversationManagerDelegate
- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
}

- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession totalUnreadCount:(NSInteger)totalUnreadCount{
    self.sessionUnreadCount = totalUnreadCount;
    [self refreshSessionBadge];
}

- (void)messagesDeletedInSession:(NIMSession *)session{
    self.sessionUnreadCount = [NIMSDK sharedSDK].conversationManager.allUnreadCount;
    [self refreshSessionBadge];
}

- (void)allMessagesDeleted{
    self.sessionUnreadCount = 0;
    [self refreshSessionBadge];
}

- (void)refreshSessionBadge {
    UINavigationController *nav = self.viewControllers[NTESMainTabTypeMessage];
    nav.tabBarItem.badgeValue = self.sessionUnreadCount ? @(self.sessionUnreadCount).stringValue : nil;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{    
    return YES;
}

@end
