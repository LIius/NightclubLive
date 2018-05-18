//
//  MerchantAllActivityViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MerchantAllActivityViewController.h"
#import "MerchantActivityCell.h"
#import "NetRedCircleRequest.h"
#import "NetRedCircleListModel.h"
#import "WebActivityViewController.h"

@interface MerchantAllActivityViewController ()

/** 高度 */
@property (nonatomic, assign) CGFloat rowHeight;
/** 模型对象 */
@property (nonatomic, weak) NetRedCircleBarModel *model;

@end

@implementation MerchantAllActivityViewController

@dynamic model;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view layoutIfNeeded];
    _rowHeight = 45 + SCREEN_WIDTH * (345.0/375.0);
    
    self.isFoot = YES;
    self.isHead = YES;
}

#pragma mark - Refresh
- (void)refreshMethod
{
    BarActivityRequest *r = [BarActivityRequest new];
    r.model = self.model.seller_id;
    r.tag = self.pageNow;

    [r startRequestWithCompleted:^(ResponseState *state) {
        self.parses = [BarActivityModel arrayObjectWithDS:state.datas];
    }];
}

#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MerchantActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:MerchantActivityCellReuseID];
    
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BarActivityModel  *m = self.dataSource[indexPath.row];
    
    WebActivityViewController *wv = [[WebActivityViewController alloc] initWithURL:m.party_details_url];
    if (AX_WEB_VIEW_CONTROLLER_iOS9_0_AVAILABLE()) {
        wv.webView.allowsLinkPreview = YES;
    }
    wv.showsToolBar = NO;
    [self.navigationController pushViewController:wv animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
