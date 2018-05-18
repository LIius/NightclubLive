//
//  AllBarListViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AllBarListViewController.h"

#import "NetRedCircleBarCell.h"
#import "NetRedCircleFiltrateView.h"
#import "NetRedCircleRequest.h"
#import "NetRedCircleListModel.h"

#import "MerchantDetailsViewController.h"

#import "EmptyMiniView.h"
#import "EmptyBigView.h"


@interface AllBarListViewController ()

/** 筛选 */
@property (nonatomic, strong) NetRedCircleFiltrateView *filtrateView;
/** 酒吧类型 */
@property (nonatomic, copy) NSString *barTypeName;
/** 酒吧选中类型序号 */
@property (nonatomic, assign) NSInteger selectBarNum;
@property(nonatomic,strong)UIView *emptyView;

@end

@implementation AllBarListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.isHead = YES;
    self.isFoot = YES;
}

#pragma mark - Request
- (void)refreshMethod
{
    BarListRequest *r = [BarListRequest new];
    r.bartype = self.barTypeName;
    
    r.pageNow = self.pageNow;
    [r startRequestWithCompleted:^(ResponseState *state)
     {
        self.parses = [NetRedCircleBarModel arrayObjectWithDS:state.datas];
        //[self.tableView reloadInMain];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _filtrateView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _filtrateView.hidden = YES;
}

- (void)dealloc
{
    [_filtrateView removeFromSuperview];
}

#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (self.dataSource.count == 0 )
    {
        if (!_emptyView)
        {
            UIView *v = [EmptyBigView viewWithTip:@"夜店正在入驻中。。。"];
            v.frame = [NCEmpty getEmtpyViewRectWithScrollView:self.tableView];
            [self.view addSubview:v];
            _emptyView = v;
        }
        
    }else{
        if (_emptyView){
            [_emptyView removeFromSuperview];
        }
        
    }
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NetRedCircleBarCell *cell = [tableView dequeueReusableCellWithIdentifier:NetRedCircleBarCellReuseID];
    NetRedCircleBarModel *model = self.dataSource[indexPath.row];
    [cell.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(model.nameWidth);
    }];
    
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MerchantDetailsViewController * vc = ViewController(@"MerchantDetailsSB", @"MerchantDetailsViewController");
    
    vc.model = self.dataSource[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 刷选
- (IBAction)filtrateClick:(id)sender
{
    self.filtrateView.selectRow = self.selectBarNum;
    [self.filtrateView show];
}

#pragma mark - Get
-(NetRedCircleFiltrateView *)filtrateView
{
    @weakify(self);
    if (!_filtrateView){
        _filtrateView = [NetRedCircleFiltrateView initFromXIB];
        _filtrateView.frame = CGRectMake(SCREEN_WIDTH, 64, 230, SCREEN_HEIGHT - 64);
        _filtrateView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        [ShareWindow addSubview:_filtrateView];
        
        _filtrateView.okBlock = ^(NSNumber * param) {
            @strongify(self);
            NSInteger selectNum = [param integerValue];
            NSArray *strArray = @[@"",@"酒吧",@"清吧",@"KTV"];
            NSString *str = [strArray stringAtIndex:selectNum];
            self.barTypeName = str;
            self.selectBarNum = selectNum;
        };
        
    }
    return _filtrateView;
}

#pragma mark - Set
- (void)setBarTypeName:(NSString *)barTypeName
{
    _barTypeName = barTypeName;
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

