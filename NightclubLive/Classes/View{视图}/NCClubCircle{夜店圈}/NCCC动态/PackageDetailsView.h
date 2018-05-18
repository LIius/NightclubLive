//
//  PackageDetailsView.h
//  NightclubLive
//
//  Created by RDP on 2017/6/29.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectView.h"

@class  BarPackageModel;

@interface PackageDetailsView : ObjectView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 套餐模型 */
@property (nonatomic, weak) BarPackageModel *packagemodel;

- (void)reloadDataToView;
@end
