//
//  PackageListViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/6/29.
//  Copyright © 2017年 WanBo. All rights reserved.
//  套餐列表

#import "PackageListViewController.h"
#import "PackageListCell.h"
#import "PackageDetailsView.h"
#import "ScottAlertController.h"
#import "MineRequest.h"
#import "ClubCircleRequest.h"
#import "ClubCircleModelList.h"

@interface PackageListViewController ()

/** 套餐详情 */
@property (nonatomic, strong) NSArray *packageDetails;

@end

@implementation PackageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHead = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 请求套餐列表

- (void)refreshMethod{
    
    BarPackageRequest *r = [BarPackageRequest new];
    r.barID = self.model;
    [r startRequestWithCompleted:^(ResponseState *state) {

        self.parses  = [BarPackageModel arrayObjectWithDS:state.data];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 108;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return TABLE_HEAD_FOOT_SPACE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @weakify(self);
    
    PackageListCell *cell = [tableView dequeueReusableCellWithIdentifier:PackageListCellReuseID];
    
    cell.seeDetailsBlock = ^(NSIndexPath *indexPath) {
        @strongify(self);
        //先获取套餐详情，然后再显示
        BarPackageModel *m = self.dataSource[indexPath.row];
    
        //获取套餐详情
        ShowLoading
        BarPackageDetailsRequest  *r = [BarPackageDetailsRequest new];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (m.ID.length >0) {
            [params setValue:m.ID forKey:@"combo.id"];
        }
        r.param = params;
        //r.param = @{@"combo.id":m.ID};
        [r startRequestWithCompleted:^(ResponseState *state) {
            @strongify(self);
            NSArray *array = [PackageDetailsListModel arrayObjectWithDS:state.data[@"items"]];
            self.packageDetails = array;
            CloseLoading
            PackageDetailsView *v = [PackageDetailsView initFromXIB];
            CGFloat height = 0;
            if (array.count <= 5){
                height = 43 * array.count;
            }
            else{
                height = 43 * 5;
            }
            height += 135 + 30;
            
            CGFloat width = (324/375.0) * SCREEN_WIDTH;
            v.frame = CGRectMake(0, 0, width, height);
            v.model = array;
            v.packagemodel = m;
            ScottAlertViewController *ac = [ScottAlertViewController alertControllerWithAlertView:v];
            ac.tapBackgroundDismissEnable = YES;
            
            [self presentViewController:ac animated:YES completion:nil];
            
            [v reloadDataToView];
        }];
    };
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.calkBlock)
        self.calkBlock(self.dataSource[indexPath.row]);
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
