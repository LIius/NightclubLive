//
//  CustomAlertView.m
//  NightclubLive
//
//  Created by RDP on 2017/3/27.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "CustomAlertView.h"
#import "ScottAlertController.h"

@implementation CustomAlertView

- (void)show{
    //先设定content大小
    self.contentView.width = 10;
    self.contentView.height = 10;
    self.contentView.center = self.superview.center;
    
    //进行动画设置
    [UIView animateWithDuration:1.0 animations:^{
        
        CGRect frame = self.contentView.frame;
        frame.size.width = 100;
        frame.size.height = 100;
        frame.origin.y = (self.superview.height - frame.size.height) * 0.5;
        frame.origin.x = (self.superview.width - frame.size.width) * 0.5;
        self.contentView.frame = frame;
    }];
}

- (void)close{

    [self dismiss];
    [self removeFromSuperview];
}



@end
