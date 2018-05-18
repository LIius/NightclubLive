//
//  CommentListViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/7/5.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "CommentListViewController.h"
#import "CommentCell.h"
#import "MessageModelList.h"
#import "PaPaDetailVC.h"
#import "ClubCircleDynamicDetailVC.h"
#import "DynamicListModel.h"
#import "ClubCircleGuiMiVoiceViewModel.h"
#import "VoiceListModel.h"
#import "ClubCircleGuiMiVoiceVC.h"


static NSInteger pageSize = 15;

@interface CommentListViewController ()<NIMSystemNotificationManager>

/** 对象 */
@property (nonatomic, weak) NIMSession *model;
/** 老长度 */
@property (nonatomic, assign) NSInteger oldLength;

@end

@implementation CommentListViewController
@dynamic model;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    
    [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:self.model
     
     ];
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension
    ;
    
    self.isHead = YES;
    self.isFoot = YES;
    
    [self requestBegin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Refresh

- (void)refreshMethod{
    
    NSInteger limit = self.pageNow * pageSize;
    
    NSArray *array  = [[NIMSDK sharedSDK].conversationManager messagesInSession:self.model message:nil limit:limit];
    
    [self nimmessageconvertmodel:array];
    
    [self.tableView endRefresh];
    
    [self.tableView reloadInMain];
    
    if (self.refreshType == RefreshTypeLoadMore && _oldLength == array.count){
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    else{
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    _oldLength = array.count;
}

#pragma mark - Private Method

- (void)nimmessageconvertmodel:(NSArray *)arr{
    
    [self.dataSource removeAllObjects];
    
    for(NIMMessage *msg  in arr){
        [self.dataSource addObject:[CommentModel objectWithDic:msg.localExt]];
    }
}

#pragma mark - Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CommentCellReuseID];
    if (!cell)
    {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommentCellReuseID];
    }
    NSInteger currentIndex = (self.dataSource.count - indexPath.row - 1);
    
    cell.model =  self.dataSource[currentIndex];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger currentIndex = (self.dataSource.count - indexPath.row - 1);
    
    CommentModel *model = self.dataSource[currentIndex];
    
    // typeid: 1 - 动态 2-心声 4-拍拍
    if (model.typeId == 1){
        DynamicListModel  *jumpModel = model.m;
        ClubCircleDynamicDetailSuperVC *vc = [ClubCircleDynamicDetailSuperVC initSBWithSBName:@"ClubCircleDynamicDetailSuperSB"];
        vc.model = jumpModel;

        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if (model.typeId == 4){//拍拍
        
        PaiPaiModel *m = model.m;
        PaPaDetailVC *vc = [PaPaDetailVC controllerWithViewModel:nil andSbName:@"PapaDetailSB"];
        vc.model = m;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (model.typeId == 2){
        // 心声
        VoiceListModel *listModel = model.m;
        
        ClubCircleGuiMiVoiceViewModel *viewModel = [[ClubCircleGuiMiVoiceViewModel alloc] initWithParams:nil];
        viewModel.shouldPullToRefresh = YES;
        viewModel.model = listModel;
        ClubCircleGuiMiVoiceSuperVC *vc = [ClubCircleGuiMiVoiceSuperVC controllerWithViewModel:viewModel andSbName:@"ClubCircleGuiMiVoiceSuperSB"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    [self refreshMethod];
}

@end
