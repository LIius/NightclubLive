//
//  MineViewController.m
//  NightclubLive
//
//  Created by SuperDanny on 2016/12/7.
//  Copyright © 2016年 WanBo. All rights reserved.
//  Edit by cr

#import "MineViewController.h"
#import "MineViewModel.h"
#import "TagView.h"
#import "HeaderTagView.h"
#import "UINavigationBar+Awesome.h"
#import "User.h"
#import "UserDetailRequest.h"
#import "UserTagView.h"
#import "LocationTool.h"
#import "MineRequest.h"
#import "AuthRequest.h"
#import "GlobalRequest.h"
#import "AuthModel.h"
#import "UserInfoViewController.h" // 用户资料
#import "BusinessNoAuthViewController.h" // 无认证
#import "CarCertificationViewController.h" // 车辆认证
#import "CarCertificationListTablViewController.h" // 车辆认证
#import "OrderHomeViewController.h" // 我的订单
#import "MyBindBarListViewController.h" // 我的酒吧列表
#import "FollowFanViewController.h"
#import "AuthVideoListVC.h"
#import "UILabel+NavTitleView.h"
#import "UIAlertController+Factory.h"
#import "BlocksKit+UIKit.h"
#import "NCAlert.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "PrizeViewController.h"
#import "MyGiftListViewController.h"

@interface MineViewController ()
{
    LocationTool *_location;
}

@property (weak, nonatomic) IBOutlet UIImageView *bgHeaderImg;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImg; ///用户头像
@property (weak, nonatomic) IBOutlet UILabel *userNameLab; ///用户名
@property (weak, nonatomic) IBOutlet UIButton *locationBtn; ///定位
@property (weak, nonatomic) IBOutlet UserTagView *userTagView; ///头像下方标签视图
@property (weak, nonatomic) IBOutlet UILabel *myBillMemoLab; // 未领取
@property (weak, nonatomic) IBOutlet UIView *nbRechargeView;
@property (weak, nonatomic) IBOutlet UIView *mnbRechargeView;
@property (weak, nonatomic) IBOutlet UIButton *gzBtn; /** 关注btn */
@property (weak, nonatomic) IBOutlet UIButton *fenBtn;
@property (weak, nonatomic) IBOutlet UILabel *ncBtnLabel; /** 夜比特值 */
@property (weak, nonatomic) IBOutlet UILabel *mncBtn; /** 小夜币 */
@property (weak, nonatomic) IBOutlet UIImageView *rankIV;
@property (weak, nonatomic) IBOutlet UILabel *rankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *InvitationLabel;
@property (weak, nonatomic) IBOutlet UserTagView *idV;

@property (nonatomic, strong) MineViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIImageView *liveImg;
///夜比特
@property (weak, nonatomic) IBOutlet UILabel *ybtCountLab;
///小夜币
@property (weak, nonatomic) IBOutlet UILabel *xybCountLab;
///我要认证-标签视图
@property (weak, nonatomic) IBOutlet TagView *subTagView;
///我的礼物数量
@property (weak, nonatomic) IBOutlet UILabel *myGiftCountLab;
///直播统计-标签视图
@property (weak, nonatomic) IBOutlet HeaderTagView *headerTagView;
@property (weak, nonatomic) IBOutlet UIImageView *InvitationIV;

@end

@implementation MineViewController
@dynamic viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 为了让父类不执行刷新方法
    [self.dataSource addObject:@""];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    self.navigationItem.titleView = [UILabel navWithTitle:@"我的"];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    adjustsScrollViewInsets_NO(self.tableView,self);

    @weakify(self);
    
    // 点击--夜比特充值{使用BlockKit}
    [_nbRechargeView bk_whenTapped:^
    {
        @strongify(self);
        [self.navigationController pushViewController:ViewController(@"MyAccountSB", @"MyAccountCollectionViewController") animated:YES];
    }];
    
    // 点击--零钱{使用BlockKit}
    [_mnbRechargeView bk_whenTapped:^
    {
        @strongify(self);
        [self.navigationController pushViewController:ViewController(@"MiniNightBitSB", @"MiniNightBitViewController") animated:YES];
    }];
    
    // 添加刷新按键,获取用户信息
    self.isHead = YES;
    MJRefreshNormalHeader *head =(MJRefreshNormalHeader *) self.tableView.mj_header;
    head.stateLabel.hidden = YES;
    
    [self refreshMethod];
    
    // 隐藏功能
    self.myBillMemoLab.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [self configureUserDataInMain];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Request
- (void)refreshMethod
{
    if (CurrentUser.status == CurrentUserStatusSignOut)
    {
        [UserInfo needLogin];
        [self.tableView endRefresh];
        return;
    }
    
    @weakify(self);
    // 更新资料
    [CurrentUser updateUserDataAndAccountCompletion:^(id param)
    {
        @strongify(self);
        
        [self.tableView endRefresh];
        // 刷新界面
        [self configureUserDataInMain];
    }];
}

#pragma mark - Data Source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 12;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    if (section == 1)
    {
        if (row == 0){
            // 魅力等级
            PushViewController(ViewController(@"RankSB", @"RankViewController"));
        }
        else if (row == 1){
            // 土豪等级
            PushViewController(ViewController(@"TheRichSB", @"TheRichViewController"));
        }
        else if (row == 2){
            // 我的奖品
            MyGiftListViewController *vc = [MyGiftListViewController initSBWithSBName:@"MyGiftListSB"];
            PushViewController(vc);
        }
        else if (row == 3){
            // 我的分佣
            PushViewController(ViewController(@"InvitationCodeSB", @"InvitationCodeViewController"));
        }
    }
    else if (section == 2)
    {
        if(row == 0)
        {
            // 我要认证
            [self goMyAuthen];
        }
    }
    else if (section == 3)
    {
        // 设置
        [self.navigationController pushViewController:ViewController(@"SettingSB", @"SettingTableViewController") animated:YES];
    }
    
}

- (BOOL)navigationShouldPopOnBackButton
{
    if (!CurrentUser.user)
    {
        [UserInfo needLogin];
        return NO;
    }
    
    return YES;
}

#pragma mark - 配置用户信息在主线程
- (void)configureUserDataInMain
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self configureData];
    });
}

#pragma mark - 配置用户信息
- (void)configureData
{
    UserInfo *currentUser = [UserInfo shareUser];
    
    [_userHeaderImg sd_setImageWithURL:currentUser.user.profile_photo placeholderImage:[UIImage userPlaceholder]];
    [_bgHeaderImg sd_setImageWithURL:currentUser.user.profile_photo placeholderImage:[UIImage userPlaceholder]];
    _userNameLab.text = currentUser.user.user_name;
    [_locationBtn setTitle:currentUser.user.city forState:UIControlStateNormal];
    
    // 粉丝
    [_fenBtn setTitle:[NSString stringWithFormat:@" 粉丝 %@",[UserInfo shareUser].user.fanNum ? [UserInfo shareUser].user.fanNum : @""] forState:UIControlStateNormal];
    // 关注
    [_gzBtn setTitle:[NSString stringWithFormat:@" 关注 %@",currentUser.user.gzNum ? currentUser.user.gzNum : @""]   forState:UIControlStateNormal];
    
    // 夜比特
    [_ncBtnLabel setText:currentUser.account.night_bit];
    // 小夜币
    [_mncBtn setText:currentUser.account.user_rmb];
    _InvitationLabel.text = [NSString stringWithFormat:@"邀请码:%@",currentUser.user.userInvitationCode];
    
    // 配置section cell 内容女
    // 1.等级
    _rankNameLabel.text = CurrentUser.account.rankName;
    NSString *rankImageName = [NSString stringFromeArray:@[@"icon_levelone",@"icon_levelyellowdiamond",@"icon_levelbluediamond",@"icon_levelpurplediamond"] index:CurrentUser.account.rank];
    _rankIV.image = KGetImage(rankImageName);
    
    // 用户标志位
    _userTagView.model = currentUser.user;
    _idV.contentAlignType = 2;
    _idV.tag = 2;
    _idV.model = currentUser.user;
}

#pragma mark - 点击头像
- (IBAction)infoAction:(id)sender
{
    if (!CurrentUser.user){
        [UserInfo needLogin];
        return;
    }
    
    UserInfoViewController *vc = [UserInfoViewController initSBWithSBName:@"UserInfoSB"];

    vc.userModel = CurrentUser.user;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 点击关注或粉丝
- (IBAction)followAndFanClick:(UIButton *)sender
{
    FollowFanViewController *vc = [FollowFanViewController initSBWithSBName:@"FollowFanSB"];
    vc.tag = sender.tag;
    
    PushViewController(vc);
}

#pragma mark - 点击我要认证
- (void)goMyAuthen
{
    [NCAlert showActionSheetWithDataSource:@[@"视频认证",@"车辆认证"] blockHandel:^(NSInteger index) {
        UIViewController *vc = nil;
        
        if (index == 0)
        {
            AuthVideoListVC *v = [AuthVideoListVC initSBWithSBName:@"AuthVideoListSB"];
            vc = v;
        }
        else if (index == 1)
        {
            // 车辆认证
            __block __strong UIViewController *vc;
            ShowLoading
            
            if (!CurrentUser.user.vehicle_certification)
            {
                //先获取车辆认证列表,如果存在就直接获取
                GetCarRequest *r = [GetCarRequest new];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                if ([UserInfo shareUser].userID.length >0)
                {
                    [params setValue:[UserInfo shareUser].userID forKey:@"userId"];
                }
                r.param = params;
                //r.param = @{@"userId":[UserInfo shareUser].userID};
                
                [r startRequestWithCompleted:^(ResponseState *state)
                 {
                     CloseLoading
                     
                     NSArray *arry = [CarAuthModel arrayObjectWithDS:state.datas];
                     if (arry.count == 0)
                     {
                         vc = ViewController(@"CarCertificationSB", @"CarCertificationViewController");
                     }
                     else{
                         
                         CarCertificationListTablViewController *v = ViewController(@"CarCertificationListSB", @"CarCertificationListTablViewController");
                         v.cars = arry;
                         vc = v;
                     }
                     
                     [self.navigationController pushViewController:vc animated:YES];
                 }];
            }
            else{
                
                CloseLoading
                CarCertificationListTablViewController *v = ViewController(@"CarCertificationListSB", @"CarCertificationListTablViewController");
                vc = v;
                
                //先这样修复，等有空了再回来修
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma mark - 点击我的夜店
- (void)goMyClub
{
    // 我的夜店
    [CurrentUser getYWBToken:^(NSString *token) {
        // 判断是不是有酒吧列表
        GetMyBarListRequest *getR = [GetMyBarListRequest new];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (CurrentUser.userID.length >0) {
            [params setValue:CurrentUser.userID forKey:@"user.appUserId"];
        }
        if (token.length > 0) {
            [params setValue:token forKey:@"token"];
        }
        getR.param = params;
        
        //getR.param = @{@"user.appUserId":CurrentUser.userID,@"token":token};
        [getR startRequestWithCompleted:^(ResponseState *state)
         {
             NSArray *array = [BarBindModel arrayObjectWithDS:state.data];
             if (array.count > 0){
                 MyBindBarListViewController *bindlistVC = ViewController(@"MyBindBarListSB", @"MyBindBarListViewController");
                 [bindlistVC.dataSource addObjectsFromArray:array];
                 PushViewController(bindlistVC);
             }
             else{
                 BusinessNoAuthViewController *vc = ViewController(@"BusinessNoAuthSB", @"BusinessNoAuthViewController");
                 vc.tag = 2;
                 [self.navigationController pushViewController:vc animated:YES];
             }
         }];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
