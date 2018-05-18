//
//  ObjectNavigationController.m
//  NightClub-Merchant
//
//  Created by RDP on 2017/8/3.
//  Copyright © 2017年 RDP. All rights reserved.
//

#import "ObjectNavigationController.h"

@interface ObjectNavigationController ()

@end

@implementation ObjectNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.改变导航栏按钮的颜色
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"3a1273"];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:18]}];
    self.navigationBar.translucent = NO;
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    // 2.对item设置
    // [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    // [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    
    // 3.設置狀態欄字體顏色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    // 4.滑动返回手势
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

#pragma mark 返回按钮
-(void)popself {
    [self popViewControllerAnimated:YES];
}

#pragma mark 创建返回按钮
-(UIBarButtonItem *)createBackButton {
    return [[UIBarButtonItem alloc] initWithImage:KGetImage(@"icon_backwhite") style:UIBarButtonItemStylePlain target:self action:@selector(popself)];
}

#pragma mark 重写方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title{

}

@end
