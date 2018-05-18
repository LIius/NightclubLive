//
//  MerchantDetailsViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//  夜店详情

#import "MerchantDetailsViewController.h"
#import "HMSegmentedControl.h"
#import "NetRedCircleBarFanCell.h"
#import "MerchantDetailsFuncView.h"
#import "NetRedCircleListModel.h"
#import "NetRedCircleRequest.h"

#import "UserInfoViewController.h"
#import "User.h"
#import "MerchantAllActivityViewController.h"
#import "SDCycleScrollView.h"

#import "MineRequest.h"
#import "BarRequestViewController.h"
#import "AppointmentViewController.h"
#import "SystemTool.h"
#import "WebActivityViewController.h"
#import "EmptyMiniView.h"
#import "UIAlertController+Factory.h"
#import "BlocksKit+UIKit.h"
#import "NCAlert.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface MerchantDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *typeSG;
@property (weak, nonatomic) IBOutlet UILabel *barDescLabel;
@property (weak, nonatomic) IBOutlet UIImageView *barlogoIV;
@property (weak, nonatomic) IBOutlet UILabel *barNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *barTypeIV;
@property (weak, nonatomic) IBOutlet UIImageView *acitivityIV;
@property (weak, nonatomic) IBOutlet UIView *acitivityHeadView;
@property (weak, nonatomic) IBOutlet UIView *acititivityContentView;

/** 模型对象 */
@property (nonatomic, strong) NetRedCircleBarModel *barmodel;
/** 模型对象 */
@property (nonatomic, strong) NetRedCircleBarDetailModel *detailsModel;
/** 传进来的对象 */
@property (nonatomic, strong) NetRedCircleBarModel *model;
/** 数据模型(二维数组)*/
@property (nonatomic, strong) NSMutableArray *datas;
/** 分页pageNOW (二维数组)*/
@property (nonatomic, strong) NSMutableArray *pageNows;
/** 空view */
@property (nonatomic, strong) UIView *emptyView;

@property (nonatomic, weak) MerchantDetailsFuncView *funcV;

@end

@implementation MerchantDetailsViewController

@dynamic model;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = YES;

    [self setupTableView];
    
    [self setupTypeSG];
    
    [self setupFuncView];
    
    // 设置头部高度
     [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _funcV.hidden = NO;
    
    [self setupViewDidload];
    
    [self setupBarDetailRequest];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];

    _funcV.hidden = YES;
}

- (void)dealloc
{
    [_funcV removeFromSuperview];
}

- (void)setupTableView
{
    _pageNows = [NSMutableArray arrayWithObjects:@0,@0,nil];
    _datas = [NSMutableArray arrayWithObjects:[NSMutableArray array],[NSMutableArray array], nil];
    self.isFoot = YES;
    [self refreshMethod];
    CGFloat tableHeight = 559 + SCREEN_WIDTH * ( 178.0 / 375.0);
    self.tableView.tableHeaderView.height = tableHeight;
    [self.tableView setTableHeaderView:self.tableView.tableHeaderView];
}

#pragma mark - Refresh
- (void)refreshMethod
{
    NSInteger type = _typeSG.selectedSegmentIndex;
    
    BarPersonRankListRequest *r = nil;
    if (type == 0){//魅力达人
        r = [BarCharamRankRequest new];
    }
    else{//泡吧达人
        r = [BarExpertRankRequest new];
    }
    
    NSInteger pageNow = [_pageNows[type] integerValue];
    pageNow =  pageNow + 1;
    
    _pageNows[type] = @(pageNow);
    
    r.tag = pageNow;
    r.model = self.model.seller_id;
    [r startRequestWithCompleted:^(ResponseState *state)
     {
         [self.tableView.mj_footer endRefreshing];
         
         //  self.parses = [BarPersonRankModel arrayObjectWithDS:state.datas];
         NSArray *array = [BarPersonRankModel arrayObjectWithDS:state.datas];
         
         NSMutableArray *datas = self.datas[type];
         [datas addObjectsFromArray:array];
         
         [self.tableView reloadInMain];
         
         if(array.count == 0)
         {
             [self.tableView.mj_footer endRefreshingWithNoMoreData];
         }
         
     }];
}

#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.datas[_typeSG.selectedSegmentIndex];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSArray *arr = self.datas[_typeSG.selectedSegmentIndex];
    if (arr.count == 0)
    {
        return 100;
    }
    
    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NetRedCircleBarFanCell *cell = [tableView dequeueReusableCellWithIdentifier:NetRedCircleBarFanCellReuseID];
    
    cell.showType = self.typeSG.selectedSegmentIndex;
    
    cell.indexPath = indexPath;
    
    cell.model = (self.datas[_typeSG.selectedSegmentIndex])[indexPath.row];
    @weakify(self);
    
    cell.appointmentBlock = ^(NSIndexPath *indexPath) {
        @strongify(self);
        BarPersonRankModel *m = (self.datas[self.typeSG.selected])[indexPath.row];
        
        AppointmentViewController *vc = ViewController(@"AppointmentSB", @"AppointmentViewController");
        vc.model = m.user_id;
        vc.bindBarID = self.model.seller_id;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BarPersonRankModel *m = (self.datas[_typeSG.selectedSegmentIndex])[indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    User *u = [[User alloc] init];
    u.userId = m.user_id;
    
    UserInfoViewController *userInfo = ViewController(@"UserInfoSB", @"UserInfoViewController");
    
    userInfo.userModel = u;
    PushViewController(userInfo);
}

#pragma mark - 创建底部的view
- (void)setupFuncView
{
    @weakify(self);
    MerchantDetailsFuncView *funcV = [MerchantDetailsFuncView initFromXIB];
    
    funcV.frame = CGRectMake(0, SCREEN_HEIGHT - 45, SCREEN_WIDTH, 45);
    _funcV = funcV;
    [ShareWindow addSubview:funcV];
    
    // 申请加入夜店
    [_funcV.requestBtn bk_whenTapped:^
    {
        ShowLoading
        // 先获取token
        [CurrentUser getYWBToken:^(NSString *token) {
            
            BindBarRequest *bindR = [BindBarRequest new];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if (token.length >0) {
                [params setValue:token forKey:@"token"];
            }
            if (self.model.seller_id.length > 0) {
                [params setValue:self.model.seller_id forKey:@"merchant.id"];
            }
            [params setValue:@"" forKey:@"applyInfo"];
            bindR.param = params;
            
            // bindR.param = @{@"token":token,@"merchant.id":self.model.seller_id,@"applyInfo":@""};
            
            [bindR startRequestWithCompleted:^(ResponseState *state) {
                @strongify(self);
                CloseLoading
                if (state.isSuccess){
                    ObjectViewController *vc = ViewController(@"BarRequestSB", @"BarRequestViewController");
                    BarModel *m = [[BarModel alloc] init];
                    
                    [m onlySetLogoWithURL:m.image];
                    m.name = self.model.seller_name;
                    m.ID = self.model.seller_id;
                    vc.model = m;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                else{
                    ShowError(state.message);
                }
                
                
            }];
            
        }];
        
    }];
    
    
    // 约台
    [_funcV.appointmentBtn bk_whenTapped:^
    {
        @strongify(self);
        BarModel *m = [[BarModel alloc] init];
        m.ID = self.model.seller_id;
        m.tel = self.model.tel;
        m.businessHours = [NSString stringWithFormat:@"%@~%@",self.detailsModel.business_hours_start,self.detailsModel.business_hours_end];
        m.address = [NSString stringWithFormat:@"%@%@",self.model.city,self.model.address];
        
        [m onlySetLogoWithURL:self.model.logoURL];
        
        AppointmentViewController *vc = [AppointmentViewController initSBWithSBName:@"AppointmentSB"];
        vc.bar = m;
        vc.tag = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)setupTypeSG
{
    @weakify(self);
    _typeSG.sectionTitles = @[@"魅力达人",@"泡吧达人"];
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
    _typeSG.verticalDividerHeight = 31;
    _typeSG.indexChangeBlock = ^(NSInteger changeIndex){
        @strongify(self);
        
        [self.tableView reloadInMain];
        [self refreshMethod];
    };
}

- (void)setupBarDetailRequest
{
    // 获取酒吧详情
    BarDetailsRequest *r = [BarDetailsRequest new];
    r.model = self.model.seller_id;
    [r startRequestWithCompleted:^(ResponseState *state)
    {
        // 轮播图
        NetRedCircleBarDetailModel *m = [[NetRedCircleBarDetailModel arrayObjectWithDS:@[state.result]] firstObject];
        
        if (m.banners.count > 0)
        {
            self.bannerView.imageURLStringsGroup = m.banners;
        }else{
            self.bannerView.localizationImageNamesGroup = @[KGetImage(@"icon_yiedianxiangqing")];
        }
        
        _timeLabel.text = [NSString stringWithFormat:@"营业时间:%@ - %@",m.business_hours_start,m.business_hours_end];
        _barDescLabel.text = m.introduction;
        
        _funcV.requestBtn.enabled = !m.is_bang;
        
        NSArray *strArray = @[@"申请加入夜店",@"已加入夜店"];
        NSString *str = [strArray stringAtIndex:m.is_bang];
        [_funcV.requestBtn setTitle:str forState:UIControlStateNormal];
        [_acitivityIV sd_setImageWithURL:m.parytyImage placeholderImage:[UIImage picturePlaceholder] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
            [_acitivityIV autoAdjustWidth];
        }];
        
        // 判断是否有活动
        if (!m.parytyImage)
        {
            _acitivityHeadView.hidden = YES;
            _acititivityContentView.hidden = YES;
            
            CGFloat tableHeight = 559 + SCREEN_WIDTH * ( 178.0 / 375.0) - _acititivityContentView.height - _acitivityHeadView.height;
            self.tableView.tableHeaderView.height = tableHeight;
            
            [_acititivityContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            
            [_acitivityHeadView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            
        }
        
        _detailsModel = m;
        
        [self.tableView reloadInMain];
        // self.tableView.scrollEnabled = YES;
    }];
}

- (void)setupViewDidload
{
    _barNameLabel.text = self.model.seller_name;
    
    [_barlogoIV sd_setImageWithURL:self.model.logoURL placeholderImage:[UIImage picturePlaceholder] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_barlogoIV autoAdjustWidth];
    }];
    _addressLabel.text = [NSString stringWithFormat:@"%@%@",self.model.city,self.model.address];
    
    NSArray *strArray = @[@"icon_qingba",@"icon_jiubafirst",@"icon_KTV"];
    NSString *str = [strArray stringAtIndex:self.model.barType];
    _barTypeIV.image = KGetImage(str);
}

#pragma mark - 查看全部活动
- (IBAction)allActivitionClick:(id)sender
{
    MerchantAllActivityViewController *vc = ViewController(@"MerchantAllActivitySB", @"MerchantAllActivityViewController");
    vc.model = self.model;
    PushViewController(vc);
}

#pragma mark - 拨打电话
- (IBAction)calkClick:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",self.model.tel]]];
}

#pragma mark - 地址点击
- (IBAction)addressClick:(id)sender
{
    [NCAlert showActionSheetWithDataSource:@[@"苹果地图导航"] blockHandel:^(NSInteger index) {
        if (index == 0)
        {
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake
            (_detailsModel.latitude, _detailsModel.longitude);
            NSDictionary *mapDic = @{@"name": self.model.seller_name};
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:mapDic]];
            toLocation.name = self.model.seller_name;
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                           MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        }
        
        _funcV.hidden = NO;
    }];

    
    _funcV.hidden = YES;
}

#pragma mark - 点击活动
- (IBAction)activityClick:(id)sender
{
    WebActivityViewController *wv = [[WebActivityViewController alloc] initWithURL:_detailsModel.party_details_url];
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
