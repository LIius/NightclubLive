//
//  UIButton+NCButton.h
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//
/*
 *  UIButton的分类，添加一些常用的函数
 */

#import <UIKit/UIKit.h>

@interface UIButton (NCButton)

typedef NS_ENUM(NSUInteger, ButtonStyle) {
    ButtonStyleImageTopTitleBottom,     // image在上，label在下
    ButtonStyleImageLeftTitleRight,    // image在左，label在右
    ButtonStyleImageBottomTitleTop,  // image在下，label在上
    ButtonStyleImageRightTitleLeft    // image在右，label在左
};

- (void)buttonImageLeftImageRightLabelWithImageString:(NSString *)imageString margin:(CGFloat )margin;

- (void)buttonImageupLabeldownAtImageString:(NSString *)imageString;

- (void)buttonImageupLabeldownAtImage:(UIImage *)image margin:(CGFloat )margin;

- (void)buttonImageupLabeldownAtImageString:(NSString *)imageString margin:(CGFloat )margin;

- (void)buttonStyle:(ButtonStyle)style margin:(CGFloat)space;



/**
 *  倒计时按钮
 *
 *  @param timeLine 倒计时总时间
 *  @param title    还没倒计时的title
 *  @param subTitle 倒计时中的子名字，如时、分
 *  @param mColor   还没倒计时的颜色
 *  @param color    倒计时中的颜色
 */
- (void)startWithTime:(NSInteger)timeLine
                title:(NSString *)title
       countDownTitle:(NSString *)subTitle
            mainColor:(UIColor *)mColor
           countColor:(UIColor *)color;

@end
