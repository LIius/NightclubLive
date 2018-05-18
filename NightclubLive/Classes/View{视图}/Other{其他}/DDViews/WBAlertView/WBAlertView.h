//
//  WBAlertView.h
//  NightclubLive
//
//  Created by RDP on 2017/4/10.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBAlertView : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *okTitle;
@property (nonatomic, copy) CalkBackBlock okBlock;
//@property (nonatomic, readonly)*content;
+ (instancetype)alertTitle:(NSString *)title contentView:(UIView *)contentView;

- (void)showView:(UIView *)view;
- (void)close;
@end
