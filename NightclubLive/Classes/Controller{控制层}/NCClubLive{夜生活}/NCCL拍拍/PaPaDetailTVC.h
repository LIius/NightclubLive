//
//  PaPaDetailTVC.h
//  NightclubLive
//
//  Created by WanBo on 16/12/8.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "BaseTableViewController.h"
#import "PaiPaiModel.h"


@class PaPaDetailVC;

@interface PaPaDetailTVC : BaseTableViewController

@property (nonatomic, strong)PaiPaiModel *model;
//父类视图
@property (nonatomic, weak) PaPaDetailVC *superVC;

/**
 *  获取数据但是不刷新
 */
- (void)getDataButNoRefresh;
/**
 *  重新加载数据到界面
 */
- (void)reloadDataToView;

@end
