//
//  SeatHeadIView.m
//  NightclubLive
//
//  Created by RDP on 2017/7/3.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "SeatHeadIView.h"

@interface SeatHeadIView()


@end

@implementation SeatHeadIView

- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, SCREEN_WIDTH, 15)];
    titleLabel.textColor = RGBCOLOR(51, 51, 51);
    titleLabel.text = @"我是测试";
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
}

@end
