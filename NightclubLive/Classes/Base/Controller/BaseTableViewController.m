//
//  MRCTableViewController.m
//  MVVMReactiveCocoa
//
//  Created by leichunfeng on 14/12/27.
//  Copyright (c) 2014年 leichunfeng. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MRCTableViewModel.h"
#import "LoginViewModel.h"
#import "MJRefresh.h"
#import "IQKeyboardManager.h"

@interface BaseTableViewController ()
@end

@implementation BaseTableViewController

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    BaseTableViewController *viewController = [super allocWithZone:zone];
    
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
    BaseTableViewController *baseVC = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    baseVC.viewModel = viewModel;
    
    return baseVC;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.viewModel shouldRequestRemoteDataOnViewDidLoad]) {
        @weakify(self)
        [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
            @strongify(self)
            [self.viewModel.requestRemoteDataCommand execute:@1];
        }];
    }
    @weakify(self)
    if (self.viewModel.shouldPullToRefresh) {

        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        MJRefreshHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self)
            @weakify(self)
            [[[self.viewModel.requestRemoteDataCommand
               execute:@1]
              deliverOnMainThread]
             subscribeNext:^(id x) {
                 @strongify(self)
                 self.viewModel.page = 1;
             } error:^(NSError *error) {
                 @strongify(self)
                 [self.tableView.mj_header endRefreshing];
             } completed:^{
                 @strongify(self)
                 [self.tableView.mj_header endRefreshing];
             }];
            
        }];
        self.tableView.mj_header = header;
    }
    
    _isShowEmptyDataView = YES;
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}


- (void)bindViewModel {
    
    //token过期处理
    [self.viewModel.errors subscribeNext:^(NSError *error) {
        
        if ([error.domain isEqual:netWorkErrorDomain] && error.code == 360) {
           // [LoginTools jumpToLoginView];
        }else  if ([error.domain isEqual:netWorkErrorDomain]&& error.code == 278) {
            [self.view makeToast:@"貌似网络已断开" duration:2 position:CSToastPositionCenter];
        }else if([error.domain isEqual:netWorkErrorDomain]&& error.code == 279){
            [self.view makeToast:@"网络错误，请检查您的网络" duration:2 position:CSToastPositionCenter];
        }
    }];
    
    @weakify(self)
    [[[RACObserve(self.viewModel, dataSource)
       distinctUntilChanged]
      deliverOnMainThread]
     subscribeNext:^(id x) {
         @strongify(self)
         [self reloadData];
     }];
    
    [self.viewModel.requestRemoteDataCommand.executing subscribeNext:^(NSNumber *executing) {
        @strongify(self)
//        [executing boolValue]&&self.viewModel.dataSource==0? [SVProgressHUD show]:[SVProgressHUD dismiss];
        
        UIView *emptyDataSetView = [self.tableView.subviews.rac_sequence objectPassingTest:^(UIView *view) {
            return [NSStringFromClass(view.class) isEqualToString:@"DZNEmptyDataSetView"];
        }];
        emptyDataSetView.alpha = 1.0 - executing.floatValue;
        if ( self.viewModel.dataSource.count!=0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.tableHeaderView.hidden = NO;
                [self.tableView reloadData];
            });
            
        }else{
            //            self.tableView.tableHeaderView.hidden = YES;
            
        }
        
        
    }];
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView dequeueReusableCellWithIdentifier:@"MRCTableViewCellStyleValue1" forIndexPath:indexPath];
    
    id object = self.viewModel.dataSource[indexPath.row];
    [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.viewModel.clickIndex = indexPath.row;
    [self.viewModel.didSelectCommand execute:indexPath];
}



#pragma mark - Listening for the user to trigger a refresh

- (void)refreshTriggered:(id)sender {
    @weakify(self)
    [[[self.viewModel.requestRemoteDataCommand
       execute:@1]
     	deliverOnMainThread]
    	subscribeNext:^(id x) {
            @strongify(self)
            self.viewModel.page = 1;
        } error:^(NSError *error) {
            @strongify(self)
            //            [self.refreshControl finishingLoading];
        } completed:^{
            @strongify(self)
            //            [self.refreshControl finishingLoading];
        }];
}



#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    if (_isShowEmptyDataView) {
        return [[NSAttributedString alloc] initWithString:@"没数据"];

    }else{
        return nil;
    }
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.viewModel.dataSource.count == 0;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGPoint)offsetForEmptyDataSet:(UIScrollView *)scrollView {
    return CGPointMake(0, -(self.tableView.contentInset.top - self.tableView.contentInset.bottom) / 2);
}



@end
