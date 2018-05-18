//
//  MyBillDetailTableViewController.h
//  NightclubLive
//
//  Created by SuperDanny on 2016/12/11.
//  Copyright © 2016年 WanBo. All rights reserved.
//
//  订单详情

#import "ObjectTableViewController.h"

@class OrderListModel;

@interface MyBillDetailTableViewController : ObjectTableViewController

/** 订单模型 */
@property (nonatomic, strong) OrderListModel *orderModel;
/** 订单ID */
@property (nonatomic, copy) NSString *orderID;
/** 更新block */
@property (nonatomic, copy)  CalkBackBlock  updateBlock;

@end
