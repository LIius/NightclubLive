//
//  NCSheetView.h
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//  说明
/*
 *  用于展示底部Sheet的自定义视图view，可以改变其颜色和位置
 *  本项目使用自带的actionSheet会报数组越界的错误，至今还没找到原因，只会出现在iOS9以下的系统
 */

#import <MMPopupView/MMPopupView.h>
#import "MMPopupDefine.h"
@interface NCSheetView : MMPopupView

- (instancetype) initWithTitle:(NSString*)title
                         items:(NSArray*)items;

@end

/**
 *  Global Configuration of MMSheetView.
 */
@interface NCSheetViewConfig : NSObject

+ (NCSheetViewConfig*) globalConfig;

@property (nonatomic, assign) CGFloat buttonHeight;         // Default is 50.
@property (nonatomic, assign) CGFloat innerMargin;          // Default is 19.

@property (nonatomic, assign) CGFloat titleFontSize;        // Default is 14.
@property (nonatomic, assign) CGFloat buttonFontSize;       // Default is 17.

@property (nonatomic, strong) UIColor *backgroundColor;     // Default is #FFFFFF.
@property (nonatomic, strong) UIColor *titleColor;          // Default is #666666.
@property (nonatomic, strong) UIColor *splitColor;          // Default is #CCCCCC.

@property (nonatomic, strong) UIColor *itemNormalColor;     // Default is #333333. effect with MMItemTypeNormal
@property (nonatomic, strong) UIColor *itemDisableColor;    // Default is #CCCCCC. effect with MMItemTypeDisabled
@property (nonatomic, strong) UIColor *itemHighlightColor;  // Default is #E76153. effect with MMItemTypeHighlight
@property (nonatomic, strong) UIColor *itemPressedColor;    // Default is #EFEDE7.

@property (nonatomic, strong) NSString *defaultTextCancel;  // Default is "取消"

@end
