//
//  MRCTableViewController.h
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 14/12/27.
//  Copyright (c) 2014年 leichunfeng. All rights reserved.
//

#import "BaseViewController.h"
@interface BaseFormTableViewController : UITableViewController


@property (nonatomic, strong) MRCViewModel *viewModel;

+ (instancetype)controllerWithViewModel:(id)viewModel andSbName:(NSString *)name;
- (void)bindViewModel;

- (void)reloadData;

@end
