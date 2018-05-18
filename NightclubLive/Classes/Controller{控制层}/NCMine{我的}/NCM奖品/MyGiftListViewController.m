//
//  MyGiftListViewController.m
//  NightclubLive
//
//  Created by SuperDanny on 2016/12/14.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "MyGiftListViewController.h"
#import "MyGiftListCell.h"
#import "MineRequest.h"
#import "MineModelList.h"
#import "EmptyBigView.h"

#define kSegmentedHeight kTrueHeight(40, kScreenWidth)
#define kSubViewTag    19921020

@interface MyGiftListViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic,strong)UIView *emptyView;

@end

@implementation MyGiftListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isHead = YES;
    self.isFoot = YES;
    
    self.title = @"我的礼物";
}

#pragma mark - request
- (void)refreshMethod
{
    GetMyGiftListRequest *r = [GetMyGiftListRequest new];
    r.pageNow = @(self.pageNow);
    [r startRequestWithCompleted:^(ResponseState *state) {
        
        self.parses = [MyGiftListModel arrayObjectWithDS:state.data];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (self.dataSource.count == 0 )
    {
        if (!_emptyView)
        {
            UIView *v = [EmptyBigView viewWithTip:@"什么礼物都没有呢~"];
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
    MyGiftListCell *cell = [tableView dequeueReusableCellWithIdentifier:MyGiftListCellReuseID];
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
