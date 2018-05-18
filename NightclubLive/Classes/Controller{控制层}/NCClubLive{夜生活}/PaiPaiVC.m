//
//  PaiPaiVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/3.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "PaiPaiVC.h"
#import "Photo.h"
#import "PaPaDetailVC.h"
#import "PaiPaiViewModel.h"
#import "PaiPaiModel.h"
#import "PaiPaiHomeCell.h"
#import "UIViewController+Category.h"
#import "JhtFloatingBall.h"
#import "UpLoadVideoVC.h"
#import "VideoVC.h"
#import "ConvertTool.h"
#import "PostVideoPlayerController.h"
#import "PaiPaiDetailsViewModel.h"
#import "PaiPaiPostVideoViewModel.h"
#import "VideoTool.h"
#import "EmptyBigView.h"

#import "PaiPaiUpload.h"
#import "UILabel+NavTitleView.h"
#import "BlocksKit+UIKit.h"
static NSString *PaiPaiHomeCellID = @"PaiPaiHomeCellID";
NSTimeInterval const PaiPaiVideoLength = 30;

@interface PaiPaiVC ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIImagePickerControllerDelegate
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) PaiPaiViewModel *viewModel;
@property (nonatomic, strong) JhtFloatingBall *paipaiImageView;
@property (nonatomic, strong) PaiPaiUpload  *paipaiUpload;
@property (nonatomic, strong) UILabel *titleLable;
@property(nonatomic,strong)UIView *emptyView;

@end

@implementation PaiPaiVC

@dynamic viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(self.tag == 0)
    {
        [self.view addSubview:self.paipaiImageView];
    }
    
    NSString *nameStr = self.tag == 0 ? @"夜生活" : @"全部视频";
    self.navigationItem.titleView = [UILabel navWithTitle:nameStr];
    
    [self setupCollectionView];
    
    [self setupViewDidload];

    // 添加完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:NOTIFICATION_SLPAIPAILIST object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    if (self.viewModel.datas.count == 0 )
    {
        if (!_emptyView)
        {
            UIView *v = [EmptyBigView viewWithTip:self.tag == 0 ? @"暂时没有视频" : @"没有发布视频"];
            v.frame = [NCEmpty getEmtpyViewRectWithScrollView:self.collectionView];
            [self.view addSubview:v];
            _emptyView = v;
        }
        
    }else{
        if (_emptyView){
            [_emptyView removeFromSuperview];
        }
        
    }
    return self.viewModel.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PaiPaiHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PaiPaiHomeCellID forIndexPath:indexPath];
    
    PaiPaiModel *model = self.viewModel.datas[indexPath.row];
    [cell bindModel:model];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (self.view.width - 10) * 0.5;
    
    return CGSizeMake(width,width + 30);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PaiPaiModel *model = self.viewModel.datas[indexPath.row];
    
    PaPaDetailVC *vc = [PaPaDetailVC controllerWithViewModel:nil andSbName:@"PapaDetailSB"];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)uploadVideToServer:(NSURL *)videoURL withVideo:(NSString *)typeString withType:(NSInteger)type
{
    PaiPaiPostVideoViewModel *viewModel = [[PaiPaiPostVideoViewModel alloc] init];
    viewModel.videoUrl = videoURL;
    
    PostVideoPlayerController *vc = [PostVideoPlayerController controllerWithViewModel:viewModel andSbName:@"CLPostVideoSB"];
    vc.sourceType = type;
    
//    PresentViewController(vc);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setupViewDidload
{
    @weakify(self);
    
    self.viewModel = [[PaiPaiViewModel alloc] init];
    self.viewModel.tag = self.tag;
    self.viewModel.userid = self.model;
    [self.viewModel.getPaipaiListCommand.executionSignals.switchToLatest subscribeNext:^(ResponseState *state) {
        @strongify(self);
        [self.collectionView endRefresh];
        [self.collectionView reloadData];
        
        if (state.datas.count == 0){
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }];
    
    // 视频类型回调{录制视频上传或者本地视频上传}
    self.viewModel.callback = ^(NSNumber *type){
        @strongify(self);
        NSInteger t = [type integerValue];
        
        self.paipaiUpload = [[PaiPaiUpload alloc] init];
        self.paipaiUpload.completionBlock = ^(NSURL *url)
        {
            @strongify(self);
            // 跳转进入完善视频信息控制器{上传视频}
            [self uploadVideToServer:url withVideo:@"MP4" withType:0];
        };
        
        [self.paipaiUpload selectVideoSourceWithType:t sourceVC:self];
    };
    
    
    [self.viewModel.uploadVideCommand.executing subscribeNext:^(id x) {
        
        if ([x boolValue]){
            ShowLoading;
        }
        else{
            CloseLoading;
        }
    }];
}

- (void )setupCollectionView
{

    _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.refresh_view = _collectionView;
    self.haveRefreshHead =  YES;
    self.haveRefreshFoot =  YES;
    
    [self.collectionView.mj_header beginRefreshing];
    
    // 添加视图
    [_collectionView registerClass:[PaiPaiHomeCell class] forCellWithReuseIdentifier:PaiPaiHomeCellID];
}

#pragma mark - 实现父类请求的方法
- (void)requestDataFromServer
{
    self.viewModel.refreshType = self.refreshType;
    self.viewModel.pageNow     = self.currentPage;

    [self.viewModel.getPaipaiListCommand execute:nil];
}

#pragma mark - Private Method
- (void)reload
{
    [self.collectionView.mj_header beginRefreshing];
}

- (JhtFloatingBall *)paipaiImageView
{
    if (!_paipaiImageView)
    {
        _paipaiImageView = [[JhtFloatingBall alloc] init];
        
        _paipaiImageView.image = KGetImage(@"我要拍拍按钮2");
        CGFloat width = SCREEN_WIDTH * 0.25;
        CGFloat height = width * (120 / 342.0);
        
        CGRect rect = CGRectZero;
        if (iPhoneX) {
            rect = CGRectMake(SCREEN_WIDTH - width - 10,SCREEN_HEIGHT - height -  85 -88-34, width, height);
        }else{
            rect = CGRectMake(SCREEN_WIDTH - width - 10, SCREEN_HEIGHT - height - 130, width, height);
        }
        
        _paipaiImageView.frame = rect;
        _paipaiImageView.stayMode = stayMode_OnlyLeftAndRight;
        
        @weakify(self);
        [_paipaiImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            @strongify(self);
            // 弹出我要拍拍
            UpLoadVideoVC *uploadVC = [UpLoadVideoVC controllerWithViewModel:self.viewModel andSbName:@"CLPaiPaiSB"];
            
            [self presentViewController:uploadVC animated:YES completion:nil];
            
        }]];
    }
    return _paipaiImageView;
}

@end
