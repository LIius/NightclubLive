//
//  OrderListViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListCell.h"
#import "MineRequest.h"
#import "MineModelList.h"
#import "EmptyBigView.h"
#import "MyBillDetailTableViewController.h"

@interface OrderListViewController ()
@property(nonatomic,strong)UIView *emptyView;
@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    adjustsScrollViewInsets_NO(self.tableView,self);

    self.isFoot = YES;
    self.isHead = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Reqeus
- (void)refreshMethod
{
    [CurrentUser getYWBToken:^(NSString *token)
     {
        OrderListRequest *r = [OrderListRequest new];
         NSMutableDictionary *params = [NSMutableDictionary dictionary];
         if (self.pageNow) {
             [params setValue:@(self.pageNow) forKey:@"page"];
         }
         if (token.length > 0) {
             [params setValue:token forKey:@"token"];
         }
         
         r.param = params;

        [r startRequestWithCompleted:^(ResponseState *state) {
            
            self.parses = [OrderListModel arrayObjectWithDS:state.data];
        }];
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 30;
}

#pragma mark - Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource.count == 0 )
    {
        if (!_emptyView)
        {
            UIView *v = [EmptyBigView viewWithTip:@"什么订单都没有呢~"];
            CGFloat width = 150;
            CGFloat height = 50;
            CGFloat x = (SCREEN_WIDTH - width) * 0.5;
            CGFloat y = tableView.tableHeaderView.height + 24;
            
            v.frame = CGRectMake(x, y, width, height);
            [self.view addSubview:v];
            _emptyView = v;
        }
        
    }else{
        if (_emptyView)
            [_emptyView removeFromSuperview];
        
    }
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderListCellReuseID];
    if (!cell)
    {
        cell = [[OrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:OrderListCellReuseID];
    }

    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyBillDetailTableViewController *vc = ViewController(@"MyBillDetailSB", @"MyBillDetailTableViewController");
    vc.orderModel = self.dataSource[indexPath.row];
    @weakify(self);
    vc.updateBlock = ^(id param)
    {
        @strongify(self);
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.dataSource indexOfObject:param] inSection:0]] withRowAnimation:0];
    };
    
    PushViewController(vc);
}

@end
