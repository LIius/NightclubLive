//
//  MyNextViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MyNextViewController.h"
#import "MyNextCell.h"
#import "MineRequest.h"
#import "MineRequest.h"

@interface MyNextViewController ()

@end

@implementation MyNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isFoot = YES;
    self.isHead = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - request
- (void)refreshMethod
{
    MyNextListRequest *r = [MyNextListRequest new];
    NSNumber *pageNow = @(self.pageNow);
    r.model = pageNow;
    [r startRequestWithCompleted:^(ResponseState *state) {
        self.parses = [MyNextListModel arrayObjectWithDS:state.data];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyNextCell *cell = [tableView dequeueReusableCellWithIdentifier:MyNextCellReuseID];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (NSAttributedString *)emptyString
{
    return [[NSAttributedString alloc] initWithString:@"暂时没有好友受邀加入"];
}

@end
