//
//  UILabel+NavTitleView.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/10/11.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "UILabel+NavTitleView.h"

@implementation UILabel (NavTitleView)

+ (UILabel *)navWithTitle:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,200, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    
    return titleLabel;
}

@end
