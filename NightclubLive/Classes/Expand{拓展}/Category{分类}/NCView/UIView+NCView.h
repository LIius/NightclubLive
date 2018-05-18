//
//  UIView+NCView.h
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NCView)

/** 宽 */
@property (nonatomic) CGFloat width;
/** 高 */
@property (nonatomic) CGFloat height;
/** x坐标 */
@property (nonatomic) CGFloat x;
/** y 坐标 */
@property (nonatomic) CGFloat y;
/** 大小 */
@property (nonatomic) CGSize size;
/** 位置 */
@property (nonatomic) CGPoint origin;
/** 最大X */
@property (nonatomic, assign) CGFloat maxX;
/** 最大Y */
@property (nonatomic, assign) CGFloat maxY;


/** 是否设置成圆形 */
@property (nonatomic,assign) BOOL isRound;

/**
 设置view frame
 
 @param x      x坐标
 @param y      y坐标
 @param width  width坐标
 @param height height坐标
 */
- (void)setViewFrameWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

/**
 设置view 的边框宽度 + 边框颜色
 
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 */
- (void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

/**
 设置阴影
 
 @param color   阴影颜色
 @param radius  弧度
 @param opacity 都名都
 @param offset  偏移位
 */
- (void)setShadowColor:(UIColor *)color radius:(CGFloat)radius opacity:(CGFloat)opacity offset:(CGSize)offset;

/** 从xib 加载xib */
+ (instancetype)initFromXIB;

#pragma Mark- 圆角
// 圆角
+(UIView *)cornerWithView:(UIView *)view radius:(CGFloat)radius;
// 边框+颜色
+(UIView *)cornerWithView:(UIView *)view borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
// 边框+颜色+圆角
+ (UIView *)cornerWithView:(UIView *)view borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor radius:(CGFloat)radius;
// 圆形按钮
+(UIView *)cycleToButton:(UIView *)view andBorderWidth:(CGFloat)width andColor:(UIColor *)color;

// 常用在用户头像
+ (UIView *)cyclyButton:(UIView *)view;
+ (UIView *)cyclyView:(UIView *)view;

@end
