//
//  ClubCircleDynamicDetailVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/2.
//  Copyright © 2016年 WanBo. All rights reserved.
//  动态详情

#import "ClubCircleDynamicDetailVC.h"
#import "ClubCircleDynamicDetailCell.h"
#import "XLPhotoBrowser.h"
#import "SDImageCache.h"
#import "ClubCircleDynamicDetailViewModel.h"


#import "GPraiseRequest.h"


#import "CommentRequest.h"
#import "ClubCircleRequest.h"
#import "ReportRequest.h"
#import "ShareView.h"
#import "UserInfoViewController.h"
#import "UserTagView.h"
#import "LimitInput.h"
#import "AppointmentViewController.h"
#import "EmptyMiniView.h"
#import "ReportViewController.h"
#import "DownloadAudioService.h"
#import "LGAudioPlayer.h"

#import "SDCycleScrollView.h"
#import "GlobalRequest.h"
#import "UITextField+Utilities.h"
#import "OpenShareHeader.h"
#import "UIAlertController+Factory.h"
#import "BlocksKit+UIKit.h"
#import "GiftTool.h"
#import "NCAlert.h"
#import <MMPopupView/MMPopupView.h>
#import "NCFriendShareView.h"
@interface ClubCircleDynamicDetailSuperVC ()
<
UIActionSheetDelegate
>
{
    NSString *touserID;
    NSInteger replayType;
}

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (strong, nonatomic)  UIButton *dismissView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property (nonatomic, strong) DynamicCommentListModel *toUserModel;
@property (nonatomic, strong) ClubCircleDynamicDetailViewModel *viewModel;
@property (nonatomic, weak) DynamicListModel *model;
@property (nonatomic, weak) ClubCircleDynamicDetailVC *childVC;

@end

@implementation ClubCircleDynamicDetailSuperVC
@dynamic viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupChildVC];
    
    [self setupCommentSendBtn];
    
    [self setupNavRightBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didClickKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didKboardDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [KNotificationCenter removeObserver:self];
}

- (void)setupChildVC
{
    ClubCircleDynamicDetailVC *vc = [ClubCircleDynamicDetailVC initSBWithSBName:@"CCDynamicDetailSB"];
    vc.model = self.model;
    self.childVC = vc;
    vc.view.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    [self.contentView insertSubview:vc.view atIndex:0];
    
    [_tf setValue:@80 forKey:@"limit"];
    [self.tf setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self addChildViewController:vc];
    
    
    vc.themCommentCallback = ^(id x)
    {
        touserID = @"";
        _tf.placeholder = @"输入评论内容";
        [_tf becomeFirstResponder];
    };
    
    vc.replayCallback= ^(DynamicCommentListModel *model)
    {
        touserID = model.userId;
        replayType = 1;
        _tf.placeholder = [NSString stringWithFormat:@"回复%@",model.from_user_name];
        [_tf becomeFirstResponder];
    };
}

#pragma mark - 创建发送回复按钮
- (void)setupCommentSendBtn
{
    @weakify(self);
    // 点击发送回复
    [_commentBtn bk_addEventHandler:^(id sender)
    {
        @strongify(self);
        if (_tf.text.length <= 0){
            [self.view makeToast:@"说点什么吧~" duration:1.0 position:CSToastPositionCenter];
        }
        else if (  _tf.text.length > 80){
            [self.view makeToast:@"评论最多只能80个字" duration:1.0 position:CSToastPositionCenter];
        }
        else{
            
            if (!touserID){
                touserID = self.model.user.ID;
            }
            
            [self setupCommentRequest];
            
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 发送回复请求
- (void)setupCommentRequest
{
    @weakify(self);
    DynamicListModel *m = self.model;
    
    CommentRequest *r = [CommentRequest new];
    r.subjectTypeId = 1;
    r.typeId = 1;
    r.subjectId = m.ID;
    r.content = self.tf.text;
    r.toUser = touserID;
    r.reply_type = replayType;
    [r startRequestWithCompleted:^(ResponseState *state)
     {
        @strongify(self);
         
        [self.view endEditing:YES];
         
        self.tf.placeholder = @"输入评论内容";
        self.tf.text = nil;
        if (state.isSuccess)
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                [self.view makeToast:@"评论成功~" duration:1.0 position:CSToastPositionCenter];
            });
            
            self.model.criticismCount = [NSString stringWithFormat:@"%ld",[self.model.criticismCount integerValue] + 1];
            
            [self.childVC reloadTopcellData];
            [self.childVC requestDataNotRefresh];
        }
        else{
            ShowError(state.message);
        }
        
        touserID = nil;
        replayType = 0;
        
    }];
}

#pragma mark - 创建导航栏右键按钮
- (void)setupNavRightBtn
{
    @weakify(self);
    [_moreBtn bk_whenTapped:^
    {
        @strongify(self);
        // 根据用户呈现对应的内容
        if ([self.model.user.ID isEqualToString:[UserInfo shareUser].userID])
        {
            [self setupDeteleConent];
        }else{
            [self setupShare];
        }
    }];
}

#pragma mark - 举报或者共享
- (void)setupShare
{
    @weakify(self);
    [NCAlert showActionSheetWithDataSource:@[@"立即举报",@"分享"] blockHandel:^(NSInteger index) {
        if (index == 0)
        {
            [NCAlert showActionSheetWithDataSource:SelectDataForKey(@"Report") blockHandel:^(NSInteger index) {
                // 举报
                DynamicListModel *m = self.model;
                ReportViewController *reportVC = [ReportViewController initSBWithSBName:@"ReportSB"];
                reportVC.subjectTypeId = 5;
                reportVC.subjectId = m.ID;
                reportVC.reportType = index + 1;
                PushViewController(reportVC);
            }];
            
        }
        else if(index == 1){
            @strongify(self);
            // 分享
            [self shareDynamic];
            
        }
    }];

}

- (void)setupDeteleConent
{
    @weakify(self);
    // 删除
    [NCAlert showActionSheetWithDataSource:@[@"删除"] blockHandel:^(NSInteger index) {
        @strongify(self);
        if (index == 0)
        {
            DeleteDynamicRequest *deleteR = [DeleteDynamicRequest new];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if (self.model.ID.length >0) {
                [params setValue:self.model.ID forKey:@"id"];
            }
            if (self.model.userId.length > 0) {
                [params setValue:self.model.userId forKey:@"userId"];
            }
            deleteR.param = params;
            
            //deleteR.param = @{@"id":weakself.model.ID,@"userId":weakself.model.userId};
            [deleteR startRequestWithCompleted:^(ResponseState *state) {
                @strongify(self);
                if (state.isSuccess)
                {
                    ShowSuccess(@"删除成功");
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    if (_deleteBlock){
                        _deleteBlock(@{@"IndexPath":self.indexPath,@"model":self.model});
                    }
                }
                else{
                    ShowError(@"删除失败");
                }
            }];
        }
    }];

}

/**
 *  点击了按钮，点击灰色区域也会调用，相当于点击了取消按钮
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (buttonIndex==1)
    {
        // 举报
        self.viewModel.subjectID = self.viewModel.model.ID;
        
        [self.viewModel.reportReuqesCommand execute:nil];
    }
}

#pragma mark -键盘即将跳出
-(void)didClickKeyboard:(NSNotification *)sender
{
    CGFloat durition = [sender.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    CGRect keyboardRect = [sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    [UIView animateWithDuration:durition animations:^{
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
    }];
}

#pragma mark - 当键盘即将消失
-(void)didKboardDisappear:(NSNotification *)sender
{
    CGFloat duration = [sender.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.bottomView.transform = CGAffineTransformIdentity;
    }];
}

- (void)shareDynamic
{
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
        NSLog(@"animation complete");
    };
    NCFriendShareView *view = [[NCFriendShareView alloc]init];
    
    [view showWithBlock:completeBlock];
    

    @weakify(self);
    // 分享到朋友圈
    [view.shareView.pyqBtn bk_whenTapped:^{
        @strongify(self);
        [self pyqClick];
    }];
    
    // 发给微信好友
    [view.shareView.weiXinBtn bk_whenTapped:^{
        @strongify(self);
        [self wxFriendClick];
    }];
    
    // 发给QQ好友
    [view.shareView.qqBtn bk_whenTapped:^{
        @strongify(self);
        [self qqFriend];
    }];
    
    // 分享到微博
    [view.shareView.weiBoBtn bk_whenTapped:^{
        @strongify(self);
         [self sinaWBClick];
    }];
    
//    ShareView *view = [ShareView shareView];
//
//    [view setUP];
//
//    // 分享到朋友圈
//    [[view.pyqBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//          [self pyqClick];
//    }];
//
//    // 发给微信好友
//    [[view.weiXinBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//           [self wxFriendClick];
//
//    }];
//
//    // 发给QQ好友
//    [[view.qqBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//         [self qqFriend];
//
//    }];
//    // 分享到微博
//    [[view.weiBoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//          [self sinaWBClick];
//
//    }];
//
//
//    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 105);
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [window addSubview:view];
//
//    [UIView animateWithDuration:0.5 animations:^{
//        view.frame=CGRectMake(0, SCREEN_HEIGHT-105, SCREEN_WIDTH, 105);
//    }];
    
}

#warning 还没有做，所以下面的信息是假的，安卓也没有做
#pragma mark - 配置分享信息
- (OSMessage *)shareMessage
{
    OSMessage *message = [[OSMessage alloc] init];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日HH时mm分ss秒";
    NSString *now = [fmt stringFromDate:[NSDate date]];
    message.title = [NSString stringWithFormat:@"大鸟的分享，分享时间%@",now];
    message.image = [UIImage imageNamed:@"icon"];
    // 缩略图
    message.thumbnail = [UIImage imageNamed:@"psd"];
    message.desc = [NSString stringWithFormat:@"大鸟的分享，分享时间%@",now];
    message.link=@"http://www.jianshu.com/users/e944bed06906/latest_articles";
    return message;
}

#pragma mark - 分享到朋友圈
- (void)pyqClick
{
    OSMessage *message = [self shareMessage];
    [OpenShare shareToWeixinTimeline:message Success:^(OSMessage *message) {
        NSLog(@"微信分享到朋友圈成功：\n%@",message);
    } Fail:^(OSMessage *message, NSError *error) {
        NSLog(@"微信分享到朋友圈失败：\n%@\n%@",error,message);
    }];
    
}
#pragma mark - 分享到微博
- (void)sinaWBClick
{
    OSMessage *message = [self shareMessage];
    [OpenShare shareToWeibo:message Success:^(OSMessage *message) {
        NSLog(@"分享到sina微博成功:\%@",message);
    } Fail:^(OSMessage *message, NSError *error) {
        NSLog(@"分享到sina微博失败:\%@\n%@",message,error);
    }];
}

#pragma mark - 分享给QQ好友
- (void)qqFriend
{
    OSMessage *message = [self shareMessage];
    [OpenShare shareToQQFriends:message Success:^(OSMessage *message) {
        NSLog(@"分享到QQ好友成功:%@",message);
    } Fail:^(OSMessage *message, NSError *error) {
        NSLog(@"分享到QQ好友失败:%@\n%@",message,error);
    }];
}

#pragma mark - 分享给微信好友
- (void)wxFriendClick
{
    OSMessage *message = [self shareMessage];
    
    [OpenShare shareToWeixinSession:message Success:^(OSMessage *message) {
        NSLog(@"微信分享到会话成功：\n%@",message);
    } Fail:^(OSMessage *message, NSError *error) {
        NSLog(@"微信分享到会话失败：\n%@\n%@",error,message);
    }];
}

@end





















@interface ClubCircleDynamicDetailVC ()
<
XLPhotoBrowserDelegate,
XLPhotoBrowserDatasource
>

@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *criticismLable;
@property (weak, nonatomic) IBOutlet UILabel *voiceLenLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *yueTaiBtn;
@property (weak, nonatomic) IBOutlet UILabel *imageCountLable;
@property (weak, nonatomic) IBOutlet UserTagView *userTagView;
@property (weak, nonatomic) IBOutlet UIView *voiceView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *dynamicBannerView;

/** 空列表 */
@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, strong) ClubCircleDynamicDetailViewModel *viewModel;
@property (nonatomic , strong) NSMutableArray  *images;

@end

@implementation ClubCircleDynamicDetailVC

@dynamic viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
    [self likeTopCellRequest];
    [self reloadTopcellData];
    
    _userTagView.contentAlignType = 1;
    _userTagView.model = self.model;
}

- (void)setupTableView
{
    CGFloat curWidth = kScreenWidth-14*2;
    CGFloat curHeight = [_contentLable.text getHeightWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(curWidth, CGFLOAT_MAX)]+66+15+22+7+27+ SCREEN_WIDTH * (250/375.0);
    UIView *headView = self.tableView.tableHeaderView;
    headView.height = curHeight;
    self.tableView.tableHeaderView = headView;
    
    self.refreshView = self.tableView;
    self.isFoot = YES;
    self.isHead = YES;
    MJRefreshNormalHeader *head = (MJRefreshNormalHeader *)self.tableView.mj_header;
    head.stateLabel.hidden = YES;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
}

- (void)refreshMethod
{
    DynamicListModel *m = self.model;
    CommentarygetListRequest *r = [CommentarygetListRequest new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.pageNow) {
        [params setValue:@(self.pageNow) forKey:@"pageNow"];
    }
    if (m.ID.length > 0) {
        [params setValue:m.ID forKey:@"subjectId"];
    }
    if ([UserInfo shareUser].userID.length > 0) {
        [params setValue:[UserInfo shareUser].userID forKey:@"userId"];
    }
    
    [params setValue:@1 forKey:@"typeId"];
    r.param = params;
    //r.param = @{@"pageNow":@(self.pageNow),@"typeId":@1,@"subjectId":m.ID,@"userId":[UserInfo shareUser].userID};
    
    @weakify(self);
    [r startRequestWithCompleted:^(ResponseState *state)
    {
        @strongify(self);
        if (state.isSuccess)
        {
            self.parses = [DynamicCommentListModel arrayObjectWithDS:state.data];
        }
        else{
            [self.tableView endRefresh];
            ShowError(state.message);
        }
        
    }];
}

- (void)loadDataFromServer
{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 重新刷新数据
- (void)requestDataNotRefresh
{
    self.pageNow = 1;
    self.refreshType = RefreshTypeLoad;
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    [self refreshMethod];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.dataSource.count;
    
    if (count == 0 )
    {
        if (!_emptyView)
        {
            DynamicListModel *m = self.model;;
            
            UIView *v = [EmptyMiniView viewWithTip:@"暂无评论哦~"];
            CGFloat width = 150;
            CGFloat height = 50;
            CGFloat x = (SCREEN_WIDTH - width) * 0.5;
            CGFloat y = tableView.tableHeaderView.height + 24;
            
            if (m.voicelen && m.content.length == 0){
                y += 20;
            }
            
            v.frame = CGRectMake(x, y, width, height);
            [self.view addSubview:v];
            _emptyView = v;
        }
        
    }else{
        if (_emptyView)
            [_emptyView removeFromSuperview];
        
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCommentListModel *m = self.dataSource[indexPath.row];
    static NSString *cellIdentifier = @"ClubCircleDynamicDetailCellID";
    ClubCircleDynamicDetailCell *cell = (ClubCircleDynamicDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    cell.indexPath = indexPath;
    cell.model = m;
    
    @weakify(self);
    cell.replayCallback = ^(DynamicCommentListModel *x)
    {
        @strongify(self);
        // 回复
        if (_replayCallback) {
            self.replayCallback(x);
        }
    };
    
    [cell.huifuBtn bk_whenTapped:^
     {
         @strongify(self);
         self.replayCallback(m);
     }];
    
    cell.praiseBlock = ^(DynamicCommentListModel *value)
    {
        @strongify(self);
        // 点赞
        [self likeTabelCellRequest:value indexPath:indexPath];
    };

    cell.logoBlock = ^(NSIndexPath *vIndexPath)
    {
        // 头像点击
        [self goUserInfoVC:vIndexPath];
    };
    
    cell.deleteBlock = ^(NSIndexPath *vIndexPath)
    {
        // 删除
        @strongify(self);
        [self delteTableCellRequest:vIndexPath];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCommentListModel *m = self.dataSource[indexPath.row];
    return m.cellHeight;
}

- (void)delteTableCellRequest:(NSIndexPath *)vIndexPath
{
    @weakify(self);
    // 询问是否删除
    UIAlertController *ac = [UIAlertController alertCancelAndOKWithTitle:@"删除提示" message:@"确定要删除评论?" okCalk:^(id param)
                             {
                                 //  vIndexPath = [weakself.tableView indexPathForCell:weakcell];
                                 
                                 //更新cell
                                 DynamicCommentListModel *m = self.dataSource[vIndexPath.row];
                                 DeleteCommentRequest *r = [DeleteCommentRequest new];
                                 r.model = m.ID;
                                 DynamicListModel *model = (DynamicListModel *)self.model;
                                 r.subectId = model.ID;
                                 r.type = 1;
                                 [r startRequestWithCompleted:^(ResponseState *state) {
                                     @strongify(self);
                                     if (state.isSuccess){
                                         //                //更新cell
                                         [self.dataSource removeObjectAtIndex:vIndexPath.row];
                                         
                                         // 更新评论数量与界面
                                         DynamicListModel *model = (DynamicListModel *)self.model;
                                         model.criticismCount = [NSString stringWithFormat:@"%ld",[model.criticismCount integerValue] - 1];
                                         self.model = model;
                                         
                                         [self reloadTopcellData];
                                         [self.tableView reloadInMain];
                                         
                                     }
                                     else{
                                         ShowError(@"删除失败");
                                     }
                                 }];
                                 
                             }];
    
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - 点击tablecell中的赞
- (void)likeTabelCellRequest:(DynamicCommentListModel *)value indexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    GPraiseRequest *r = [GPraiseRequest new];
    r.subjectTypeId = 1;
    r.subjectId = value.ID;
    r.type = 2;
    r.praiseType = (PraiseType)value.ispraise;
    [r startRequestWithCompleted:^(ResponseState *state)
     {
        @strongify(self);
        if (state.isSuccess){
            value.ispraise = value.ispraise == 1 ? 0 : 1;
            value.praise += (value.ispraise == 1 ? 1 : -1);
            
            //刷新对应的cell
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

#pragma mark - 跳转用户资料
- (void)goUserInfoVC:(NSIndexPath *)vIndexPath
{
    UserInfoViewController *infoVC = ViewController(@"UserInfoSB", @"UserInfoViewController");
    
    DynamicCommentListModel *m = self.dataSource[vIndexPath.row];
    User *user = [User new];
    user.userId = m.userId;
    infoVC.userModel = user;
    
    PushViewController(infoVC);
}

#pragma mark - 点击topcell的头像
- (IBAction)userInfoClick:(id)sender
{
    UserInfoViewController *infoVC = ViewController(@"UserInfoSB", @"UserInfoViewController");
    
    DynamicListModel *m = self.model;
    User *user = [User new];
    user.userId = m.userId;
    infoVC.userModel = user;
    
    PushViewController(infoVC);
}

#pragma mark - 点击topcell的评论
- (IBAction)themCommentAction:(id)sender
{
    if (_themCommentCallback)
    {
        _themCommentCallback(nil);
    }
}

#pragma mark - 点击topcell的送礼物
- (IBAction)sendGiftClick:(id)sender
{
    DynamicListModel *m = self.model;
    GiftTool *tool = [GiftTool defaultGiftTool];
    tool.receiverID = m.user.ID;
    tool.giftType = 1;
    tool.projectID = m.ID;
    [tool showGiftView];
}

#pragma mark - 点击topcell的约台
- (IBAction)appointmentClick:(id)sender
{
    DynamicListModel *m = self.model;;
    ObjectTableViewController *vc = ViewController(@"AppointmentSB", @"AppointmentViewController");
    vc.model = m.user.ID;
    
    PushViewController(vc);
}

#pragma mark - 点击topcell的播放
- (IBAction)playClick:(id)sender
{
    DynamicListModel *m = self.model;
    
    [DownloadAudioService downloadAudioWithUrl:[m.voicelen absoluteString] saveDirectoryPath:DocumentPath fileName:@"xxxxxxx.amr" finish:^(NSString *filePath) {
        
        CloseLoading;
        
        [[LGAudioPlayer sharePlayer] playAudioWithURLString:filePath atIndex:0];
        [LGAudioPlayer sharePlayer].delegate  = self;
        
    } failed:^(id x){
        
    }];
}

#pragma mark - 点击顶部cell的赞
- (void)likeTopCellRequest
{
    @weakify(self);
    
    DynamicListModel *m = self.model;
    //点赞
    [_likeBtn bk_addEventHandler:^(id sender) {
        GPraiseRequest *r = [GPraiseRequest new];
        r.subjectTypeId = 1;
        r.subjectId = m.ID;
        r.type = 1;
        r.receiverID = m.userId;
        r.praiseType = m.ispraise ? 1 : 0;
        
        //   [SVProgressHUD show];
        
        [r startRequestWithCompleted:^(ResponseState *state) {
            @strongify(self);
            //    [SVProgressHUD dismiss];
            
            if (state.isSuccess){
                
                if (m.ispraise){
                    m.ispraise = 0;
                    m.praise -= 1;
                }else{
                    m.ispraise = 1;
                    m.praise += 1;
                }
                
                [self.likeBtn setTitle:[NSString stringWithFormat:@"点赞 (%d)",m.praise] forState:UIControlStateNormal];
                [self.likeBtn setTitleColor:m.ispraise ? APPDefaultColor : [UIColor grayColor] forState:UIControlStateNormal];
                [self.likeBtn setImage:[UIImage praiseWithType:m.ispraise] forState:UIControlStateNormal];
            }
            else{
                ShowError(state.message);
            }
        }];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    // 约台按钮显示
     _yueTaiBtn.hidden = !(m.user.isbound_bar && ![m.user.ID isEqualToString:CurrentUser.user.userId]);
}

#pragma mark - 加载topcell基本数据
- (void)reloadTopcellData
{
    DynamicListModel *m = self.model;

    _userNameLable.text = m.user.userName;
    [_headIV sd_setImageWithURL:m.user.profilePhoto placeholderImage:[UIImage userPlaceholder]];
    NSString *address = [NSString stringWithFormat:@"%@%@", m.provice,m.city];
    
    _voiceLenLabel.text = [m.duration getMMSS];

    _addressLable.text = address.length>0?address:@"未知";
    _contentLable.text = m.content;
    [_likeBtn setTitle:[NSString stringWithFormat:@"点赞 (%d)",m.praise] forState:UIControlStateNormal];
    [_likeBtn setTitleColor:m.ispraise ? APPDefaultColor : [UIColor grayColor] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage praiseWithType:m.ispraise] forState:UIControlStateNormal];
    
    [_likeBtn setImage:[UIImage praiseWithType:m.ispraise] forState:UIControlStateNormal];
    _criticismLable.text = [NSString stringWithFormat:@"评论 (%@)",m.criticismCount];
    
    _dynamicBannerView.imageURLStringsGroup = m.images;
    _dynamicBannerView.showPageControl = NO;
    _dynamicBannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _dynamicBannerView.clickItemOperationBlock = ^(NSInteger currentIndex)
    {
        // 浏览图片
        [XLPhotoBrowser showPhotoBrowserWithImages:m.images currentImageIndex:currentIndex];
    };
    
    _timeLabel.text = m.timeGap;

    if (m.images.count==0) {

        _imageCountLable.text = nil;
        
    }else{
        _imageCountLable.text = [NSString stringWithFormat:@"%ld",m.images.count];
    }
    
    //判断情况1,有语音并且文本存在
    if (m.voicelen && m.content.length)
    {
        [_playBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_playBtn.superview).offset(11.5);
        }];
        _playBtn.hidden = NO;
        _voiceView.hidden = YES;
    }
    
    if (!m.voicelen){
        [_playBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_playBtn.superview).offset(-26.5);
        }];
        
        _playBtn.hidden = YES;
        _voiceView.hidden = YES;
    }
    
    if (m.voicelen && m.content.length == 0)
    {
        _playBtn.hidden = YES;
        _contentLable.hidden = YES;
        _voiceView.hidden = NO;

        [self.view layoutIfNeeded];
        
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.right.equalTo(_headView.superview).offset(0);
            make.width.equalTo(_headView.superview).multipliedBy(1);
            make.height.mas_equalTo(_headView.height + 20);
        }];
    }
    
}

@end
