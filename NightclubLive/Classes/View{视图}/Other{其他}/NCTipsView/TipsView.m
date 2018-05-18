//
//  TipsView.m
//  NightclubLive
//
//  Created by WanBo on 16/11/27.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "TipsView.h"

@implementation TipsView

+ (instancetype)tipsView{
    TipsView *view = [[[NSBundle mainBundle]loadNibNamed:@"TipsView" owner:self options:nil]lastObject];
    return view;
}
- (void)show
{
    self.alertWidth = 250.0f;
    self.lertHeight = 135.0f;
    self.bottom_Height = 100.0f;

    [self.doneBtn setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"E0E0E0"] rect:CGRectMake(0, 0, self.doneBtn.bounds.size.width, self.doneBtn.bounds.size.height)] forState:UIControlStateHighlighted];
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - self.alertWidth) * 0.5, - self.lertHeight - 30, self.alertWidth,self.lertHeight);
    [topVC.view addSubview:self];
}
- (IBAction)cancleAction:(id)sender {
    [super removeFromSuperview];
}


//根据颜色创建一个图片
- (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
