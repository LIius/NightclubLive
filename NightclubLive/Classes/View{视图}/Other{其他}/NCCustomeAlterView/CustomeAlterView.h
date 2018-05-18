//
//  CustomeAlterView.h
//  NightclubLive
//
//  Created by WanBo on 16/11/27.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomeAlterView : UIView
@property(nonatomic,strong)UIControl * control;;
@property(nonatomic,assign)float alertWidth;
@property(nonatomic,assign)float lertHeight;
@property(nonatomic,assign)float bottom_Height ;

+ (instancetype)rechargeAlterView;
- (void)show;
- (UIViewController *)appRootViewController;
- (void)removeFromSuperview;

@end
