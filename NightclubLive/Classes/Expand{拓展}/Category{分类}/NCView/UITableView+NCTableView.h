//
//  UITableView+NCTableView.h
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (NCTableView)

/** 设置背景图 */
- (void)setBackgroundImage:(UIImage *)backImage;

/** reload */
/** 在主线程刷新线程 */
- (void)reloadInMain;
//结束刷新
- (void)endRefresh;
/**
 插入row
 
 @param indexPaths 行源
 @param animation  动画类型
 */
- (void)insertRowsInMainAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
/**
 删除row
 
 @param indexPaths 行源
 @param animation  动画类型
 */
- (void)deleteRowsInMainAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;

@end
