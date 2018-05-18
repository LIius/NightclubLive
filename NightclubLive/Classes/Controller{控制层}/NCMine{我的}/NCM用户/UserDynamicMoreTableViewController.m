//
//  UserDynamicMoreTableViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/17.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "UserDynamicMoreTableViewController.h"
#import "UserDynamicCell.h"
#import "UINavigationBar+Awesome.h"

#import "ClubCircleRequest.h"
#import "DynamicListModel.h"
#import "ReleaseDynamicVC.h"
#import "ClubCircleDynamicDetailVC.h"
#import "MineRequest.h"
#import "UserTagView.h"

@interface UserDynamicMoreTableViewController ()
<
UINavigationControllerDelegate
>

@property (weak, nonatomic) IBOutlet UIImageView *userHeadIV;
@property (weak, nonatomic) IBOutlet UIImageView *backIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *cityLabel;
@property (weak, nonatomic) IBOutlet UserTagView *userTagView;
@property (weak, nonatomic) IBOutlet UIView *releaseView;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UIImageView *sexIV;

@property (nonatomic, weak) User *model;

@end

@implementation UserDynamicMoreTableViewController

@dynamic model;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    adjustsScrollViewInsets_NO(self.tableView,self);

    [self setupViewDidload];
    
    // 请求数据
    [self setupRequest];
    
    [self.view layoutIfNeeded];
    [self setupTagView];
    [self setupReleaseView];
}

- (void)viewWillAppear:(BOOL)animated
{
     [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;

//    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self.navigationController.navigationBar lt_reset];
}

- (void)setNavigationColor:(CGFloat)contentOffSet_y
{
    if (contentOffSet_y <= 0)
    {
        [self.navigationController.navigationBar lt_setBackgroundColor:RGBACOLOR(56.0, 25.0, 114.0, 0.0)];
    }
    
    if (contentOffSet_y >= 0)
    {
        if (iPhoneX) {
            if (contentOffSet_y <= 154.0)
            {
                [self.navigationController.navigationBar lt_setBackgroundColor:RGBACOLOR(56.0, 25.0, 114.0, 1.0 / 154.0 * contentOffSet_y)];
            } else {
                [self.navigationController.navigationBar lt_setBackgroundColor:RGBACOLOR(56.0, 25.0, 114.0, 1.0)];
            }
            
        }else{
            if (contentOffSet_y <= 130.0)
            {
                [self.navigationController.navigationBar lt_setBackgroundColor:RGBACOLOR(56.0, 25.0, 114.0, 1.0 / 130.0 * contentOffSet_y)];
            } else {
                [self.navigationController.navigationBar lt_setBackgroundColor:RGBACOLOR(56.0, 25.0, 114.0, 1.0)];
            }
        }
        
    }
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setNavigationColor:scrollView.contentOffset.y];
}

- (void)setupReleaseView
{
    if (![self.model.userId isEqualToString:CurrentUser.userID])
    {
        UIView *tableViewHead = self.tableView.tableHeaderView;
        tableViewHead.height = tableViewHead.height - _releaseView.height + 10;
        [self.tableView setTableHeaderView:tableViewHead];
        
        [_releaseView removeFromSuperview];
    }
}

#pragma mark - 返回
- (IBAction)pop:(id)sender
{
    // 使用系统的，这个暂时隐藏
}

#pragma mark - Request
- (void)refreshMethod
{
    MyDynamicListRequest *r = [MyDynamicListRequest new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.pageNow) {
        [params setValue:@(self.pageNow) forKey:@"pageNow"];
    }
    if (self.model.userId.length > 0) {
        [params setValue:self.model.userId forKey:@"userId"];
    }
    r.param = params;
    //r.param = @{@"pageNow":@(self.pageNow),@"userId":self.model.userId};
    @weakify(self);
    [r startRequestWithCompleted:^(ResponseState *state) {
        @strongify(self);
        self.parses = [DynamicListModel arrayObjectWithDS:state.datas];

        NSArray *datas = state.datas;
        if (datas.count == 0)
        {
            // 设置结束图片
            UIImageView *endFootView = [[UIImageView alloc] initWithImage:KGetImage(@"icon_bottom")];
            endFootView.contentMode = UIViewContentModeCenter;
            endFootView.frame = CGRectMake(0, 0, self.view.height, 40);
            endFootView.backgroundColor = [UIColor whiteColor];
            
            self.tableView.tableFooterView = endFootView;
            self.tableView.mj_footer = nil;
        }
    }];
    
}

#pragma mark - Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 107;
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
    UserDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:UserDynamicCellReuseID];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClubCircleDynamicDetailSuperVC *vc = [ClubCircleDynamicDetailSuperVC initSBWithSBName:@"ClubCircleDynamicDetailSuperSB"];
    vc.model = self.dataSource[indexPath.row];
    PushViewController(vc);
}

- (void)setupRequest
{
    self.isFoot = YES;
    self.pageNow = 1;
    [self refreshMethod];
}

- (void)setupTagView
{
    self.userTagView.contentAlignType = 0;
    self.userTagView.model = self.model;
}

- (void)setupViewDidload
{
    self.isShowEmpty = NO;
    [_backIV sd_setImageWithURL:self.model.profile_photo placeholderImage:[UIImage userPlaceholder]];
    [_userHeadIV sd_setImageWithURL:self.model.profile_photo placeholderImage:[UIImage userPlaceholder]];
    _nameLabel.text = self.model.user_name;
    [_cityLabel setTitle:self.model.city forState:UIControlStateNormal];
    _sexIV.image = [UIImage sex2ImageWithType:self.model.sex];
}

#pragma mark - 添加动态
- (IBAction)addDynamic:(id)sender
{
    ReleaseDynamicVC *vc = [ReleaseDynamicVC initSBWithSBName:@"CCReleaseDynamic"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 查看头像
- (IBAction)logoClick:(id)sender
{
    [XLPhotoBrowser showPhotoBrowserWithImages:@[self.model.profile_photo] currentImageIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
