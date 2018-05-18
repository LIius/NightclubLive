//
//  UIAlertController+Factory.h
//  NightclubLive
//
//  UIAlertController 工程类方法
//  Created by RDP on 2017/3/7.
//  Copyright © 2017年 WanBo. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void (^CalkBackBlock)(id param);

@interface UIAlertController (Factory)
//@property (nonatomic, copy) CalkBackBlock calkBackBlock;
//@property (nonatomic, copy) CalkBackBlock calkBlock;
/**
 *  简单提示框
 *
 *  @param title   提示标题
 *  @param message 提示内容
 *
 *  @return 对象
 */
+ (instancetype)alertControllerWithTitle:(NSString *)title withMessage:(NSString *)message calk:(CalkBackBlock)calkBlock;

/**
 *  选择提示框
 *
 *  @param title   标题
 *  @param okBlock 选择OK调用的回调
 *  @message 提示消息
 *  @return 对象
 */
+ (instancetype)alertCancelAndOKWithTitle:(NSString *)title message:(NSString *)message okCalk:(CalkBackBlock)okBlock;
/**
 *  参考提示
 *
 *  @param title        标题
 *  @param message      提示文本
 *  @param actionTitles 操作按键提示
 *
 *  @return ni
 */
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message action:(NSArray *)actionTitles calk:(CalkBackBlock)calkBlock;

/**
 *  文本输入框
 *
 *  @param title   问题提示
 *  @param okBlock 回调
 *
 *  @return 对象
 */
+ (instancetype)alertControllerWithTitle:(NSString *)title okBlock:(CalkBackBlock)okBlock;


@end
