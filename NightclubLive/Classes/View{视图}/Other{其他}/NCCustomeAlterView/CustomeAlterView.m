//
//  CustomeAlterView.m
//  NightclubLive
//
//  Created by WanBo on 16/11/27.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "CustomeAlterView.h"


@implementation CustomeAlterView

- (void)awakeFromNib{
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
}

- (void)show
{

}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!_control) {
        _control=[[UIControl alloc]initWithFrame:topVC.view.bounds];
        [_control addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        _control.backgroundColor=[UIColor blackColor];
        _control.alpha = 0.5;
    }
    [topVC.view addSubview:_control];
    
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - _alertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - _lertHeight) * 0.5, _alertWidth, _lertHeight);
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
    }];
    [super willMoveToSuperview:newSuperview];
}


- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)removeFromSuperview
{
    
    [self.control removeFromSuperview];
    self.control = nil ;
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - _alertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), _alertWidth, _lertHeight);
    
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        //        if (_leftLeave) {
        //            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
        //        }else {
        self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
        //        }
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
    
  //  UITableView *tableView;
//    [tableView dequeueReusableCellWithIdentifier:<#(nonnull NSString *)#>]
}
@end
