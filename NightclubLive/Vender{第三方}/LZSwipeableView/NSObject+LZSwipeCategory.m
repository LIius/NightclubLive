//
//  NSObject+LZSwipeCategory.m
//  LZSwipeableViewDemo
//
//  Created by liuzhouji on 16/4/20.
//  Copyright © 2016年 LeoZ. All rights reserved.
//

#import "NSObject+LZSwipeCategory.h"

@implementation UIView (LZSwipeCategory)
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x{
    return self.frame.origin.x;
}
- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y{
    return self.frame.origin.y;
}
- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


- (UIView*)snapshotView {
    return [self snapshotViewAfterScreenUpdates:YES];
}

- (void)removeAllSubviews {
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
}

+ (instancetype)viewFromXib{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}
@end

@implementation UIColor (LZSwipeCategory)

@end


@implementation UIButton (LZSwipeCategory)

+(UIBarButtonItem *)createNavBarButtonItemWithText:(NSString *)btnTitle target:(id)target{
    
    CGSize textSize = [btnTitle boundingRectWithSize:CGSizeMake(80, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil].size;
    
    if (textSize.width > 80) {
        textSize.width = 80;
    }
    
    //[UIColor colorWithHex:0xff8420]
    UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tempButton.frame = CGRectMake(0, 0, textSize.width, 40);
    [tempButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [tempButton setTitle:btnTitle forState:UIControlStateNormal];
    tempButton.backgroundColor=[UIColor clearColor];
    tempButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [tempButton addTarget:target action:@selector(navButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * shareBarButton = [[UIBarButtonItem alloc] initWithCustomView:tempButton];
    
    return shareBarButton;
}

@end





