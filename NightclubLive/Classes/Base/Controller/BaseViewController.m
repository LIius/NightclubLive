//
//  MRCViewController.m
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 14/12/27.
//  Copyright (c) 2014年 leichunfeng. All rights reserved.
//

#import "BaseViewController.h"
#import "MRCViewModel.h"
#import "LoginViewModel.h"
#import "IQKeyboardManager.h"

@interface BaseViewController ()


@end

@implementation BaseViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BaseViewController *viewController = [super allocWithZone:zone];

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
    BaseViewController *baseVC = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    baseVC.viewModel = viewModel;
    return baseVC;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BaseViewController *)initWithViewModel:(id)viewModel {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

- (void)bindViewModel {
    //token过期处理
    [self.viewModel.errors subscribeNext:^(NSError *error) {
        
        if ([error.domain isEqual:netWorkErrorDomain] && error.code == 360) {
        //    [LoginTools jumpToLoginView];
        }else  if ([error.domain isEqual:netWorkErrorDomain]&& error.code == 278) {
            [self.view makeToast:@"貌似网络已断开" duration:2 position:CSToastPositionCenter];
        }else if([error.domain isEqual:netWorkErrorDomain]&& error.code == 279){
            [self.view makeToast:@"网络错误，请检查您的网络" duration:2 position:CSToastPositionCenter];
        }
    }];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.viewModel.willDisappearSignal sendNext:nil];

}

- (BOOL)shouldAutorotate {
    return YES;
}

@end
