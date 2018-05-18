//
//  NetRedCircelRankViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NetRedCircelRankViewController.h"
#import "HMSegmentedControl.h"
#import "NetRedCircleRankCell.h"
#import "NetRedCircleRequest.h"
#import "NetRedCircleListModel.h"
#import "UserInfoViewController.h"
#import "EmptyMiniView.h"


@interface NetRedCircelRankViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContstantH;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSGC;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *timetypeSG;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *oneIV;
@property (weak, nonatomic) IBOutlet UILabel *oneNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *oneValueBtn;
@property (weak, nonatomic) IBOutlet UIImageView *twoIV;
@property (weak, nonatomic) IBOutlet UILabel *twoNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *twoValueButton;
@property (weak, nonatomic) IBOutlet UIImageView *threeIV;
@property (weak, nonatomic) IBOutlet UILabel *threeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *threeValueLabel;

/** 选择项 */
@property (nonatomic, assign) NSInteger typeSelect;
/** 空列表 */
@property(nonatomic,strong)UIView *emptyView;

@end

@implementation NetRedCircelRankViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.refreshView = self.tableView;

    [self setupTypeSGC];
    [self setupTimeTypeSG];

    // 设置圆角
    _oneIV.isRound = YES;
    _oneIV.superview.isRound = YES;
    _twoIV.isRound = YES;
    _twoIV.superview.isRound = YES;
    _threeIV.isRound = YES;
    _threeIV.superview.isRound = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews ];
    
#warning iPhoneX
    if (iPhoneX)
    {
        [self.topContstantH setConstant:-44];
    }
}

- (void)setupTypeSGC
{
    [_typeSGC setImage:[KGetImage(@"icon_switchmeilioff") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:0];
    [_typeSGC setImage:[KGetImage(@"icon_switchtuhaooff") imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forSegmentAtIndex:1];
    _typeSGC.backgroundColor = [UIColor clearColor];
    _typeSGC.selectedSegmentIndex = self.tag;
    [self rankTypeSitch:_typeSGC];
}

- (void)setupTimeTypeSG
{
    @weakify(self);
    _timetypeSG.sectionTitles = @[@"日榜",@"周榜",@"总排行榜"];
    _timetypeSG.backgroundColor = [UIColor whiteColor];
    _timetypeSG.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _timetypeSG.selectedSegmentIndex = 0;//HMSegmentedControlNoSegment;
    _timetypeSG.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _timetypeSG.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _timetypeSG.selectionIndicatorHeight = 2;
    _timetypeSG.selectionIndicatorColor = APPDefaultColor;
    _timetypeSG.selectedTitleTextAttributes =@{NSForegroundColorAttributeName:APPDefaultColor};
    _timetypeSG.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    _timetypeSG.verticalDividerEnabled = YES;
    _timetypeSG.verticalDividerColor = [UIColor lightGrayColor];
    _timetypeSG.verticalDividerHeight = 31;
    _timetypeSG.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    _timetypeSG.indexChangeBlock = ^(NSInteger changeIndex){
        @strongify(self);
        /*weakself.pageNow = 0;
         [weakself.dataSource removeAllObjects];
         [weakself.tableView reloadInMain];
         [weakself requestBegin];*/
        
        [self requetRankList];
        
        DLog(@"index = %ld",changeIndex);
    };
}

#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource.count == 0 )
    {
        if (!_emptyView)
        {
            UIView *v = [EmptyMiniView viewWithTip:@"暂时无人上榜"];
            v.frame = [NCEmpty getEmtpyViewRectWithScrollView:self.tableView];
            CGPoint offset = CGPointMake(-80, -50);
            v.y += offset.y;
            v.x += offset.x;
            
            [self.view addSubview:v];
            _emptyView = v;
        }
        
    }else{
        if (_emptyView){
            [_emptyView removeFromSuperview];
        }
        
    }

    
    if (self.dataSource.count > 3)
    {
        return self.dataSource.count - 3;
    }
    
    return 0;
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
    NetRedCircleRankCell *cell = [tableView dequeueReusableCellWithIdentifier:NetRedCircleRankCellReuseID];
    cell.showRankListType = _typeSelect;
    cell.indexPath = indexPath;
    cell.model = self.dataSource[indexPath.row + 3];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 增加3为了移位置到3
    RankListModel *m = self.dataSource[indexPath.row + 3];
    User *user = [[User alloc] init];
    user.userId = m.user_id;
    
    UserInfoViewController *vc = [UserInfoViewController initSBWithSBName:@"UserInfoSB"];
    vc.userModel = user;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requetRankList
{
    NSInteger type = _timetypeSG.selectedSegmentIndex == 0 ? 1: (_timetypeSG.selectedSegmentIndex == 1 ? 2 : 0);
    NSInteger rankListType = _typeSGC.selectedSegmentIndex;
    NSNumber *timeType = @(type);
    RankListObjectRequest *r = rankListType  ? [TheRichRankListRequest new] : [CharmRankListRequest new];
    r.model = timeType;
    [self.dataSource removeAllObjects];
    [self.tableView reloadInMain];

    @weakify(self);
    [r startRequestWithCompleted:^(ResponseState *state)
    {
        @strongify(self);
        self.parses = [RankListModel arrayObjectWithDS:state.data];
        [self loadOneToThree];

    }];
}

- (void)loadOneToThree
{
    [_oneIV  sd_setImageWithURL:nil placeholderImage:[UIImage userPlaceholder]];
    _oneNameLabel.text = @"";
    [_oneValueBtn setTitle:@" 0" forState:UIControlStateNormal];

    [_twoIV  sd_setImageWithURL:nil placeholderImage:[UIImage userPlaceholder]];
    _twoNameLabel.text = @"";
    [_twoValueButton setTitle:@" 0" forState:UIControlStateNormal];

    [_threeIV  sd_setImageWithURL:nil placeholderImage:[UIImage userPlaceholder]];
    _threeNameLabel.text = @"";
    [_threeValueLabel setTitle:@" 0" forState:UIControlStateNormal];
    
    if (self.dataSource.count > 0)
    {
        RankListModel *one = self.dataSource[0];
        [_oneIV  sd_setImageWithURL:one.profile_photo placeholderImage:[UIImage userPlaceholder]];
        _oneNameLabel.text = one.user_name;
        [_oneValueBtn setTitle:[NSString stringWithFormat:@" %@",_typeSelect == 0 ? one.charm_value : one.daifug_value] forState:UIControlStateNormal];
    }
    
    if (self.dataSource.count > 1)
    {
        RankListModel *two = self.dataSource[1];
        [_twoIV  sd_setImageWithURL:two.profile_photo placeholderImage:[UIImage userPlaceholder]];
        _twoNameLabel.text = two.user_name;
        [_twoValueButton setTitle:[NSString stringWithFormat:@" %@",_typeSelect == 0 ? two.charm_value : two.daifug_value] forState:UIControlStateNormal];
    }
    
    if (self.dataSource.count > 2)
    {
        RankListModel *three = self.dataSource[2];
        [_threeIV  sd_setImageWithURL:three.profile_photo placeholderImage:[UIImage userPlaceholder]];
        _threeNameLabel.text = three.user_name;
        [_threeValueLabel setTitle: [NSString stringWithFormat:@" %@",_typeSelect == 0 ? three.charm_value : three.daifug_value] forState:UIControlStateNormal];
    }
}

#pragma mark - Action
- (IBAction)rankTypeSitch:(UISegmentedControl *)sender
{
    NSInteger selectIndex = sender.selectedSegmentIndex;
    
    _typeSelect = selectIndex;
    UIImage *img1 = nil;
    UIImage *img2 = nil;
    if (selectIndex == 0){
        img1 = KGetImage(@"icon_switchmeilion");
        img2 = KGetImage(@"icon_switchtuhaooff");
    }
    else{
        img1 = KGetImage(@"icon_switchmeilioff");
        img2 = KGetImage(@"icon_switchtuhaoon");
    }
    
    img1 = [img1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    img2 = [img2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [_typeSGC setImage:img1 forSegmentAtIndex:0];
    [_typeSGC setImage:img2 forSegmentAtIndex:1];
    
    [self.view layoutIfNeeded];
    
    // 更新图片
    NSArray *strArray = @[@"icon_meilizhitu",@"icon_yiebiterank"];
    NSString *str = [strArray stringAtIndex:_typeSelect];
    UIImage *typeImage = KGetImage(str);

    //更换图片
    [_oneValueBtn setImage:typeImage forState:UIControlStateNormal];
    [_twoValueButton setImage:typeImage forState:UIControlStateNormal];
    [_threeValueLabel setImage:typeImage forState:UIControlStateNormal];
    
    //更换颜色
    NSArray *strArray2 = @[@"af09d4",@"ffb600"];
    NSString *textStr = [strArray2 stringAtIndex:_typeSelect];
    UIColor *titleColor = [UIColor colorWithHexString:textStr];
    [_oneValueBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [_twoValueButton setTitleColor:titleColor forState:UIControlStateNormal];
    [_threeValueLabel setTitleColor:titleColor forState:UIControlStateNormal];

    [self requetRankList];
}

- (IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 头像点击
- (IBAction)oneToThreeClick:(UIGestureRecognizer *)sender
{
    if (self.dataSource.count <= sender.view.tag)
    {
        return;
    }
    
    RankListModel *m = self.dataSource[sender.view.tag];
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
