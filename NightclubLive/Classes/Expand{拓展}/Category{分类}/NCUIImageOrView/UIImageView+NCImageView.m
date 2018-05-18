//
//  UIImageView+NCImageView.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "UIImageView+NCImageView.h"

@implementation UIImageView (NCImageView)

#pragma mark - 调整图片尺寸
- (void)autoAdjustWidth{
    [self autoAdjustWithMask:UIViewAutoresizingFlexibleWidth];
}

- (void)autoAdjustHeight{
    [self autoAdjustWithMask:UIViewAutoresizingFlexibleHeight];
}

- (void)autoAdjustWithMask:(UIViewAutoresizing)mask{
    
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.autoresizingMask = mask;
    self.clipsToBounds = YES;
    
}

@end
