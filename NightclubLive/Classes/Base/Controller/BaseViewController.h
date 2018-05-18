//
//  MRCViewController.h
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 14/12/27.
//  Copyright (c) 2014年 leichunfeng. All rights reserved.
//

@interface BaseViewController : UIViewController

/// The `viewModel` parameter in `-initWithViewModel:` method.
@property (nonatomic, strong, readwrite) MRCViewModel *viewModel;
+ (instancetype)controllerWithViewModel:(id)viewModel andSbName:(NSString *)name;

/// Initialization method. This is the preferred way to create a new view.
///
/// viewModel - corresponding view model
///
/// Returns a new view.
- (BaseViewController *)initWithViewModel:(id)viewModel;

/// Binds the corresponding view model to the view.
- (void)bindViewModel;

@end
