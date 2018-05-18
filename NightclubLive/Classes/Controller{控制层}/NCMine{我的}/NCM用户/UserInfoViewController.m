//
//  UserInfoViewController.m
//  NightclubLive
//
//  Created by SuperDanny on 2016/12/28.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UINavigationBar+Awesome.h"
#import "UserTagView.h"
#import "UserDynamicMoreTableViewController.h"

#import "PaiPaiVC.h"
#import "User.h"
#import "TagView.h"
#import "PaiPaiModel.h"
#import "ContributionViewController.h"
#import "UserDetailRequest.h"

#import "ImageCollectionViewCell.h"
#import "ZFPlayer.h"

#import "PhotoAlbumCollectionViewController.h"

#import "MineRequest.h"
#import "UserInfoFuncView.h"
#import "XLPhotoBrowser.h"
#import "GlobalRequest.h"
#import "MineRequest.h"
#import "MineModelList.h"
#import "MineRequest.h"
#import "RankViewController.h"
#import "NetRedCircelRankViewController.h"
#import "UpLoadVideoVC.h"
#import "VideoVC.h"
#import "VideoTool.h"
#import "PaiPaiPostVideoViewModel.h"
#import "ConvertTool.h"
#import "PostVideoPlayerController.h"

#import "AuthVideoViewController.h"
#import "PaiPaiUpload.h"
#import "LGAudioKit.h"
#import "DownloadAudioService.h"
#import "UIImageView+SDWebImage.h"
#import "AppointmentViewController.h"
#import "UIAlertController+Factory.h"
#import "BlocksKit+UIKit.h"
#import "GiftTool.h"
#import "NCAlert.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface UserInfoViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
LGAudioPlayerDelegate
>

@property (weak, nonatomic) IBOutlet UserTagView *userTagView;
@property (weak, nonatomic) IBOutlet UIButton *playVideoBtn; // 头像的播放按钮
@property (weak, nonatomic) IBOutlet UIButton *livePlayBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgHeaderImg; //用户头像背景
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImg; ///用户头像
@property (weak, nonatomic) IBOutlet UILabel *userNameLab; ///用户名
@property (weak, nonatomic) IBOutlet UIButton *locationBtn; ///定位
@property (weak, nonatomic) IBOutlet UILabel *barLabel; // 酒吧Label
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollection;//相册label
@property (weak, nonatomic) IBOutlet UILabel *dynamicContentLabel;//动态内容label
@property (weak, nonatomic) IBOutlet UIImageView *dynamicIV;//动态文本lable
@property (weak, nonatomic) IBOutlet UILabel *dynamicTimeLabel;//发布动态时间label
@property (weak, nonatomic) IBOutlet UIButton *dynamicCityLabel;//发布动态地区lable
@property (weak, nonatomic) IBOutlet UILabel *dynamicNoLabel;
@property (weak, nonatomic) IBOutlet UITextField *signalTF;/** 个性签名部分 */
@property (weak, nonatomic) IBOutlet UITextField *constellatoryTF;//星座TF
@property (weak, nonatomic) IBOutlet UITextField *affectionTF;//情感TF
@property (weak, nonatomic) IBOutlet UITextField *jobTF;//工作TF
@property (weak, nonatomic) IBOutlet UITextField *incomeTF;//收入TF
@property (weak, nonatomic) IBOutlet UILabel *authCarLabel;
@property (weak, nonatomic) IBOutlet UILabel *authVideoLabel;
@property (weak, nonatomic) IBOutlet UILabel *noImageTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *photoMoreBtn;/** 相册查看更多 */
@property (weak, nonatomic) IBOutlet UIButton *photoAddBtn;/** 相册添加 */
@property (weak, nonatomic) IBOutlet UIButton *dynamicMoreBtn;/** 动态更多 */
@property (weak, nonatomic) IBOutlet UIButton *dynamicBtn;/** 动态添加 */
@property (weak, nonatomic) IBOutlet UIButton *signatureBtn;
@property (weak, nonatomic) IBOutlet UIView *rankView;
@property (weak, nonatomic) IBOutlet UIView *rankViewBackView;
@property (weak, nonatomic) IBOutlet UILabel *charmRankListLabel;//排行榜部分
@property (weak, nonatomic) IBOutlet UILabel *charmLabel;
@property (weak, nonatomic) IBOutlet UILabel *theRichLabel;
@property (weak, nonatomic) IBOutlet UILabel *thiRichRankListLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIImageView *paipaiCoverURLIV;//拍拍部分
@property (weak, nonatomic) IBOutlet UILabel *paipaiEmptyLabel;
@property (weak, nonatomic) IBOutlet UILabel *paipaiContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *paipaiTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *paipaiLocationLabel;
@property (weak, nonatomic) IBOutlet UIButton *paipaiAddBtn;
@property (weak, nonatomic) IBOutlet UIButton *paipaiAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *appointmentBtn; //约台
@property (weak, nonatomic) IBOutlet UILabel *heatVoinceLable; // 心声文本
@property (weak, nonatomic) IBOutlet UIView *heatVoiceV; // 声音视图
@property (weak, nonatomic) IBOutlet UILabel *noHeatVoiceLabel; // 没有心声视图
@property (weak, nonatomic) IBOutlet UIButton *heatCityLable; // 心声城市
@property (weak, nonatomic) IBOutlet UIButton *heatVovicePlayBtn; // 声音播放按钮
@property (weak, nonatomic) IBOutlet UILabel *heatVoicePlayLabel; // 声音秒数

@property (nonatomic, strong) UserInfoFuncView *funcView;/** 菜单功能按键 */
//@property (nonatomic, weak) User *model;
@property (nonatomic, assign) BOOL isSelf;/** 是否是自己 */
@property (nonatomic, assign) BOOL isBlack;/** 是否是与自己是黑名单 */
@property (nonatomic, strong) PaiPaiUpload  *paipaiUpload;
@property (strong, nonatomic) NSArray *cells;
@property (nonatomic,assign) NSInteger collectionWH; // 相册图片宽高
@property (nonatomic,assign)BOOL hasBar; // 是否有认证酒吧

@property (weak, nonatomic) IBOutlet UILabel *campaignContentLabel;/** 竞选部分 */
@property (weak, nonatomic) IBOutlet UILabel *campaignPollLable;
@property (weak, nonatomic) IBOutlet UIImageView *campaingCoverIV;
@property (weak, nonatomic) IBOutlet UIView *campaingSuperView;
@property (weak, nonatomic) IBOutlet UILabel *campainNoLable;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;///性别
@property (weak, nonatomic) IBOutlet UILabel *ageLab;///年龄
@property (nonatomic, weak) IBOutlet UILabel *barTipLabel;/** 酒吧提示 */
@property (weak, nonatomic) IBOutlet UITextField *idTF;//用户IDTF
@property (weak, nonatomic) IBOutlet UILabel *wishLabel;//许愿盒label
@property (weak, nonatomic) IBOutlet UIButton *campaignMoreBtn;/** 竞选更多 */
@property (weak, nonatomic) IBOutlet UIButton *infoBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;
@property (weak, nonatomic) IBOutlet UIButton *blackBtn;
@property (weak, nonatomic) IBOutlet UIButton *barBtn;/** 酒吧编辑 */
@property (weak, nonatomic) IBOutlet UIButton *wishBtn;/** 许愿 */
@property (weak, nonatomic) IBOutlet UILabel *authJobLabel;/** 认证信息 */
@property (weak, nonatomic) IBOutlet TagView *tagView;///标签视图

@end

@implementation UserInfoViewController
@dynamic model;

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.fd_prefersNavigationBarHidden = YES;
    
    self.fd_interactivePopDisabled = YES;

    adjustsScrollViewInsets_NO(self.tableView,self);

    self.hasBar = NO;
    self.isShowEmpty = NO;
    self.collectionWH = (_photoCollection.width - 10 * 3) * 0.25;
    
    [self setupViewDidload];
}

- (void)dealloc
{
    if (self.calkBlock)
        self.calkBlock(nil);
    
    [_funcView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    
    [self purpeNav];
    

    [self setupUserData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)purpeNav{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    [self scrollViewDidScroll:self.tableView];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}

#pragma mark - 离开视图
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController.navigationBar lt_reset];
    
    
    // 如果用户没有登录就返回
    if (!CurrentUser.user.userId)
    {
        [self.navigationController popViewControllerAnimated:YES];
        
        return;
    }
    
    if (_funcView)
    {
        _funcView.hidden = YES;
    }
    
    if (self.userModel.userId == CurrentUser.userID)
    {
        [[UserInfo shareUser] reSetUserData:self.userModel];
    }
    
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

#pragma mark - 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0)
        return 0;
    else if (row == 1)
        return 80;
    else if (row == 2){
        
        // 相册cell
        if ( self.userModel.photos == nil){
            return 70;
        }
        
        NSInteger defaultCount = 0;
        if (SCREEN_WIDTH == 320.0  ) {
            defaultCount = 3;
        }else{
            defaultCount = 4;
        }
        
        NSInteger count = 0;
        NSInteger num = self.userModel.photos.count % defaultCount;
        if (num == 0)
        {
            count = self.userModel.photos.count / defaultCount;
        }else{
            count = (self.userModel.photos.count / defaultCount) + 1;
        }
   
        DLog(@"{count=%ld",(long)count);
        return  self.collectionWH * count + 60;
    }
    else if (row == 3){
        
        if (_userModel.content.length >= 1 ||_userModel.dynamicImages.count >= 1){
            return 120;
        }else{
            return 75;
        }
    }
    else if (row == 4){
        
        if (_userModel.videoUrl){
            return 120;
        }
        else{
            return 75;
        }
    }
    else if (row == 5){
        if (!self.isSelf){
            // 如果查看别人的就看不到心声
            return TABLE_HEAD_FOOT_SPACE;
        }
        else{
            
            if (self.userModel.heart_voicelen){
                // coderiding
                return 120;
            }
            else
                return 75;
        }
    }
    
    else if (row == 6)
        return 140;
    else if (row == 7)
        return 80;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = 0;
    count = self.userModel.photos.count;
    
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const ImageCollectionViewCellReuseID = @"ImageCollectionViewCell";
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCollectionViewCellReuseID forIndexPath:indexPath];
    
    if (self.isSelf)
    {
        if (indexPath.row < _userModel.photos.count)
        {
            [cell.imgIV imageViewSizeWithURL:_userModel.photos[indexPath.row] placeholderImage:[UIImage picturePlaceholder]];
            
        }
        else{
            [cell.imgIV imageViewSizeWithURL:nil placeholderImage:KGetImage(@"icon_addition")];
        }
    }
    else{
        [cell.imgIV imageViewSizeWithURL:_userModel.photos[indexPath.row] placeholderImage:nil];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.collectionWH;
    return CGSizeMake(width, width);
}

#pragma mark - 上下最小距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

#pragma mark - 左右做小距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isSelf && _userModel.photos.count == indexPath.row)
    {
        PushViewController(ViewController(@"UploadAlbumSB", @"UploadPhotoAlbumViewController"));
        return ;
    }
    
    [XLPhotoBrowser showPhotoBrowserWithImages:self.userModel.photos currentImageIndex:indexPath.row];
}

- (void)setupViewDidload
{
    @weakify(self);
    
    // 先隐藏
    _appointmentBtn.hidden = YES;
    
    // 如果是别人的资料
    if (!self.isSelf)
    {
        _barBtn.hidden = YES;
        _wishBtn.hidden = YES;
        _photoAddBtn.hidden = YES;
        _dynamicBtn.hidden = YES;
        _signatureBtn.hidden = YES;
        _paipaiAddBtn.hidden = YES;
        [ShareWindow addSubview:self.funcView];
    }
    else{
        [_moreBtn setTitle:@"我的资料" forState:UIControlStateNormal];
        [_moreBtn setImage:nil forState:UIControlStateNormal];
        _moreBtn.width = 80;

    }
    
    // 添加相册
    [_photoAddBtn bk_whenTapped:^
     {
         @strongify(self);
         [self.navigationController pushViewController:ViewController(@"UploadAlbumSB", @"UploadPhotoAlbumViewController") animated:YES];
     }];
    
    // 查看更多相册
    [_photoMoreBtn bk_whenTapped:^
     {
         @strongify(self);
         PhotoAlbumCollectionViewController *vc = ViewController(@"PhotoAlbumCollectionSB", @"PhotoAlbumCollectionViewController");
         vc.model = self.userModel.userId;
         [self.navigationController pushViewController:vc animated:YES];
     }];
    
    // 查看更多动态
    [_dynamicMoreBtn bk_whenTapped:^
     {
         @strongify(self);
         UserDynamicMoreTableViewController *tvc = ViewController(@"UserDynamicMoreSB",@"UserDynamicMoreTableViewController");
         tvc.model = self.userModel;
         [self.navigationController pushViewController:tvc animated:YES];
     }];
    
    // 添加动态
    [_dynamicBtn bk_whenTapped:^
     {
         @strongify(self);
         [self.navigationController pushViewController:ViewController(@"CCReleaseDynamic", @"ReleaseDynamicVC") animated:YES];
     }];
    
    // 修改个性签名
    [_signatureBtn bk_whenTapped:^
     {
         @strongify(self);
         UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"修改个性签名" okBlock:^(id param) {
             
             // 提交个性签名到服务器
             UpdateUserInfoRequest *r = [UpdateUserInfoRequest new];
             r.sign = param;
             [r startRequestWithCompleted:^(ResponseState *state) {
                 @strongify(self);
                 if (state.isSuccess){
                     self.userModel.autograph = param;
                     [self reloadUserDataInMain];
                 }
                 else
                     ShowError(@"修改用户签名失败");
             }];
             
         }];
         
         [self presentViewController:ac animated:YES completion:nil];
     }];
    
    
    [self.view layoutIfNeeded];
    _rankView.layer.cornerRadius = 22;
    _rankView.layer.masksToBounds = YES;
    
    // 设置等级阴影
    [_rankViewBackView setShadowColor:RGBA(90, 20, 67, 0.14) radius:11 opacity:13 offset:CGSizeMake(0, 1)];
}

- (void)setupUserData
{
    if (_funcView)
    {
        _funcView.hidden = NO;
    }
    

    ObjectRequest *request = nil;

    if ([self.userModel.userId isEqualToString:CurrentUser.userID] || [self.userModel.phone_num isEqualToString:CurrentUser.lgPhone])
    {
        // 自己查看自己的
        UserDetailRequest *r = [UserDetailRequest new];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (CurrentUser.userID.length > 0)
        {
            [params setValue:CurrentUser.userID forKey:@"userId"];
        }
        
        r.param = params;
        request = r;
    }
    else{
        // 查看别人
        GetOtherPersonRequest *r = [GetOtherPersonRequest new];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (self.userModel.userId)
        {
            if (self.userModel.userId.length > 0)
            {
                [params setValue:self.userModel.userId forKey:@"user_id"];
            }
            
            if (CurrentUser.userID.length > 0)
            {
                [params setValue:CurrentUser.userID forKey:@"userId"];
            }
            
            r.param = params;
        }
        else{
            
            if (self.userModel.phone_num.length >0)
            {
                [params setValue:self.userModel.phone_num forKey:@"phoneNum"];
            }
            
            if (CurrentUser.userID.length > 0)
            {
                [params setValue:CurrentUser.userID forKey:@"userId"];
            }
            
            r.param = params;
        }
        
        request = r;
    }
    
    @weakify(self);
    // 开始请求用户数据
    [request startRequestWithCompleted:^(ResponseState *state)
    {
        @strongify(self);
        if (!state.isSuccess)
        {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" withMessage:@"用户资料获取失败" calk:^(id param) {

            }];
            PresentViewController(ac);
        }
        else{
            
            User *userDetail = [User objectWithDic:[state.data firstObject]];
            self.userModel = userDetail;
            DLog(@"{emotion=%@",self.userModel.emotion);
            [self reloadUserDataInMain];

            // 获取等级排名
            PersonRankListRequest *r = [[PersonRankListRequest alloc] init];
            r.model = userDetail.userId;
            [r startRequestWithCompleted:^(ResponseState *state) {
                @strongify(self);
                NSDictionary *param = [state.data firstObject];
                _charmLabel.text = [NSString stringWithFormat:@"%d",[param[@"charm_value"] integerValue]];
                _charmRankListLabel.text = [NSString stringWithFormat:@"%d",[param[@"charm_rownum"] integerValue]];
                
                _theRichLabel.text = [NSString stringWithFormat:@"%0.2f",[param[@"daifug_value"] doubleValue]];
                _thiRichRankListLabel.text = [NSString stringWithFormat:@"%d",[param[@"daifug_rownum"] integerValue]];
                
                [self reloadUserDataInMain];
            }];
            
            // 获取用户土豪等级
            PersonRankListRequest *rankR = [PersonRankListRequest new];
            rankR.model = userDetail.userId;
            [rankR startRequestWithCompleted:^(ResponseState *state) {
                @strongify(self);
                TheRichModel *m = [[TheRichModel alloc] initWithDic:[state.datas firstObject]];
                _userModel.theRichNum = m.rankNum;
                
                [self reloadUserDataInMain];
            }];
            
            
            // 获取绑定的酒吧列表
            [CurrentUser getYWBToken:^(id param)
            {
                
                if (self.userModel.userId)
                {
                    GetMyBarListRequest *bindListR = [GetMyBarListRequest new];
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    if (param) {
                        [params setValue:param forKey:@"token"];
                    }
                    if (userDetail.userId.length > 0) {
                        [params setValue:userDetail.userId forKey:@"user.appUserId"];
                    }
                    bindListR.param = params;
                    
                    [bindListR startRequestWithCompleted:^(ResponseState *state)
                     {
                        @strongify(self);
                        NSArray *array = [BarBindModel arrayObjectWithDS:state.data];
                        if (array.count > 0)
                        {
                            // 有绑定
                            NSString *barStr = @"";
                            
                            BarBindModel *fristM = array.firstObject;
                            barStr = fristM.name;
                            
                            if (array.count > 1){
                                
                                for (NSInteger i = 1; i < array.count ; i ++){
                                    BarBindModel *m = array[i];
                                    
                                    barStr = [NSString stringWithFormat:@"%@,%@",barStr,m.name];
                                    
                                    if (barStr.length > 15)
                                        break;
                                }
                            }
                            
                            if (barStr.length > 15){
                                barStr = [barStr substringWithRange:(NSRange){0,14}];
                                barStr = [NSString stringWithFormat:@"%@。。。",barStr];
                            }
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.hasBar = YES;
                                _barLabel.text = barStr;
                                _barLabel.font = [UIFont systemFontOfSize:14];
                                _barLabel.textColor = [UIColor blackColor];
                            });
                            
                            [self reloadUserDataInMain];
                            
                        }else{
                            self.hasBar = NO;
                        }
                    }];
                }
                
            }];
            
        }
        
    }];
    
}

- (void)reloadUserDataInMain
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self loadUserDataToView];
    });
}

#pragma mark - 刷新用户数据
- (void)loadUserDataToView
{
    // 设置头部信息
    [_bgHeaderImg sd_setImageWithURL:_userModel.profile_photo placeholderImage:[UIImage userPlaceholder]];
    [_userHeaderImg sd_setImageWithURL:_userModel.profile_photo placeholderImage:[UIImage userPlaceholder]];
    _userNameLab.text = _userModel.user_name;
    _userModel.city = _userModel.city;
    _ageLab.text = _userModel.age;
    _idTF.text = _userModel.phone_num;
    _sexView.image = [UIImage sex2ImageWithType:_userModel.sex];
    [_locationBtn setTitle:self.userModel.city forState:UIControlStateNormal];

    // 设置动态
    if (self.userModel.content.length >= 1 ||self.userModel.dynamicImages.count >= 1)
    {
        _dynamicContentLabel.text = self.userModel.content;
        [_dynamicCityLabel setTitle:self.userModel.dynamic_city forState:UIControlStateNormal];

        [_dynamicIV imageViewSizeWithURL:[self.userModel.dynamicImages firstObject] placeholderImage:nil];
        
        _dynamicTimeLabel.text = self.userModel.dynamicTimeGap;
        _dynamicContentLabel.hidden = NO;
        _dynamicCityLabel.hidden  = NO;
        _dynamicIV.hidden = NO;
        _dynamicTimeLabel.hidden = NO;
        _dynamicNoLabel.hidden = YES;

    }
    else{
        _dynamicContentLabel.hidden = YES;
        _dynamicCityLabel.hidden  = YES;
        _dynamicIV.hidden = YES;
        _dynamicTimeLabel.hidden = YES;
        _dynamicNoLabel.hidden = NO;
    }
    
    // 相册部分
    if (_userModel.photos){//存在
        _noImageTipLabel.hidden = YES;
        _photoCollection.hidden = NO;
    }
    else{
        // 不存在
        _noImageTipLabel.hidden = NO;
        _photoCollection.hidden = YES;
    }
    
    // 拍拍部分
    if (_userModel.videoUrl){
        _paipaiEmptyLabel.hidden = YES;
    }
    else{
        _paipaiTimeLabel.hidden = YES;
        _paipaiCoverURLIV.hidden = YES;
        _paipaiContentLabel.hidden = YES;
        _paipaiLocationLabel.hidden = YES;
    }
    
    // 个性签名
    if (self.userModel.autograph.length >= 1)
        _signalTF.text = self.userModel.autograph;
    
    // 个人资料显示
    // 星座
    if (self.userModel.constellation)
        _constellatoryTF.text = self.userModel.constellation;
    
    // 情感
    if (self.userModel.emotion)
    {
        _affectionTF.text = SelectDataForKey(@"Emotion")[[self.userModel.emotion integerValue]];
    }
    
    // 职业
    if (self.userModel.job_name)
    {
        _jobTF.text = self.userModel.job_name;
    }
    
    
    if (self.userModel.income)
    {
        _incomeTF.text = [NSString stringWithFormat:@"%@",self.userModel.income];
    }
    
    // 认证信息
    if (self.userModel.profe_certification)
    {
        _authJobLabel.text = self.userModel.job_name;
    }
    
    // 车辆认证
    if(self.userModel.vehicle_certification)
    {
        _authCarLabel.text = _userModel.car_brand;
    }
    else{
        _authCarLabel.text = @"未认证";
    }
    
    // 视频认证
    if (self.userModel.video_certification)
    {
        _authVideoLabel.text = @"已通过";
        _playVideoBtn.hidden = NO;
    }else{
        _playVideoBtn.hidden = YES;
    }
    
    // 拍拍部分
    if (_userModel.videoUrl)
    {
        [_paipaiCoverURLIV sd_setImageWithURL:_userModel.coverUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
        {
            [_paipaiCoverURLIV autoAdjustWidth];
        }];
        
        _paipaiContentLabel.text = _userModel.paipai_content;
        _paipaiTimeLabel.text = _userModel.paiapiGap;
        [_paipaiLocationLabel setTitle:_userModel.paipai_city forState:UIControlStateNormal];
        _paipaiEmptyLabel.hidden = YES;

    }else{
        _paipaiEmptyLabel.hidden = NO;

    }

    [self.tableView reloadInMain];
    [self.photoCollection reloadDataInMain];
    
    _userTagView.model = self.userModel;
    
    if (_funcView)
    {
        NSString *title ;
        UIImage *image;
        if (self.userModel.follow == 0)
        {
            title = @"关注";
            image = KGetImage(@"icon_heartcarel");
        }
        else{
            title = @"已关注";
            image = KGetImage(@"icon_heartcareon");
        }
        
        [_funcView.followBtn setImage:image forState:UIControlStateNormal];
        [_funcView.followBtn setTitle:title forState:UIControlStateNormal];
    }
    
    // 约台
    _appointmentBtn.hidden = self.hasBar ? NO : YES;
    
    // 认证部分
    _playBtn.hidden = !self.userModel.video_certification;
    
    // 初始化心声值coderiding
    _heatVoinceLable.hidden = YES;
    _heatVoiceV.hidden = YES;
    _noHeatVoiceLabel.hidden = YES;
    // 心声部分
    if(_userModel.heart_voicelen)
    {
        _heatVoinceLable.hidden = YES;
        _heatVoiceV.hidden = NO;
        _noHeatVoiceLabel.hidden = YES;
    }
    else if (_userModel.heart_content.length >  0){
        _heatVoinceLable.hidden = NO;
        _heatVoiceV.hidden = YES;
        _noHeatVoiceLabel.hidden = YES;
        _heatVoinceLable.text = _userModel.heart_content;
    }
    else{
        
        _noHeatVoiceLabel.hidden = NO;
    }
    
    // 心声城市coderiding
    _heatCityLable.hidden = NO;
    if (_userModel.heart_city ) {
        [_heatCityLable setTitle:_userModel.heart_city forState:UIControlStateNormal];
    }else{
        _heatCityLable.hidden = YES;
    }
    
    [_heatVoicePlayLabel setText:[_userModel.heart_duration getMMSS]];
}

- (BOOL)isSelf
{
    return [self.userModel.userId isEqualToString:[UserInfo shareUser].userID] || [self.userModel.phone_num isEqualToString:CurrentUser.lgPhone];
}

- (BOOL)isBlack
{
    return [[NIMSDK sharedSDK].userManager isUserInBlackList:self.userModel.phone_num];
}

#pragma mark - 聊天关注送礼视图
- (UserInfoFuncView *)funcView
{
    if (!_funcView)
    {
        _funcView = [UserInfoFuncView initFromXIB];
        _funcView.frame = CGRectMake(0, SCREEN_HEIGHT - 45, SCREEN_WIDTH, 45);
        
        @weakify(self);
        // 聊天
        [_funcView.chatBtn bk_whenTapped:^{
            @strongify(self);
            [self chatClick];
        }];
        
        // 关注
        [_funcView.followBtn bk_whenTapped:^{
            @strongify(self);
            [self followClic];
        }];
        
        // 送礼
        [_funcView.blackBtn bk_whenTapped:^{
            @strongify(self);
            [self sendGift];
        }];
    }
    
    return _funcView;
}

#pragma mark - 头像点击
- (IBAction)logoClick:(id)sender
{
    if (!_userModel.profile_photo)
        return;
    
    [XLPhotoBrowser showPhotoBrowserWithImages:@[_userModel.profile_photo] currentImageIndex:0];
}

#pragma mark - 头像视频按钮点击
- (IBAction)auth_videoClick:(id)sender
{
    if (self.userModel.videoUrl)
    {
        AuthVideoViewController *authVideoVC = [AuthVideoViewController initSBWithSBName:@"AuthVideoSB"];
        authVideoVC.coverURL = self.userModel.coverUrl;
        authVideoVC.videoURL = self.userModel.videoUrl;
        [self.navigationController pushViewController:authVideoVC animated:YES];
    }
}

#pragma mark - 贡献榜
- (IBAction)contributionClick:(id)sender
{
    ContributionViewController *vc = ViewController(@"ContributionSB", @"ContributionViewController");
    PushViewController(vc);
}

#pragma mark - 排行榜
- (IBAction)rank:(UITapGestureRecognizer *)sender
{
    NSInteger tag = sender.view.tag;
    NetRedCircelRankViewController *rankVC = [NetRedCircelRankViewController initSBWithSBName:@"NRCRankSB"];
    rankVC.tag  = tag;
    
    PushViewController(rankVC);
}

#pragma mark - 我的资料或者黑名单
- (IBAction)moreClick:(id)sender
{
    // 先隐藏底部工具条
    _funcView.hidden = YES;
    
    if (self.isSelf)
    {
        
        // 我的资料
        ObjectTableViewController *vc = ViewController(@"MyDataSB", @"MyDataViewController");
        vc.model = self.userModel;
        PushViewController(vc);
    }
    else{
        
        NSString *msg = self.isBlack ?  @"移除黑名单" : @"拉入黑名单";
        [NCAlert showActionSheetWithDataSource:@[msg] blockHandel:^(NSInteger index) {
            if (index == 0)
            {
                if (self.isBlack){
                    [[NIMSDK sharedSDK].userManager removeFromBlackBlackList:self.userModel.phone_num completion:^(NSError * _Nullable error) {
                        [self  reloadUserDataInMain];
                    }];
                }
                else{
                    [[NIMSDK sharedSDK].userManager addToBlackList:self.userModel.phone_num completion:^(NSError * _Nullable error) {
                        
                        [self  reloadUserDataInMain];
                    }];
                }
                
                
            }
            
            _funcView.hidden = NO;
        } hideBlock:^{
            [self  reloadUserDataInMain];
            _funcView.hidden = NO;
        }];

    }
    
    
}

#pragma mark - 添加夜生活视频
- (IBAction)addPaiPaiClick:(id)sender
{
    @weakify(self);
    UpLoadVideoVC *uploadVC = [UpLoadVideoVC controllerWithViewModel:nil andSbName:@"CLPaiPaiSB"];
    
    uploadVC.calkBlock = ^(NSNumber *type)
    {
        @strongify(self);
        NSInteger t = [type integerValue];
        
        self.paipaiUpload = [[PaiPaiUpload alloc] init];
        [self.paipaiUpload selectVideoSourceWithType:t sourceVC:self];
        self.paipaiUpload.completionBlock = ^(NSURL *url)
        {
            @strongify(self);
            [self uploadVideToServer:url withVideo:@"MP4"];
        };
        
    };
    
    [self presentViewController:uploadVC animated:YES completion:nil];
}

#pragma mark - 夜生活更多视频
- (IBAction)allPaiPaiClick:(id)sender
{
    PaiPaiVC *vc = [PaiPaiVC initSBWithSBName:@"ClubLiveHome"];
    vc.tag = 1;
    vc.model = self.userModel.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 约台
- (IBAction)appointmentClick:(id)sender
{
    AppointmentViewController *vc = ViewController(@"AppointmentSB", @"AppointmentViewController");
    vc.model = self.userModel.userId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 切换到心声
- (IBAction)releaHeatVoiceClick:(id)sender
{
    UITabBarController *tab = (UITabBarController *)ShareWindow.rootViewController;
    tab.selectedIndex = 1;
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SWITCHHEAERT object:nil];
}

#pragma mark - 听心声
- (IBAction)heatVoiceplay:(id)sender
{
    [DownloadAudioService downloadAudioWithUrl:[_userModel.heart_voicelen absoluteString] saveDirectoryPath:DocumentPath fileName:@"xxxxxxx.amr" finish:^(NSString *filePath)
    {
        [[LGAudioPlayer sharePlayer] playAudioWithURLString:filePath atIndex:0];
        [LGAudioPlayer sharePlayer].delegate = self;
        
    } failed:^(id x){
        
    }];
}

#pragma mark - 播放夜生活视频
- (IBAction)livePlay:(id)sender
{
    if (self.userModel.videoUrl)
    {
        AuthVideoViewController *authVideoVC = [AuthVideoViewController initSBWithSBName:@"AuthVideoSB"];
        authVideoVC.coverURL = self.userModel.coverUrl;
        authVideoVC.videoURL = self.userModel.videoUrl;
        [self.navigationController pushViewController:authVideoVC animated:YES];
    }
}

- (void)uploadVideToServer:(NSURL *)videoURL withVideo:(NSString *)typeString
{
    // 发布拍拍部分需要优化
    PaiPaiPostVideoViewModel *viewModel = [[PaiPaiPostVideoViewModel alloc] init];
    viewModel.videoUrl = videoURL;
    PostVideoPlayerController *vc = [PostVideoPlayerController controllerWithViewModel:viewModel andSbName:@"CLPostVideoSB"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - LGAudioPlay Delegate音频播放动画
- (void)audioPlayerStateDidChanged:(LGAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index
{
    switch (audioPlayerState) {
        case LGAudioPlayerStateNormal:{
        }break;
        case LGAudioPlayerStatePlaying:
        {
            NSArray *animationImage = @[KGetImage(@"play1"),KGetImage(@"play2"),KGetImage(@"play3"),KGetImage(@"play4")];
            // 启动动画
            [_heatVovicePlayBtn.imageView setAnimationImages:animationImage];
            [_heatVovicePlayBtn.imageView setAnimationRepeatCount:0];
            [_heatVovicePlayBtn.imageView setAnimationDuration:1.5];
            [_heatVovicePlayBtn.imageView startAnimating];
        }break;
            
        case LGAudioPlayerStateCancel:{
            [_heatVovicePlayBtn.imageView stopAnimating];
            [_heatVovicePlayBtn.imageView setImage:KGetImage(@"icon_voice")];
        };
    }
}

#pragma mark - 送礼物
- (void)sendGift
{
    GiftTool *tool = [GiftTool defaultGiftTool];
    tool.receiverID = self.userModel.userId;
    tool.giftType = 8;
    tool.projectID = 0;
    [tool showGiftView];
    
    _funcView.hidden = YES;
    
    tool.closeBlock = ^(id param) {
        _funcView.hidden = NO;
    };
}

#pragma mark - 聊天
- (void)chatClick
{
    NIMSession *session = [NIMSession session:self.userModel.phone_num type:NIMSessionTypeP2P];
    NIMSessionViewController *chatVC = [[NIMSessionViewController alloc] initWithSession:session];
    PushViewController(chatVC);
}

#pragma mark - 关注或者取消
- (void)followClic
{
    if (self.userModel.follow){
        // 已经关注,取消
        NSString *msg =  @"确定要取消关注该用户";
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:msg action:@[@"关闭",@"确定"] calk:^(id param) {
            NSInteger selectIndex = [param integerValue];
            
            if (selectIndex == 1){
                [self followUserOrCancel];
            }
        }];
        
        PresentViewController(ac);
        
    }
    else{
        [self followUserOrCancel];
    }
}
- (void)followUserOrCancel
{
    AddGZRequest *r = [AddGZRequest new];
    r.model = self.userModel.userId;
    [r startRequestWithCompleted:^(ResponseState *state) {
        if (state.isSuccess){
            self.userModel.follow = !self.userModel.follow;
            [self reloadUserDataInMain];
        }
        else{
            ShowError(@"关注失败");
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
