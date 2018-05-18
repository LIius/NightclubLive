//
//  ObjectTableViewCell.h
//  YIDAI
//
//  Created by RDP on 2017/1/17.
//  Copyright © 2017年 RDP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObjectTableViewCell : UITableViewCell
//传递参数
@property (nonatomic, weak) id model;
//参数
@property (nonatomic, weak) NSDictionary *optional;
//tableview
@property (nonatomic, weak) UITableView *tableView;
//路径
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) NSInteger tag;
/**
 *  重用cell
 *
 *  @param tableView 试图
 *
 *  @return 对象
 */
+ (UITableViewCell *)dequeueReusableWithTableView:(UITableView *)tableView;
/**
 *  获取Cell可重复使用ID
 *
 *  @return NSString
 */
+ (NSString *)getCellReuseID;
@end
