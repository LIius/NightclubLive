//
//  MyPrizeListViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//
/*
 如果重复请求，那下拉刷新条不会弹回去，注意请求问题
 
 */

#import "MyPrizeListViewController.h"
#import "MyPrizeListCell.h"
#import "MineRequest.h"
#import "GiftDetailViewController.h"
#import "MineModelList.h"
#import "GiftInfoViewController.h"
#import "EmptyBigView.h"

@interface MyPrizeListViewController ()

@property(nonatomic,strong)UIView *emptyView;

@end

@implementation MyPrizeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isFoot = YES;
    self.isHead = YES;
}

#pragma mark - Request
- (void)refreshMethod
{
    MyPrizeListRequest *r = [MyPrizeListRequest new];
    NSNumber *pageNow = @(self.pageNow);
    r.model = pageNow;
    
    [r startRequestWithCompleted:^(ResponseState *state)
    {
        self.parses = [PrizeListModel arrayObjectWithDS:state.data];

    }];
}

#pragma mark - Table View Data

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource.count == 0 )
    {
        if (!_emptyView)
        {
            UIView *v = [EmptyBigView viewWithTip:@"什么奖品都没有呢~"];
  
            v.frame = [NCEmpty getEmtpyViewRectWithScrollView:self.tableView];
            [self.view addSubview:v];
            _emptyView = v;
        }
        
    }else{
        if (_emptyView)
            [_emptyView removeFromSuperview];
        
    }
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    
    MyPrizeListCell *cell = [tableView dequeueReusableCellWithIdentifier:MyPrizeListCellReuseID];
    
    cell.indexPath = indexPath;
    cell.model = self.dataSource[indexPath.row];

    cell.getBlock = ^(NSIndexPath *vIndexPath)
    {
        @strongify(self);
        [self goGiftInfo:vIndexPath];
    };
    
    // 查看详情
    cell.seeBlock = ^(NSIndexPath *vIndexPath)
    {
        @strongify(self);
        [self goDetailVC:vIndexPath];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (void)goGiftInfo:(NSIndexPath *)vIndexPath
{
    GiftInfoViewController *vc = ViewController(@"GiftInfoSB", @"GiftInfoViewController");
    PrizeListModel *m = self.dataSource[vIndexPath.row];
    
    if (m.status == 0){
        vc.model = m;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)goDetailVC:(NSIndexPath *)vIndexPath
{
    GiftDetailViewController *vc = ViewController(@"GiftDetailSB", @"GiftDetailViewController");
    vc.model = self.dataSource[vIndexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
