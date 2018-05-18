//
//  WheelView.h
//  NightclubLive
//
//  Created by RDP on 2017/3/17.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  转动block
 *
 *  @param angel 角度
 */
typedef void (^Anmitioning)(NSInteger angel);

@interface WheelView : UIView
/**
 *  叶子图片
 */
@property (nonatomic, strong) NSURL *leafImageURL;
/*
 *  转动时候调用的block
 */
@property (nonatomic, copy) Anmitioning turnBlock;
/**
 *  开始转动调用的回调
 */
@property (nonatomic, copy) CalkBackBlock startAnmitaion;
/** 结束动画 */
@property (nonatomic, copy) CalkBackBlock endAnimation;

+ (instancetype)wheel;
/**
 *  出现界面
 */
- (void)appear;
/**
 *  消失
 */
- (void)dispaer;

/**
 *  停止转动并在特定角度停止
 *
 *  @param angel 角度
 */
- (void)endAnmitionWithAngel:(NSInteger)stopAngel;

@end
