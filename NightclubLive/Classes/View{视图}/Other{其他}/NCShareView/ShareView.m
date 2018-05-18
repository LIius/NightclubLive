//
//  SelectSexView.m
//  AgileCarRental
//
//  Created by WanBo on 16/9/11.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "ShareView.h"

@implementation ShareView

+ (instancetype)shareView{
    
    ShareView *view = [[[NSBundle mainBundle]loadNibNamed:@"ShareView" owner:self options:nil]lastObject];

    
    return view;
    
}

- (void)setUP{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIButton *maskView = [[UIButton alloc]init];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.4;
    maskView.frame = CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height);
    [maskView addTarget:self action:@selector(dismissMaskView) forControlEvents:UIControlEventTouchUpInside];
    _maskView = maskView;
    [window addSubview:maskView];
}



- (void)dismissMaskView{
    [_maskView removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        //480 是屏幕尺寸
        self.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 260);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showMaskView{
    
    self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 105);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame=CGRectMake(0, SCREEN_HEIGHT-105, SCREEN_WIDTH, 105);
    }];

}

@end
