//
//  AccountLogViewController.m
//  NightclubLive
//
//  Created by rdp on 2017/5/25.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AccountLogViewController.h"
#import "HMSegmentedControl.h"
#import "AccountLogCell.h"
#import "MineModelList.h"
#import "MineRequest.h"

@interface AccountLogViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentControl;

@end

@implementation AccountLogViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshView = self.tableView;
    self.isHead = YES;
    self.isFoot = YES;
    
    // 配置顶部数据
    [self setupSegment];
}

- (void)setupSegment
{
    @weakify(self);
    _segmentControl.sectionTitles = @[@"收入",@"支出"];
    _segmentControl.backgroundColor = [UIColor whiteColor];
    _segmentControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _segmentControl.selectedSegmentIndex = 0;//HMSegmentedControlNoSegment;
    _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentControl.selectionIndicatorHeight = 2;
    _segmentControl.selectionIndicatorColor = APPDefaultColor;
    _segmentControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _segmentControl.indexChangeBlock = ^(NSInteger changeIndex){
        @strongify(self);
        self.pageNow = 0;
        [self.dataSource removeAllObjects];
        [self.tableView reloadInMain];
        [self requestBegin];
    };
}

#pragma mark - Request Method
- (void)refreshMethod
{
    NSInteger selectIndex = self.segmentControl.selectedSegmentIndex;
    ObjectRequest *r = selectIndex == 1 ? [ExpenditureListRequest new] : [IncomeListRequest new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (CurrentUser.userID.length >0) {
        [params setValue:CurrentUser.userID forKey:@"userId"];
    }
    if (self.pageNow) {
        [params setValue:@(self.pageNow) forKey:@"pageNow"];
    }
    r.param = params;
    //r.param = @{@"userId":CurrentUser.userID,@"pageNow":@(self.pageNow)};
    [r startRequestWithCompleted:^(ResponseState *state) {
        
        self.parses = [AccountLogModel arrayObjectWithDS:state.data];
    }];
}

#pragma mark - Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountLogCell *cell = [tableView dequeueReusableCellWithIdentifier:AccountLogCellReuseID];
    
    cell.tag = _segmentControl.selectedSegmentIndex;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
