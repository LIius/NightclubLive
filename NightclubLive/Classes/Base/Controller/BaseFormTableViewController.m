//
//  MRCTableViewController.m
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 14/12/27.
//  Copyright (c) 2014年 leichunfeng. All rights reserved.
//

#import "BaseFormTableViewController.h"
#import "MRCTableViewModel.h"
#import "LoginViewModel.h"
#import "IQKeyboardManager.h"

@interface BaseFormTableViewController ()

@end

@implementation BaseFormTableViewController



+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BaseFormTableViewController *viewController = [super allocWithZone:zone];
    
    @weakify(viewController)
    [[viewController
      rac_signalForSelector:@selector(viewDidLoad)]
     subscribeNext:^(id x) {
         @strongify(viewController)
         [viewController bindViewModel];
     }];
    
    return viewController;
}

+ (instancetype)controllerWithViewModel:(id)viewModel andSbName:(NSString *)name{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    BaseFormTableViewController *baseVC = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    baseVC.viewModel = viewModel;

    return baseVC;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
}

- (void)bindViewModel {
    
    
    //token过期处理..其他错误处理
    //token过期处理
    [self.viewModel.errors subscribeNext:^(NSError *error) {
        
        if ([error.domain isEqual:netWorkErrorDomain] && error.code == 360) {
         //   [LoginTools jumpToLoginView];
        }else  if ([error.domain isEqual:netWorkErrorDomain]&& error.code == 278) {
            [self.view makeToast:@"貌似网络已断开" duration:2 position:CSToastPositionCenter];
        }else if([error.domain isEqual:netWorkErrorDomain]&& error.code == 279){
            [self.view makeToast:@"网络错误，请检查您的网络" duration:2 position:CSToastPositionCenter];
        }
    }];
    
}

- (void)reloadData {
    [self.tableView reloadData];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];

}

@end
