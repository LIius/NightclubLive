//
//  ContributionViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ContributionViewController.h"
#import "HMSegmentedControl.h"
#import "ContributionCell.h"
#import "MineRequest.h"
#import "NetRedCircleListModel.h"
#import "UserInfoViewController.h"

@interface ContributionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet HMSegmentedControl *typeSG;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ContributionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.refreshView = self.tableView;
    @weakify(self);
    _typeSG.sectionTitles = @[@"日榜",@"总排行榜"];
    _typeSG.backgroundColor = [UIColor whiteColor];
    _typeSG.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _typeSG.selectedSegmentIndex = 0;//HMSegmentedControlNoSegment;
    _typeSG.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _typeSG.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _typeSG.selectionIndicatorHeight = 2;
    _typeSG.selectionIndicatorColor = APPDefaultColor;
    _typeSG.selectedTitleTextAttributes =@{NSForegroundColorAttributeName:APPDefaultColor};
    _typeSG.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    _typeSG.verticalDividerEnabled = YES;
    _typeSG.verticalDividerColor = [UIColor lightGrayColor];
    _typeSG.verticalDividerWidth = 0.5;
    _typeSG.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;

    _typeSG.verticalDividerHeight = 31;
    _typeSG.indexChangeBlock = ^(NSInteger changeIndex){
        @strongify(self);
        [self contributionList];
    };
    
    [self contributionList];
}

- (void)contributionList
{
    NSNumber *type =  _typeSG.selectedSegmentIndex == 0 ? @(1) : @(0);
    ContributionListRequest *r = [[ContributionListRequest alloc] init];
    r.model = type;
    @weakify(self);
    [r startRequestWithCompleted:^(ResponseState *state) {
        @strongify(self);
        self.parses = [RankListModel arrayObjectWithDS:state.data];
    }];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContributionCell *cell = [tableView dequeueReusableCellWithIdentifier:ContributionCellReuseID];
    
    cell.indexPath = indexPath;
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RankListModel *m = self.dataSource[indexPath.row];
    
    User *user = [[User alloc] init];
    user.userId = m.user_id;
    
    UserInfoViewController *vc = [UserInfoViewController initSBWithSBName:@"UserInfoSB"];
    vc.userModel = user;
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
