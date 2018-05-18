//
//  MRCTableViewController.h
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 14/12/27.
//  Copyright (c) 2014年 leichunfeng. All rights reserved.
//

#import "BaseViewController.h"
@class MRCTableViewModel;
@interface BaseTableViewController : UITableViewController 



@property (nonatomic, strong) MRCTableViewModel *viewModel;
@property (nonatomic, assign) BOOL isShowEmptyDataView;


+ (instancetype)controllerWithViewModel:(id)viewModel andSbName:(NSString *)name;

/// Binds the corresponding view model to the view.
- (void)bindViewModel;

- (void)reloadData;
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object;



@end
