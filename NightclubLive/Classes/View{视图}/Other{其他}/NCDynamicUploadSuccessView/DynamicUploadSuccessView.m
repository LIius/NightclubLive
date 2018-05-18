//
//  MyRoleView.m
//  NightclubLive
//
//  Created by WanBo on 16/11/27.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "DynamicUploadSuccessView.h"

@implementation  DynamicUploadSuccessView

+ (instancetype)dynamicUploadSuccessView{
    
    DynamicUploadSuccessView *view = [[[NSBundle mainBundle]loadNibNamed:@"DynamicUploadSuccessView" owner:self options:nil]lastObject];
    return view;
    
}

- (void)show
{
    self.alertWidth = 250.0f;
    self.lertHeight = 135.0f;
    self.bottom_Height = 100.0f;
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - self.alertWidth) * 0.5, - self.lertHeight - 30, self.alertWidth,self.lertHeight);
    [topVC.view addSubview:self];
    
    //确定
    [[_doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self removeFromSuperview];
        
        if (_okBlock)
            _okBlock(nil);
    }];
}


@end


