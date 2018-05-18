//
//  FindBarViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//  寻找酒吧

#import "FindBarViewController.h"
#import "NetRedCircleBarCell.h"
#import "NetRedCircleRequest.h"
#import "MerchantDetailsViewController.h"
#import "NetRedCircleListModel.h"
#import "UIAlertController+Factory.h"

@interface FindBarViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@end

@implementation FindBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.refreshView = self.tableView;
    self.isFoot = YES;
    self.isHead = YES;
}

#pragma mark - Request

- (void)refreshMethod
{
    BarListRequest *r = [BarListRequest new];
    r.pageNow = self.pageNow;
    r.searchKey = _searchTF.text;
    
    [r startRequestWithCompleted:^(ResponseState *state) {
        self.parses = [NetRedCircleBarModel arrayObjectWithDS:state.datas];
        
        if (self.dataSource.count == 0)
        {
            // 提示空
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" withMessage:@"请检查输入夜店名字是否正确" calk:nil];
            [self presentViewController:ac animated:YES completion:nil];
        }
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NetRedCircleBarCell *cell = [tableView dequeueReusableCellWithIdentifier:NetRedCircleBarCellReuseID];
    if (!cell)
    {
        cell = [[NetRedCircleBarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NetRedCircleBarCellReuseID];
    }
    NetRedCircleBarModel *model = self.dataSource[indexPath.row];
    [cell.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(model.nameWidth);
    }];
    
    cell.model = model;
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MerchantDetailsViewController * vc = ViewController(@"MerchantDetailsSB", @"MerchantDetailsViewController");
    
    vc.model = self.dataSource[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)searchBarClick:(id)sender
{
    [self.view endEditing:YES];
    
    if (_searchTF.text.length <= 0 )
    {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" withMessage:@"请输入搜索关键词" calk:nil];
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    
    self.pageNow = 1;
    
    [self.dataSource removeAllObjects];
    [self.tableView reloadInMain];
    
    [self refreshMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
