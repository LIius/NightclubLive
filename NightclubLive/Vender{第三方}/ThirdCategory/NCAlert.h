//
//  NCAlert.h
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/1.
//  Copyright © 2017年 WanBo. All rights reserved.
//
/*
 *  主要用于弹框的工具类
 */

#import <Foundation/Foundation.h>

typedef void(^NCAlertHandler)(NSInteger index);

typedef void(^NCAlertHideBlock)();

@interface NCAlert : NSObject

+ (void)showActionSheetWithDataSource:(NSArray *)dataSource  title:(NSString *)title blockHandel:(NCAlertHandler)blockhandel hideBlock:(NCAlertHideBlock)hideBlock;

+ (void)showActionSheetWithDataSource:(NSArray *)dataSource blockHandel:(NCAlertHandler)blockhandel hideBlock:(NCAlertHideBlock)hideBlock;

+ (void)showActionSheetWithDataSource:(NSArray *)dataSource  title:(NSString *)title blockHandel:(NCAlertHandler)blockhandel;

+ (void)showActionSheetWithDataSource:(NSArray *)dataSource blockHandel:(NCAlertHandler)blockhandel;

@end
