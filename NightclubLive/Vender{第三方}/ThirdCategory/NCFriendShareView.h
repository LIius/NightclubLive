//
//  NCFriendShareView.h
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/1.
//  Copyright © 2017年 WanBo. All rights reserved.
//  说明
/*
 *  分享的视图，因为使用多层弹框时，遇到添加到keywindow失效问题
 *  于是用了继承MMPopupView来实现分享视图添加，多次弹框，用原来的方式，是弹不出分享视图
 */

#import <MMPopupView/MMPopupView.h>

@class ShareView;

@interface NCFriendShareView : MMPopupView

@property(nonatomic,weak)ShareView *shareView;

@end
