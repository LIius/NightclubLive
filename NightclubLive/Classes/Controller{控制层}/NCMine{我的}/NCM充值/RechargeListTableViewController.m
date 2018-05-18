//
//  RechargeListTableViewController.m
//  NightclubLive
//
//  Created by SuperDanny on 2016/12/13.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "RechargeListTableViewController.h"
#import "MineModelList.h"
#import "MineRequest.h"
#import "LogCell.h"

@interface RechargeListTableViewController ()

@end

@implementation RechargeListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshView = self.tableView;
    self.isFoot = YES;
    self.isHead = YES;
    self.isShowEmpty = NO;
    self.tableView.rowHeight = 60;
    [self requestBegin];
}

- (void)refreshMethod
{
    RechargeLogListRequest *r = [RechargeLogListRequest new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.pageNow) {
        [params setValue:@(self.pageNow) forKey:@"pageNow"];
    }
    if (CurrentUser.userID.length > 0) {
        [params setValue:CurrentUser.userID forKey:@"userId"];
    }
    
    r.param = params;

    [r startRequestWithCompleted:^(ResponseState *state) {
        
        self.parses = [RechargeLogModel arrayObjectWithDS:state.data];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LogCell *cell = [tableView dequeueReusableCellWithIdentifier:LogCellReuseID];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 100, 30)];
    label.textColor = UIColorHex(0x323334);
    label.text = @"历史充值记录";
    label.font = [UIFont systemFontOfSize:13];
    [view addSubview:label];
    return view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
