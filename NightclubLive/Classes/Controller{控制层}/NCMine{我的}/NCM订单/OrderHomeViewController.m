//
//  OrderHomeViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "OrderHomeViewController.h"

#import "OrderListViewController.h"
#import "NoFuncViewController.h"

@interface OrderHomeViewController ()

@end

@implementation OrderHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (index==0) {
        return @"约台";
    }else{
        return @"夜务";
    }
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index==0) {
        return ViewController(@"OrderListSB", @"OrderListViewController");
    }else{
        return ViewController(@"NofuncSB", @"NoFuncViewController");
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
