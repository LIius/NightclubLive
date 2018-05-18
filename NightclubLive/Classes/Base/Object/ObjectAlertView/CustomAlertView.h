//
//  CustomAlertView.h
//  NightclubLive
//
//  Created by RDP on 2017/3/27.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectView.h"

@interface CustomAlertView : ObjectView
/** 内容展示的View */
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) CalkBackBlock calkBackBlock;

- (void)show;
- (void)close;
@end
