//
//  ClubCircleVoiceVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/2.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "ClubCircleVoiceVC.h"
#import "ClubCircleVoiceCell.h"
#import "ClubCircleGuiMiVoiceVC.h"
#import "ClubCircleVoiceViewModel.h"
#import "VoiceListModel.h"
#import "ClubCircleGuiMiVoiceViewModel.h"
#import "EmptyBigView.h"


@interface ClubCircleVoiceVC ()

@property (nonatomic, strong) ClubCircleVoiceViewModel *viewModel;
@property(nonatomic,strong)UIView *emptyView;

@end

@implementation ClubCircleVoiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 控制器附一个空值，这个控制器没用这个参数
    self.dataSource = @[@""].mutableCopy;
    
    [self setupTableView];
    
    [self listenRequestResult];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.viewModel.datas.count == 0)
    {
        [self.refresh_tableView.mj_header beginRefreshing];
    }
}

- (void)setupTableView
{
    self.refresh_tableView = self.tableView;
    self.haveRefreshHead   = YES;
    MJRefreshNormalHeader *head = (MJRefreshNormalHeader *)self.tableView.mj_header;
    head.stateLabel.hidden = YES;
}

- (void)listenRequestResult
{
    self.viewModel = [ClubCircleVoiceViewModel new];
    [self.viewModel.getListcommand.executionSignals.switchToLatest subscribeNext:^(id x)
     {
         if (x[@"dataCount"] > 0)
         {
             [self.tableView reloadInMain];
             [self.tableView endRefresh];
         }
         else{
             [self.view makeToast:x[@"msg"] duration:1.0 position:CSToastPositionCenter];
         }
     }];
}

#pragma mark - Request
- (void)requestDataFromServer
{
    [self.viewModel.getListcommand execute:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (self.viewModel.datas.count == 0 )
    {
        if (!_emptyView)
        {
            UIView *v = [EmptyBigView viewWithTip:@"还没有心声主题呢~"];
            v.frame = [NCEmpty getEmtpyViewRectWithScrollView:self.tableView];
            [self.view addSubview:v];
            _emptyView = v;
        }
        
    }else{
        if (_emptyView){
            [_emptyView removeFromSuperview];
        }
        
    }
    return self.viewModel.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ClubCircleVoiceCell";
    ClubCircleVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell bindModel:self.viewModel.datas[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 114;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoiceListModel *listModel = self.viewModel.datas[indexPath.row];
    
    ClubCircleGuiMiVoiceViewModel *viewModel = [[ClubCircleGuiMiVoiceViewModel alloc] initWithParams:nil];
    viewModel.shouldPullToRefresh = YES;
    viewModel.model = listModel;
    ClubCircleGuiMiVoiceSuperVC *vc = [ClubCircleGuiMiVoiceSuperVC controllerWithViewModel:viewModel andSbName:@"ClubCircleGuiMiVoiceSuperSB"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
