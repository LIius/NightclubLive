//
//  UIView+NCView.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "UIView+NCView.h"

@implementation UIView (NCView)

@dynamic origin;
@dynamic size;
@dynamic isRound;

#pragma mark - Set

- (void)setX:(CGFloat)x{
    
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setY:(CGFloat)y{
    
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
}

- (void)setWidth:(CGFloat)width{
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)setHeight:(CGFloat)height{
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (void)setIsRound:(BOOL)isRound{
    
    if(isRound){
        
        [self layoutIfNeeded];
        
        CGFloat cornerRadius = self.height * 0.5;
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = cornerRadius;
    }
}

#pragma mark - Get

- (CGFloat)width{
    
    return self.frame.size.width;
}

- (CGFloat)height{
    
    return self.frame.size.height;
}

- (CGFloat)x{
    
    return self.frame.origin.x;
}

- (CGFloat)y{
    
    return self.frame.origin.y;
}

- (CGSize)size{
    
    return self.frame.size;
}

- (CGPoint)origin{
    
    return self.frame.origin;
}

- (CGFloat)maxX{
    
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY{
    
    return CGRectGetMaxY(self.frame);
}

#pragma mark - 公有方法

- (void)setViewFrameWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height{
    
    self.frame = CGRectMake(x, y, width, height);
    
}

- (void)setBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

- (void)setShadowColor:(UIColor *)color radius:(CGFloat)radius opacity:(CGFloat)opacity offset:(CGSize)offset{
    
    CALayer *layer = self.layer;
    layer.shadowColor = color.CGColor;
    layer.shadowRadius = radius;
    layer.shadowOffset = offset;
    layer.shadowOpacity = opacity;
}

+ (instancetype)initFromXIB{
    return nil;
}



#pragma mark - 圆角
+ (UIView *)cornerWithView:(UIView *)view radius:(CGFloat)radius
{
    view.layer.cornerRadius = radius;
    view.layer.masksToBounds=YES;
    return view;
}

+ (UIView *)cornerWithView:(UIView *)view borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    view.layer.borderColor= borderColor.CGColor;
    view.layer.borderWidth = borderWidth;
    return view;
}

+ (UIView *)cornerWithView:(UIView *)view borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor radius:(CGFloat)radius
{
    view.layer.cornerRadius = radius;
    view.layer.borderColor= borderColor.CGColor;
    view.layer.borderWidth = borderWidth;
    return view;
}

// 常用在用户头像
+ (UIView *)cyclyButton:(UIView *)view
{
    view.layer.cornerRadius = view.frame.size.width/2;
    view.layer.masksToBounds=YES;
    return view;
}

+ (UIView *)cyclyView:(UIView *)view
{
    view.layer.cornerRadius = view.frame.size.width/2;
    view.layer.masksToBounds=YES;
    return view;
}

+ (UIView *)cycleToButton:(UIView *)view andBorderWidth:(CGFloat)width andColor:(UIColor *)color
{
    view.layer.cornerRadius = view.frame.size.width/2;
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = width;
    UIButton *btn = (UIButton *)view;
    [btn setTitleColor:color forState:UIControlStateNormal];
    return view;
}

@end
