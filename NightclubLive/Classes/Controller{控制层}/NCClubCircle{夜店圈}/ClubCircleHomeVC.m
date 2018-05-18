//
//  ClubCircleHomeVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/2.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "ClubCircleHomeVC.h"
#import "ClubCircleDynamicVC.h" // 动态
#import "ClubCircleVoiceVC.h" // 心声
#import "ReleaseDynamicVC.h"
#import "ObjectNavigationController.h"

#import "ClubCircleDynamicViewModel.h"
#import "ReleaseDynamicViewModel.h"
#import "ClubCircleVoiceViewModel.h"
#import "LoginViewModel.h"

#import "LoginVC.h"
#import "JhtFloatingBall.h"
#import "UILabel+NavTitleView.h"
#import "BlocksKit+UIKit.h"

@interface ClubCircleHomeVC ()<
UIAlertViewDelegate,
UIGestureRecognizerDelegate
>
{
    NSInteger _index;
}

@property (nonatomic, strong) JhtFloatingBall *dynamicIV;

@end

@implementation ClubCircleHomeVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.dynamicIV];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectHeart) name:NOTIFICATION_SWITCHHEAERT object:nil];
}

- (void)selectHeart{
    for (WMMenuItem *item  in self.menuView.scrollView.subviews) {
        if (item.x >0) {
            [self.menuView didPressedMenuItem:item];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [SharedAppDelegate.window setRootViewController:[[ObjectNavigationController alloc]initWithRootViewController:[LoginVC controllerWithViewModel:[[LoginViewModel alloc] initWithParams:nil] andSbName:@"RegisterAndLogin"]]];
    }
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (index==0) {
        return @"动态";
    }else{
        return @"心声";
    }
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index==0) {
        return [ClubCircleDynamicVC initSBWithSBName:@"CCDynamicSB"];
    }else{
        return [ClubCircleVoiceVC initSBWithSBName:@"CCVoiceSB"];
    }
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width+10;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    CGFloat leftMargin = self.showOnNavigationBar ? iPhone4?100:130 : 0;
    CGFloat x = iOS11 ? 0 : leftMargin;
    CGFloat y = iOS11 ? 0 : 8;
    return CGRectMake(x, y, self.view.frame.size.width - 2*leftMargin, 28);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (JhtFloatingBall *)dynamicIV{
    
    if (!_dynamicIV){
        
        _dynamicIV = [[JhtFloatingBall alloc] init];
        
        _dynamicIV.image = KGetImage(@"发布按钮2");
        CGFloat width = SCREEN_WIDTH * 0.20;
        CGFloat height = width * 0.504;
        CGRect rect = CGRectZero;

        if (iPhoneX) {
            rect = CGRectMake(SCREEN_WIDTH - width - 10,SCREEN_HEIGHT - height -  85 -88-34, width, height);
        }else{
            rect = CGRectMake(SCREEN_WIDTH - width - 10, SCREEN_HEIGHT - height - 130, width, height);
        }
        _dynamicIV.frame = rect;
        
        _dynamicIV.stayMode = stayMode_OnlyLeftAndRight;
        
        @weakify(self);
        [_dynamicIV addGestureRecognizer:[[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            @strongify(self);
            ReleaseDynamicVC *vc = [ReleaseDynamicVC initSBWithSBName:@"CCReleaseDynamic"];
            
            [self.navigationController pushViewController:vc animated:YES];
        
        }]];
    }
    return _dynamicIV;
}

@end
