//
//  PaPaDetailTVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/8.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "PaPaDetailTVC.h"
#import "ZFVideoResolution.h"
#import <Masonry/Masonry.h>
#import "ZFPlayer.h"
#import "PaPaDetailCell.h"
#import "PaiPaiDetailsViewModel.h"


#import "Comment.h"
#import "GPraiseRequest.h"
#import "CommentRequest.h"
#import "PaPaDetailVC.h"

#import "UserInfoViewController.h"
#import "GiftTool.h"
#import "UserTagView.h"
#import "EmptyMiniView.h"
#import "MineRequest.h"
#import "GlobalRequest.h"

#import "UIAlertController+Factory.h"

static NSString * const PaPaDetailCellID = @"PaPaDetailCell";

@interface PaPaDetailTVC ()<ZFPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *yueBtn; // 约台
@property (weak, nonatomic) IBOutlet UIImageView *coverImageV;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UILabel *nickLable;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UserTagView *userTagView;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIView *fatherView;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;

@property (nonatomic, strong) PaiPaiDetailsViewModel *viewModel;
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) NSMutableArray *cellHeights; /** 高度数组 */

@property (weak, nonatomic) IBOutlet UIButton *followBtn;
 @property(nonatomic,strong)UIView *emptyView;

@end

@implementation PaPaDetailTVC

@dynamic viewModel;

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self loadDataToView];
    [self setupTableView];
    [self setupCommentList];
    [self listenLikeRequest];
    
    [_coverImageV autoAdjustWidth];
    _userTagView.contentAlignType = 1;
    _userTagView.model = self.model;
    _yueBtn.hidden =  !(self.model.user.isbound_bar && ![self.model.user.ID isEqualToString:CurrentUser.user.userId]);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.playerView resetPlayer];
}

- (void)setupTableView
{
    self.refresh_tableView = self.tableView;
    self.haveRefreshHead = YES;
    self.haveRefreshFoot = YES;
    MJRefreshNormalHeader *head = (MJRefreshNormalHeader *)self.tableView.mj_header;
    head.stateLabel.hidden = YES;
    _headView.height = 100 + 50 + self.view.width * (2 / 3.0);
    [self.tableView setTableHeaderView:_headView];
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    
    if (self.viewModel.datas.count == 0 )
    {
        if (!_emptyView)
        {
            UIView *v = [EmptyMiniView viewWithTip:@"暂无评论哦~"];
            v.frame = [NCEmpty getEmtpyViewRectWithScrollView:self.tableView];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentObject *comment = self.viewModel.datas[indexPath.row];
    return comment.cellHeight;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentObject *comment = self.viewModel.datas[indexPath.row];
    PaPaDetailCell *cell = (PaPaDetailCell *)[tableView dequeueReusableCellWithIdentifier:PaPaDetailCellID];
    
    @weakify(self);
    kWeakSelf(cell);
    
    // 回复
    cell.replyBlock = ^(id value){
        @strongify(self);
        if(self.superVC.commentUserBlock)
        {
            self.superVC.commentUserBlock(value);
        }
    };
    
    cell.praiseBlock = ^(NSIndexPath *praiseIndexPath)
    {
        // 点赞
        @strongify(self);
        [self likeRequest:praiseIndexPath];
    };
    
    cell.deleteBlock = ^(NSIndexPath *vIndexPath)
    {
        @strongify(self);
        vIndexPath = [self.tableView indexPathForCell:weakcell];
        [self deleteRequest:vIndexPath riIndexPath:indexPath];
    };
    
    
    cell.model = comment;
    cell.indexPath = indexPath;
    return cell;
}

#pragma mrk- 
- (void)setupCommentList
{
    @weakify(self);
    [self.viewModel.getCommentListCommand.executionSignals.switchToLatest subscribeNext:^(ResponseState *state)
    {
        @strongify(self);
        // 用来订阅信号coderiding
        if (state.isSuccess)
        {
            [self.tableView endRefresh];
            [self.tableView reloadInMain];
        }
    }];
}

- (void)loadDataToView
{
    self.yueBtn.layer.borderColor = [UIColor colorWithHexString:@"B01480"].CGColor;
    self.yueBtn.layer.borderWidth =  1;
    [_coverImageV sd_setImageWithURL:URL(_model.coverUrl) placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    [_iconImageV sd_setImageWithURL:_model.user.profilePhoto placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    _nickLable.text = _model.user.userName;
    _remarkLabel.text = _model.content;
    NSDateFormatter *dft = [[NSDateFormatter alloc] init];
    [dft setDateFormat:@"yyyy-MM-dd"];
    _timeLabel.text = _model.timeGap;
    _cityLabel.text = _model.city;
    [_praiseBtn setImage:_model.ispraise == 1 ? [UIImage praiseImage] : [UIImage nopraiseImage] forState:UIControlStateNormal];
    
    [_praiseBtn setTitle:[NSString stringWithFormat:@"点赞(%ld)",_model.praiseCount] forState:UIControlStateNormal];
    [_praiseBtn setTitleColor:_model.ispraise == 1 ? [UIColor praiseColor] : [UIColor nopraiseColor] forState:UIControlStateNormal];
    
    [_commentBtn setTitle:[NSString stringWithFormat:@"评价(%ld)",(long)_model.dynamicCount] forState:UIControlStateNormal];
}

#pragma mark - 底部Cell删除
- (void)deleteRequest:(NSIndexPath *)vIndexPath riIndexPath:(NSIndexPath *)riIndexPath
{
#warning 后台配置，删除后台无参数返回
    @weakify(self);
    UIAlertController *ac = [UIAlertController alertCancelAndOKWithTitle:@"删除提示" message:@"确定要删除评论?" okCalk:^(id param)
    {
             CommentObject *m = self.viewModel.datas[riIndexPath.row];
             DeleteCommentRequest *r = [DeleteCommentRequest new];
             r.model = m.ID;
             r.subectId = self.model.ID;
             r.type = 4;
             [r startRequestWithCompleted:^(ResponseState *state) {
                 @strongify(self);
                 if (state.isSuccess)
                 {
                     // 更新cell
                     [self.viewModel removeObjectAtIndex:vIndexPath.row];
                     [self.tableView deleteRowsInMainAtIndexPaths:@[vIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                     // 更新评论数量与界面
                     self.viewModel.model.dynamicCount -= 1;
                     [self loadDataToView];
                     
                 }
                 else{
                     ShowError(@"删除失败");
                 }
             }];
                                 
     }];
    
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - 底部Cell点赞
- (void)likeRequest:(NSIndexPath *)praiseIndexPath
{
    @weakify(self);
    CommentObject *m = self.viewModel.datas[praiseIndexPath.row];
    GPraiseRequest *r = [GPraiseRequest new];
    r.subjectId = m.ID;
    r.type = 2;
    r.subjectTypeId = 4;
    r.praiseType = m.ispraise == 1 ? 1 : 0;
    
    [r startWithCompletedBlock:^(GJBaseRequest *request) {
        @strongify(self);
        ResponseState *state = [ResponseState objectWithDic:request.responseObject];
        
        if (state.isSuccess){
            
            if (m.ispraise == 1){
                m.ispraise = 0;
                m.praise -= 1;
            }
            else{
                m.ispraise = 1;
                m.praise += 1;
            }
            
            [self.tableView reloadRowsAtIndexPaths:@[praiseIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)requestDataFromServer
{
    self.viewModel.pageNow = self.currentPage;
    self.viewModel.refreshType = self.refreshType;
    
    // 用来执行信号codering
    [self.viewModel.getCommentListCommand execute:nil];
}

- (void)reloadData
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)getDataButNoRefresh
{
    [self requestDataFromServer];
}

- (void)reloadDataToView
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self loadDataToView];
    });
}

#pragma mark - topCell点赞
- (IBAction)praiseClick:(id)sender
{
    self.viewModel.type = 1;
    self.viewModel.subjectTypeId = 4;
    self.viewModel.subjectId = self.viewModel.model.ID;
    self.viewModel.praiseType = self.viewModel.model.ispraise == 1 ? 1 : 0;
    [self.viewModel.praiseCommand execute:nil];
}

#pragma mark - 点赞监听
- (void)listenLikeRequest
{
    @weakify(self);
    [self.viewModel.praiseCommand.executionSignals.switchToLatest subscribeNext:^(ResponseState *state) {
        @strongify(self);
        if (state.isSuccess)
        {
            if (self.viewModel.model.ispraise == 0){
                self.viewModel.model.ispraise = 1;
                self.viewModel.model.praiseCount += 1;
            }
            else{
                self.viewModel.model.ispraise = 0;
                self.viewModel.model.praiseCount -= 1;
            }
            
            [self loadDataToView];
        }
    }];
}

#pragma mark - 点击用户头像
- (IBAction)logoClick:(id)sender
{
    UserInfoViewController *userInfoVC = [UserInfoViewController initSBWithSBName:@"UserInfoSB"];
    User *user = [User new];
    user.userId = self.model.userId;
    userInfoVC.userModel = user;
    PushViewController(userInfoVC);
}

#pragma mark - 送礼物
- (IBAction)sendGiftClick:(id)sender
{
    PaiPaiModel *m = self.model;
    GiftTool *tool = [GiftTool defaultGiftTool];
    tool.receiverID = m.user.ID;
    tool.giftType = 4;
    tool.projectID = m.ID;
    [tool showGiftView];
}

#pragma mark - 约台
- (IBAction)appointClick:(id)sender
{
    PaiPaiModel *m = self.model;
    ObjectTableViewController *vc = ViewController(@"AppointmentSB", @"AppointmentViewController");
    vc.model = m.user.ID;
    PushViewController(vc);
}

#pragma mark - 点击播放
- (IBAction)playAction:(id)sender
{
    // 取出字典中的第一视频URL
    NSURL *videoURL = [NSURL URLWithString:_model.videoUrl];
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
    playerModel.title            = _model.content;
    playerModel.videoURL         = videoURL;
    playerModel.placeholderImage = KGetImage(@"icon_blackboard");
    // player的父视图
    playerModel.fatherView       = self.fatherView;
    playerModel.scrollView = self.tableView;
    // 设置播放控制层和model
    [self.playerView playerControlView:nil playerModel:playerModel];
    // 自动播放
    [self.playerView autoPlayTheVideo];
}

- (ZFPlayerView *)playerView
{
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView
{
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}

@end
