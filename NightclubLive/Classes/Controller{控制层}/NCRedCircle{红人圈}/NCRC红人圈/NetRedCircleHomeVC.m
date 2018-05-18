//
//  NetRedCircleHomeVC.m
//  NightclubLive
//
//  Created by WanBo on 16/11/29.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "NetRedCircleHomeVC.h"
#import "SDCycleScrollView.h"
#import "YZTagGroupItem.h"
#import "JhtFloatingBall.h"
#import "TangTangVC.h"
#import "NetRedCircleHomeViewModel.h"
#import "NetRedBannerModel.h"
#import "AllActivitiesViewModel.h"
#import "ScrollContentView.h"
#import "CampaignRequest.h"
#import "CampaignModel.h"
#import "GlobalRequest.h"
#import "GlobalModel.h"
#import "NetRedCircleRequest.h"
#import "LeadView.h"
#import "XHPopMenu.h"
#import "FindFriendViewController.h"
#import "HomeBarCell.h"
#import "MerchantDetailsViewController.h"
#import "NetRedCircleRequest.h"
#import "NetRedCircleListModel.h"
#import "WebActivityViewController.h"
#import "PersonCVC.h"
#import "BaseTabBarController.h"
#import "ChatRequest.h"
#import "UILabel+NavTitleView.h"
#import "UIAlertController+Factory.h"

#import "FSScrollContentView.h"
#import "HMSegmentedControl.h"

@interface NetRedCircleHomeVC ()
<
SDCycleScrollViewDelegate,
UICollectionViewDelegate,
UIGestureRecognizerDelegate,
FSSegmentTitleViewDelegate,
FSPageContentViewDelegate
>

#define sectionContenOffY (self.bannerView.frame.size.height + self.barItemSize.height + 60 + 10)

@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *campaignSuperView;
@property (weak, nonatomic) IBOutlet UIView *findPersonSuperView;
@property (weak, nonatomic) IBOutlet UIView *companySuperView;
@property (weak, nonatomic) IBOutlet UIView *barSuperView;

/** 竞选活动 */
@property (nonatomic, strong) NSArray *campaigns;
/** 职业 */
@property (nonatomic, strong) NSArray *jobs;
/** 酒吧推荐列表 */
@property (nonatomic, strong) NSArray *bars;
/** 菜单弹出 */
@property (nonatomic, strong) XHPopMenu *searchMenu;
/** bar item size */
@property (nonatomic, assign) CGSize barItemSize;
/** 测试滑动标题 */
@property (nonatomic, strong) NSArray *titles;
/** 人集合 */
@property (nonatomic, strong) NSArray *persons;
/** 找人集合vc */
@property (nonatomic, strong) PersonCVC *personVC;
/** 职业选择index */
@property (nonatomic, assign) NSInteger jobIndex;
/** 滑动头部 */
@property (nonatomic, strong) FSSegmentTitleView *jobtitleView;
/** 滑动内容 */
@property (nonatomic, strong) FSPageContentView *jobContentView;
// 滚动部分
@property (nonatomic, strong) ScrollContentView *barView;

@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSMutableArray *activitesArr;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong) JhtFloatingBall *btn;
@property (strong, nonatomic)  UICollectionView *sociaCollectionView;
@property (nonatomic, strong) NetRedCircleHomeViewModel *viewModel;

@property (nonatomic,assign)CGFloat oldcurrentContenOffY;
@property (nonatomic,assign)BOOL oepnScroll;

@property (strong, nonatomic) HMSegmentedControl *segmentControl;

@end

@implementation NetRedCircleHomeVC

@dynamic viewModel;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    adjustsScrollViewInsets_NO(self.tableView,self);

    // 检查要不要重新登录
    CurrentUser.user;
    self.navigationItem.titleView = [UILabel navWithTitle:@"红人圈"];
    
    [self setupBarView];
    [self setupFSPageContentView];
    
    [self setupBannerAdvertisement];
    [self setupTableView];
    
    if (![SystemTool isOneOpen])
    {
        // 在显示新特性时不显示
        [self addButton];
    }

    
    [self refreshMethod];
}

- (void)viewWillAppear:(BOOL)animated
{
    // 这里不能调用父类方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFinish) name:NOTIFICATION_LOGINFINISH  object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
     
    [_btn setHidden:NO];
    
    _oepnScroll = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [_btn setHidden:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.oldcurrentContenOffY >= sectionContenOffY)
    {
        _oepnScroll = NO;
    }else{
        _oepnScroll = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    DLog(@"%f---%f",scrollView.contentOffset.y,self.bannerView.frame.size.height+250);
    
    if (_oepnScroll)
    {
        if (scrollView.contentOffset.y >= sectionContenOffY)
        {
            self.oldcurrentContenOffY = sectionContenOffY;
        }else{
            self.oldcurrentContenOffY = scrollView.contentOffset.y ;
        }
        
        self.tableView.contentOffset = CGPointMake(0,scrollView.contentOffset.y );
    }else{
        self.tableView.contentOffset = CGPointMake(0, sectionContenOffY);
    }
    
}

- (void)loginFinish
{
    [self refreshMethod];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTableView
{
    adjustsScrollViewInsets_NO(self.tableView,self);
    
    self.isHead = YES;
    self.refreshView = self.tableView;
    
    @weakify(self);
    MJRefreshNormalHeader *refreshHeadView = [MJRefreshNormalHeader headerWithRefreshingBlock:^
                                              {
                                                  @strongify(self);
                                                  [self refreshMethod];
                                              }];
    refreshHeadView.stateLabel.hidden = YES;
    self.tableView.mj_header = refreshHeadView;
    
    [self selectIndexForIndex:_jobIndex];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    
    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 50;
    }
    
    return TABLE_HEAD_FOOT_SPACE;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1 && self.jobs)
    {
        
//        UIView *headView =  self.jobtitleView;
        UIView *headView =  self.segmentControl;
        
        [self selectIndexForIndex:_jobIndex];
        
        return headView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0)
    {
        return  0;
    }
    else if (section == 1)
    {
        return (self.view.height - 30);
    }
    
    return 0;
}

#pragma mark - Refresh Method
- (void)refreshMethod
{
    if (CurrentUser.status == CurrentUserStatusSignOut)
    {
        [UserInfo needLogin];
        [self.tableView endRefresh];
        return;
    }
    
    [self setupBannerList];
    [self setupJobList];
    [self setupBarList];
    
    [self.tableView.mj_header endRefreshing];
}

- (void)setupBarView
{
    CGFloat width = SCREEN_WIDTH / 3.0;
    CGFloat height = (5.3/3.0) * width;
    _barItemSize = CGSizeMake(width, height);
    
    @weakify(self);
    [_barSuperView addSubview:self.barView];
    NSString *HomeBarCellReuseID = @"HomeBarCell";
    [_barView registerCell:[HomeBarCell class] resuseID:HomeBarCellReuseID];
    _barView.itemBlock = ^UICollectionViewCell *(NSIndexPath *indexPath, UICollectionView *collectionView)
    {
        @strongify(self);
        HomeBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HomeBarCellReuseID forIndexPath:indexPath];
        cell.model = self.bars[indexPath.row];
        
        return cell;
    };
    
    
    _barView.selectBlock = ^(NSIndexPath *indexPath)
    {
        @strongify(self);
        MerchantDetailsViewController * vc = ViewController(@"MerchantDetailsSB", @"MerchantDetailsViewController");
        vc.model = self.bars[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    };
}

#pragma mark - 点击广告
- (void)setupBannerAdvertisement
{
//    _bannerView.height = (165. / 375.0) * SCREEN_WIDTH ;
    self.bannerView.height = SCREEN_WIDTH * (175 / 375.0);
    [self.tableView setTableHeaderView:self.bannerView];
    
    @weakify(self);
    _bannerView.clickItemOperationBlock = ^(NSInteger currentIndex)
    {
        @strongify(self);
        NetRedBannerModel *m = _banners[currentIndex];
        NSURL *url = m.show_url ? m.show_url : m.jump_url;
        
        WebActivityViewController *wv = [[WebActivityViewController alloc] initWithURL:url];
        if (AX_WEB_VIEW_CONTROLLER_iOS9_0_AVAILABLE()) {
            wv.webView.allowsLinkPreview = YES;
        }
        wv.showsToolBar = NO;
        [self.navigationController pushViewController:wv animated:YES];
    };
}

//悬浮按钮
- (void)addButton
{
    _btn = [[JhtFloatingBall alloc] init];
    UIImage *suspendedBallImage = [UIImage imageNamed:@"红人圈-首页-偶遇图标"];
    CGFloat width = SCREEN_WIDTH * 0.20;
    CGFloat height = width * 0.504;
    CGRect rect = CGRectZero;
    if (iPhoneX) {
        rect = CGRectMake(SCREEN_WIDTH - width - 10, SCREEN_HEIGHT - height -  85 -34, width, height);
    }else{
        rect = CGRectMake(SCREEN_WIDTH - width - 10, SCREEN_HEIGHT - height -  85, width, height);
    }
    _btn.frame = rect;
    _btn.layer.cornerRadius = 8;
    _btn.image = suspendedBallImage;
    [self.view addSubview:_btn];
    
    [[[UIApplication sharedApplication].windows lastObject] addSubview:_btn];
    // 添加点击手势
    UITapGestureRecognizer *fbGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fbTap:)];
    fbGesture.delegate = self;
    [_btn addGestureRecognizer:fbGesture];
}

/** fb点击 事件 */
- (void)fbTap:(UITapGestureRecognizer *)ges
{
    if ([UserInfo shareUser].location)
    {
        TangTangVC *vc = [TangTangVC controllerWithViewModel:nil andSbName:@"TangTangSB"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        
        if ([UserInfo shareUser].userID)
        {
           
        }
        else if ([UserInfo shareUser].location)
        {
            [self presentViewController:[UIAlertController alertControllerWithTitle:@"提示" withMessage:@"app没有获取定位权限,无法使用偶遇功能" calk:nil] animated:YES completion:nil];
        }
    }
}

- (void)setupBarList
{
    BarListRequest *r = [BarListRequest new];
    r.ishot = YES;
    r.pageNow = 1;
    [r startRequestWithCompleted:^(ResponseState *state) {
        
        NSArray *array =  [NetRedCircleBarModel arrayObjectWithDS:state.datas];
        _bars = array;
        _barView.ItemCount = array.count;
        [_barView reloadData];
    }];
}

- (void)setupJobList
{
    @weakify(self);
    JobRequest *jobr = [JobRequest new];
    NSMutableArray *persons = [[NSMutableArray alloc] init];
    [persons addObject:@"推荐"];
    [persons addObject:@"女神"];
    [persons addObject:@"男神"];
    [jobr startRequestWithCompleted:^(ResponseState *state) {
        @strongify(self);
        NSArray *jobs = [JobModel arrayObjectWithDS:state.data];
        for (JobModel *j in jobs){
            [persons addObject:j.name];
        }
        _jobs = [persons copy];
        [self.tableView reloadInMain];
    }];
}

- (void)setupBannerList
{
    @weakify(self);
    NetRedBannnerCircleRequest *bannerR = [[NetRedBannnerCircleRequest alloc] init];
    [bannerR startRequestWithCompleted:^(ResponseState *state)
     {
         @strongify(self);
         NSArray *banners = [NetRedBannerModel arrayObjectWithDS:state.datas];
         NSMutableArray *bannerImage = [NSMutableArray array];
         NSMutableArray *titles = [NSMutableArray array];
         [banners enumerateObjectsUsingBlock:^(NetRedBannerModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
             [bannerImage addObject:obj.bannerImage];
             [titles addObject:obj.bannerTitle];
         }];
         
         // 设置
         self.bannerView.localizationImageNamesGroup = [bannerImage copy];
         self.banners = banners;
     }];
}

- (ScrollContentView *)barView
{
    if (!_barView){
        ScrollContentView *barView = [ScrollContentView initXib];
        _barView = barView;
        _barView.frame = _barSuperView.bounds;
        _barView.itemSize = _barItemSize;
    }
    return _barView;
}

#pragma mark - 搜索视图
- (XHPopMenu *)searchMenu
{
    if (!_searchMenu){
    
        @weakify(self);
        NSArray *items = @[[[XHPopMenuItem alloc] initWithImage:nil title:@"寻找好友"], [[XHPopMenuItem alloc] initWithImage:nil title:@"寻找夜店"]];
        _searchMenu = [[XHPopMenu alloc] initWithMenus:items];
        
        _searchMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *menuItem) {
            @strongify(self);
            if (index == 0){
                [self.navigationController pushViewController:ViewController(@"FindFriendSB", @"FindFriendViewController") animated:YES];
            }
            else{
                
                [self.navigationController pushViewController:ViewController(@"AllBarListSB", @"FindBarViewController") animated:YES];
            }
            
        };
        
        return _searchMenu;
    }
    return _searchMenu;
}

#pragma mark - 查看全部
- (IBAction)allCampainClick:(id)sender
{
    PushViewController(ViewController(@"AllBarListSB", @"AllBarListViewController"));
}

#pragma mark - 搜索
- (IBAction)searchClick:(id)sender
{
    [self.navigationController pushViewController:ViewController(@"FindFriendSB", @"FindFriendViewController") animated:YES];
}

#pragma mark - 财富榜
- (IBAction)rankClick:(id)sender
{
    PushViewController(ViewController(@"NRCRankSB", @"NetRedCircelRankViewController"));
}

- (void)setupFSPageContentView
{
    NSMutableArray *contentVCS = [[NSMutableArray alloc] init];
    // 红人圈瀑布流
    PersonCVC *personVC = [PersonCVC initSBWithSBName:@"PersonCSB"];
    _personVC = personVC;
    [contentVCS addObject:personVC];
    
    _jobContentView = [[FSPageContentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) childVCs:[contentVCS copy] parentVC:self delegate:self];
    [self.findPersonSuperView addSubview:_jobContentView];
}

- (HMSegmentedControl *)segmentControl{
    if (!_segmentControl) {
        @weakify(self);
        _segmentControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _segmentControl.sectionTitles = self.jobs;
        _segmentControl.backgroundColor = [UIColor whiteColor];
        _segmentControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        _segmentControl.selectedSegmentIndex = 0;//HMSegmentedControlNoSegment;
        _segmentControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _segmentControl.selectionIndicatorHeight = 3;
        _segmentControl.selectionIndicatorColor = RGBCOLOR(140, 71, 238);
        _segmentControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:RGBACOLOR(51, 51, 51, 204)};
        _segmentControl.selectedTitleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:RGBCOLOR(140, 71, 238)};
        _segmentControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        _segmentControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
        _segmentControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _segmentControl.indexChangeBlock = ^(NSInteger changeIndex){
            @strongify(self);
            [self selectIndexForIndex:changeIndex];
        };
    }
    
    return _segmentControl;
}

- (void)selectIndexForIndex:(NSInteger)index
{
    NSString *searchKey = self.jobs[index];
    
    [_personVC searchForKey:searchKey];
    _jobIndex = index;
}

- (NSArray *)groups
{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (NSMutableArray *)activitesArr{
    
    if (_activitesArr == nil) {
        _activitesArr = [NSMutableArray array];
    }
    return _activitesArr;
}

- (NSMutableArray *)listArr{
    
    if (_listArr == nil) {
        _listArr = [NSMutableArray array];
    }
    return _listArr;
}

@end
