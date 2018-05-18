//
//  NCRedCircleViewController.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/10/30.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NCRedCircleViewController.h"
#import "SDCycleScrollView.h"
#import "WebActivityViewController.h"
#import "PersonCVC.h"

#import "NetRedBannerModel.h"
#import "GlobalModel.h"

#import "GJModelRequest.h"
#import "NetRedCircleRequest.h"
#import "ObjectRequest.h"
#import "CampaignRequest.h"
#import "GlobalRequest.h"
#import "HMSegmentedControl.h"

@interface NCRedCircleViewController()<SDCycleScrollViewDelegate>
@property(nonatomic,strong)SDCycleScrollView *bannerView;
@property (nonatomic, strong) PersonCVC *personVC;
@property (nonatomic, strong) UIView *jobtitleSuperView;
@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong) NSArray *jobs;
@property (nonatomic, assign) NSInteger jobIndex;
@property (nonatomic,assign)CGFloat oldcurrentContenOffY;
@property (nonatomic,assign)BOOL oepnScroll;
@property (strong, nonatomic) HMSegmentedControl *segmentControl;
@end

@implementation NCRedCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.isHead = YES;
    self.banners = @[];
    self.jobs =  @[];
    self.jobIndex = 0;
    
//    self.dataSource = @[@""].mutableCopy;
    
    [self setupTableView];
    [self setupBannerView];
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.oldcurrentContenOffY >= 195.0)
    {
        _oepnScroll = NO;
    }else{
        _oepnScroll = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    _oepnScroll = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_oepnScroll)
    {
        if (scrollView.contentOffset.y >= 195.0)
        {
            self.oldcurrentContenOffY = 195.0;
        }else{
            self.oldcurrentContenOffY = scrollView.contentOffset.y ;
        }
        
        self.tableView.contentOffset = CGPointMake(0,scrollView.contentOffset.y );
    }else{
        self.tableView.contentOffset = CGPointMake(0, 195.0);
    }
    
}

- (void)refreshMethod
{
    if (CurrentUser.status == CurrentUserStatusSignOut)
    {
        [UserInfo needLogin];
        [self.tableView endRefresh];
        return;
    }
    
    [self.tableView.mj_header endRefreshing];
}

- (void)setupTableView
{
    adjustsScrollViewInsets_NO(self.tableView,self);
    
//    self.isHead = YES;
//    self.refreshView = self.tableView;
    
    @weakify(self);
    MJRefreshNormalHeader *refreshHeadView = [MJRefreshNormalHeader headerWithRefreshingBlock:^
                                              {
                                                  @strongify(self);
                                                  [self refreshMethod];
                                              }];
    refreshHeadView.stateLabel.hidden = YES;
    self.tableView.mj_header = refreshHeadView;
    
    [self requestJobList];
}

- (void)selectIndexForIndex:(NSInteger)index
{
    NSString *searchKey = self.jobs[index];
    
    [self.personVC searchForKey:searchKey];
    self.jobIndex = index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.jobs.count >0)
    {
        UIView *headView =  self.jobtitleSuperView;
        
        [self selectIndexForIndex:self.jobIndex];
        
        return headView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.view.height - 30);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
//    if ([cell.contentView.subviews containsObject:self.jobContentView])
//    {
//        return cell;
//    }else{
//        
//        NSMutableArray *contentVCS = [[NSMutableArray alloc] init];
//        // 红人圈瀑布流
//        PersonCVC *personVC = [PersonCVC initSBWithSBName:@"PersonCSB"];
//        self.personVC = personVC;
//        [contentVCS addObject:personVC];
//        
////        self.jobContentView = [[FSPageContentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) childVCs:[contentVCS copy] parentVC:self delegate:self];
////        [cell.contentView addSubview:self.jobContentView];
//        
//    }
//    
    return cell;
}

- (void)requestJobList
{
    @weakify(self);
    JobRequest *jobr = [JobRequest new];
    NSMutableArray *persons = [[NSMutableArray alloc] init];
    [persons addObject:@"推荐"];
    [persons addObject:@"女神"];
    [persons addObject:@"男神"];
    [jobr startRequestWithCompleted:^(ResponseState *state)
     {
        @strongify(self);
         
        NSArray *jobs = [JobModel arrayObjectWithDS:state.data];
        for (JobModel *j in jobs){
            [persons addObject:j.name];
        }
        self.jobs = [persons copy];
        
        [self.tableView reloadInMain];
    }];
}

- (void)setupBannerView
{
    self.bannerView = [[SDCycleScrollView alloc ] init];
    self.bannerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * (175 / 375.0));
    self.tableView.tableHeaderView = self.bannerView;
    
    @weakify(self);
    _bannerView.clickItemOperationBlock = ^(NSInteger currentIndex)
    {
        @strongify(self);
        NetRedBannerModel *m = self.banners[currentIndex];
        NSURL *url = m.show_url ? m.show_url : m.jump_url;
        
        WebActivityViewController *wv = [[WebActivityViewController alloc] initWithURL:url];
        if (AX_WEB_VIEW_CONTROLLER_iOS9_0_AVAILABLE()) {
            wv.webView.allowsLinkPreview = YES;
        }
        wv.showsToolBar = NO;
        [self.navigationController pushViewController:wv animated:YES];
    };
    
    [self requestBannerList];
}

- (void)requestBannerList
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
