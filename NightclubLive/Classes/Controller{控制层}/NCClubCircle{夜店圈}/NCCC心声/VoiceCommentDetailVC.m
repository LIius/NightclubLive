//
//  VoiceCommentDetailVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/30.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "VoiceCommentDetailVC.h"
#import "VoiceCommentDetailCell.h"
#import "VoiceCommentDetailViewModel.h"

#import "DynamicListModel.h"
#import "LGAudioKit.h"
#import "DownloadAudioService.h"
#import "VoiceCommentModel.h"


#import "GPraiseRequest.h"
#import "UserInfoViewController.h"
#import "ReportRequest.h"
#import "LimitInput.h"
#import "EmptyMiniView.h"
#import "ReportViewController.h"
#import "ClubCircleRequest.h"
#import "GlobalRequest.h"

#import "UIAlertController+Factory.h"
#import "BlocksKit+UIKit.h"
#import "NCAlert.h"
@interface VoiceCommentDetailSuperVC ()
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
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (strong, nonatomic)  UIButton *dismissView;
@property (nonatomic, strong) VoiceCommentDetailViewModel *viewModel;
@property (nonatomic, strong) VoiceCommentDetailVC *subVC;

@end

@implementation VoiceCommentDetailSuperVC

@dynamic viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setupChildVC];

    [self setupMoreBtn];
    
    [self setupVoide];
   
    [self setupCommentRequest];
   
    [self setupSendBtn];
   
    [self.tf setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    RAC(self.viewModel, content) = self.tf.rac_textSignal;
    [_tf setValue:@80 forKey:@"limit"];
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
    VoiceCommentDetailVC *vc = [VoiceCommentDetailVC controllerWithViewModel:self.viewModel andSbName:@"VoiceCommentSB"];
    self.subVC = vc;
    vc.themCommentCallback = ^(id x){
        touserID = @"";
        _tf.placeholder = @"输入评论内容";
    };
    
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
    [self.contentView insertSubview:vc.view atIndex:0];
    // 回复评论
    vc.replayCallback = ^(VoiceCommentListModel *x){
        [_tf becomeFirstResponder];
        replayType = 1;
        _tf.placeholder = [NSString stringWithFormat:@"回复%@",x.from_user_name];
        touserID = x.userId;
    };
}

- (void)setupVoide
{
    [self.viewModel.voiceCommintCommand.executing subscribeNext:^(NSNumber *executing) {
        if (executing.boolValue) {
            ShowLoading
        } else {
            CloseLoading
        }
    }];
}

- (void)setupMoreBtn
{
    // 更多
    @weakify(self);
    [[_moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x)
     {
         @strongify(self);
         NSString *title = [self.viewModel.model.userId isEqualToString:CurrentUser.userID] ? @"删除" : @"举报";
         

         [NCAlert showActionSheetWithDataSource:@[title,@"返回首页"] blockHandel:^(NSInteger index) {
             @strongify(self);
             [self handelIndex:index];
             
         }];
         
     }];
}

- (void)handelIndex:(NSInteger)index
{
    if (index == 0)
    {
        if ([self.viewModel.model.userId isEqualToString:CurrentUser.userID]){//如果是自己就删除
            DeleteMyHearRequest *r = [DeleteMyHearRequest new];
            r.model = self.viewModel.model.ID;
            [r startRequestWithCompleted:^(ResponseState *state) {
                
                ShowSuccess(state.message);
                
                if(state.isSuccess){
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
        else{
            [NCAlert showActionSheetWithDataSource:SelectDataForKey(@"Report")  blockHandel:^(NSInteger index) {
                ReportViewController *reportVC = [ReportViewController initSBWithSBName:@"ReportSB"];
                reportVC.subjectTypeId = 2;
                reportVC.subjectId = self.viewModel.model.ID;
                reportVC.reportType = index + 1;
                PushViewController(reportVC);
            }];
        }
    }
    else if (index == 1){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

#pragma mark - 发送评论请求
- (void)setupCommentRequest
{
    [self.viewModel.voiceCommintCommand.executionSignals.switchToLatest subscribeNext:^(ResponseState *state) {
        
        if (state.isSuccess) {
            [self.view makeToast:@"评论成功" duration:2 position:CSToastPositionCenter];
            
            self.subVC.refreshType = RefreshTypeLoad;
            self.subVC.currentPage = 1;
            self.viewModel.model.criticismCount += 1;
            [self.subVC reloadDataFromServer];
            [self.subVC reloadDataToView];
            
        }else{
            [self.view makeToast:@"评论失败" duration:2 position:CSToastPositionCenter];
            [self.viewModel.requestRemoteDataCommand execute:nil];
            
        }
        
        touserID = @"";
        _tf.placeholder = @"输入评论内容";
        replayType = 0;
        
    }];
}

- (void)setupSendBtn
{
    // 评论功能
    [[_sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        if (_tf.text.length==0) {
            [self.view makeToast:@"说点什么吧~" duration:2 position:CSToastPositionCenter];
            [_tf resignFirstResponder];
            
            return ;
        }
        
        if (_tf.text.length > 80){
            [self.view makeToast:@"评论最多只能80个字" duration:2 position:CSToastPositionCenter];
            [_tf resignFirstResponder];
            
            return ;
        }
        
        
        if (touserID.length>0) {
            self.viewModel.touserID = touserID;
        }else{
            NSString *userID = self.viewModel.model.user.ID;
            self.viewModel.touserID = self.viewModel.model.userId;
        }
        self.viewModel.replyType = replayType;
        [self.viewModel.voiceCommintCommand execute:nil];
        [_tf resignFirstResponder];
        _tf.text = nil;
        
    }];
}

/**
 *  点击了按钮，点击灰色区域也会调用，相当于点击了取消按钮
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

#pragma mark -键盘即将跳出
-(void)didClickKeyboard:(NSNotification *)sender
{
    CGFloat durition = [sender.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    CGRect keyboardRect = [sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    self.dismissView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-self.bottomView.height-keyboardHeight-20);
    [self.view insertSubview:self.dismissView belowSubview:_bottomView];
    
    [UIView animateWithDuration:durition animations:^{
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
    }];
}
#pragma mark -      当键盘即将消失
-(void)didKboardDisappear:(NSNotification *)sender
{
    CGFloat duration = [sender.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.bottomView.transform = CGAffineTransformIdentity;
        [self.dismissView removeFromSuperview];
    }];
}

@end

















@interface VoiceCommentDetailVC ()<LGAudioPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voiceCons;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *anonymousLable;
@property (weak, nonatomic) IBOutlet UIImageView *addressIV;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIView *voiceView;
@property (weak, nonatomic) IBOutlet UILabel *durationLable;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UIButton *playIV;

@property (nonatomic, strong) VoiceCommentDetailViewModel *viewModel;

@end

@implementation VoiceCommentDetailVC
@dynamic viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.isShowEmptyDataView = NO;
    [self loadDataToView];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.voiceView addGestureRecognizer:tap];
    
    [self setupTableView];
   
    [[_commentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        // 备用
    }];
   
    // 点赞
    [self topCellLikeRequest];
    [self setupCommentListRequest];
    [self setupRefreshRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:animated];
   
   [[LGAudioPlayer sharePlayer] stopAudioPlayer];
}

- (void)setupTableView
{
    CGFloat curWidth = kScreenWidth-14*2;
    CGFloat curHeight = [self.viewModel.model.content getHeightWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(curWidth, CGFLOAT_MAX)]+61+8*2+28*2+_voiceCons.constant;
    self.tableView.tableHeaderView.height = curHeight;
    [self.tableView setTableHeaderView:self.tableView.tableHeaderView];

    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 108, 0);
    self.refresh_tableView = self.tableView;
    self.haveRefreshHead   = YES;
    self.haveRefreshFoot   = YES;
    MJRefreshNormalHeader *head = (MJRefreshNormalHeader *)self.tableView.mj_header;
    head.stateLabel.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 刷新列表
- (void)setupRefreshRequest
{
    @weakify(self);
    self.refreshBlock = ^(RefreshType type,NSInteger page){
        @strongify(self);
        self.viewModel.pageNow = page;
        self.viewModel.refreshType = type;
        [self.viewModel.getCommentListCommand execute:nil];
    };
}

#pragma mark - 获取评论列表
- (void)setupCommentListRequest
{
    @weakify(self);
    [self.viewModel.getCommentListCommand.executionSignals.switchToLatest subscribeNext:^(ResponseState *state)
     {
         @strongify(self);
         [self.tableView endRefresh];
         
         if (state.isSuccess)
         {
             [self.tableView reloadInMain];
         }
         
         [NCEmpty showOrHideOn:self.tableView customeView:[EmptyMiniView viewWithTip:@"暂无评论哦~"]];
         
         [self loadDataToView];
     }];
}

#pragma mark - 顶部cell点赞
- (void)topCellLikeRequest
{
    @weakify(self);
    [_likeBtn bk_whenTapped:^
     {
         GPraiseRequest *r = [GPraiseRequest new];
         r.subjectTypeId = 2;
         r.subjectId = self.viewModel.model.ID;
         r.type = 1;
         r.praiseType = self.viewModel.model.ispraise ? 1 : 0;
         [r startRequestWithCompleted:^(ResponseState *state) {
             @strongify(self);
             if (state.isSuccess){
                 self.viewModel.model.ispraise = self.viewModel.model.ispraise ? 0 : 1;
                 self.viewModel.model.praise -= self.viewModel.model.ispraise ? -1 : 1;
                 
                 [self loadDataToView];
             }
             else{
                 [self.view makeToast:state.message duration:1.02 position:CSToastPositionCenter];
             }
         }];
     }];
}

#pragma mark - 切回评论主题
- (IBAction)themCommentAction:(id)sender
{
    if (_themCommentCallback) {
        _themCommentCallback(nil);
    }
}

#pragma mark - 播放音频
- (void)handleTap:(UITapGestureRecognizer *)tap
{
    [DownloadAudioService downloadAudioWithUrl:self.viewModel.model.voicelen saveDirectoryPath:DocumentPath fileName:@"xxxxxxx.amr" finish:^(NSString *filePath) {
        [[LGAudioPlayer sharePlayer] playAudioWithURLString:filePath atIndex:0];
       [LGAudioPlayer sharePlayer].delegate = self;
        
    } failed:^(id x){
        
    }];
}


#pragma mark - LGAudioPlay Delegate
- (void)audioPlayerStateDidChanged:(LGAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index
{
   switch (audioPlayerState)
    {
      case LGAudioPlayerStateNormal:
        {
      
        }
            break;
      case LGAudioPlayerStatePlaying:
        {
         
         NSArray *animationImage = @[KGetImage(@"play1"),KGetImage(@"play2"),KGetImage(@"play3"),KGetImage(@"play4")];
         //启动动画
         [_playIV.imageView setAnimationImages:animationImage];
         [_playIV.imageView setAnimationRepeatCount:0];
         [_playIV.imageView setAnimationDuration:1.5];
         [_playIV.imageView startAnimating];
      }
            break;
      case LGAudioPlayerStateCancel:
        {
         [_playIV.imageView stopAnimating];
         [_playIV.imageView setImage:KGetImage(@"icon_voice")];
      };
   }
}

#pragma mark - Public
- (void)reloadDataToView
{
   [self loadDataToView];
}

#pragma mark - Private Method
- (void)loadDataToView
{
    // 配置UI
    [_headIV sd_setImageWithURL:URL(self.viewModel.model.user.profilePhoto) placeholderImage:[UIImage userPlaceholder]];
   _durationLable.text = [self.viewModel.model.duration getMMSS];
    
   if ([self.viewModel.model.messageType intValue] == 1)
   {
       _voiceCons.constant = 0;
   }else
   {
       _voiceCons.constant = 40;
   }
    
   _timeLable.text = self.viewModel.model.createtime.difftime;
    
   _nameLable.text = self.viewModel.model.user.userName;
    
   [_commentBtn setTitle:[NSString stringWithFormat:@"回复(%ld)",self.viewModel.model.criticismCount] forState:UIControlStateNormal];
   [_commentBtn setImage:KGetImage(@"红人圈-评论") forState:UIControlStateNormal];
   [_commentBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [_likeBtn setTitle:[NSString stringWithFormat:@"点赞 (%ld)",self.viewModel.model.praise] forState:UIControlStateNormal];
    [_likeBtn setTitleColor:self.viewModel.model.ispraise == 1 ? APPDefaultColor : [UIColor grayColor] forState:UIControlStateNormal];
    [_likeBtn setImage:[UIImage imageNamed:self.viewModel.model.ispraise ? @"icon_support_press" : @"红人圈-点赞"] forState:UIControlStateNormal];
    
    
    NSString *address = [NSString stringWithFormat:@"%@%@",self.viewModel.model.provice,self.viewModel.model.city];
    _addressLable.text = address.length>0?address:@"未知";
    _contentLable.text = self.viewModel.model.content;
   
   // 判断是否是匿名
   if ([self.viewModel.model.anonymous integerValue] == 1)
   {
      _anonymousLable.hidden = NO;
      _addressLable.hidden = YES;
      _addressIV.hidden = YES;
      _nameLable.hidden = YES;
      _headIV.hidden = YES;
   }
   else{
      _anonymousLable.hidden = YES;
      _addressLable.hidden = NO;
      _addressIV.hidden = NO;
      _nameLable.hidden = NO;
      _headIV.hidden = NO;
   }
}

- (void)reloadDataFromServer
{
    self.viewModel.pageNow = 1;
    self.viewModel.refreshType = RefreshTypeLoad;
    [self.viewModel.getCommentListCommand execute:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoiceCommentListModel * m = self.viewModel.datas[indexPath.row];
    return m.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"VoiceCommentDetailCellID";
    VoiceCommentDetailCell *cell = (VoiceCommentDetailCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.indexPath = indexPath;
    
    @weakify(self);
   kWeakSelf(cell);
    cell.praiseBlock = ^(NSIndexPath *valueIndex)
    {
        @strongify(self);
        // 点赞
        [self likeRequest:valueIndex];
    };
   
   // 回复某一个用户
   cell.replayCallback = ^(NSIndexPath *cellIndexPath)
    {
       @strongify(self);
      VoiceCommentListModel *m = self.viewModel.datas[cellIndexPath.row];
      if (self.replayCallback)
      {
          self.replayCallback(m);
      }
   };
   
   cell.logoBlock = ^(NSIndexPath *vIndexPath)
    {
      @strongify(self);
      UserInfoViewController *userInfoVC = [UserInfoViewController initSBWithSBName:@"UserInfoSB"];
      VoiceCommentListModel *model = self.viewModel.datas[indexPath.row];
      User *m = [User new];
      m.userId = model.userId;
      userInfoVC.userModel = m;
      PushViewController(userInfoVC);
   };
   
   cell.deleteBlock = ^(NSIndexPath *vIndexPath) {
       @strongify(self);
      vIndexPath = [self.tableView indexPathForCell:weakcell];
       // 删除
       [self deleteRequest:vIndexPath];
   };
   
    cell.model = self.viewModel.datas[indexPath.row];
    cell.indexPath = indexPath;
    
    return cell;
}

#pragma mark - 删除
- (void)deleteRequest:(NSIndexPath *)vIndexPath
{
    @weakify(self);
    UIAlertController *ac = [UIAlertController alertCancelAndOKWithTitle:@"删除提示" message:@"确定要删除评论?" okCalk:^(id param)
        {
            @strongify(self);
            VoiceCommentListModel * m = self.viewModel.datas[vIndexPath.row];
            DeleteCommentRequest *r = [DeleteCommentRequest new];
            r.model = m.ID;
            r.type = 2;
            r.subectId = self.viewModel.model.ID;
            [r startRequestWithCompleted:^(ResponseState *state) {
                @strongify(self);
                if (state.isSuccess)
                {
                    //更新cell
                    [self.viewModel removeAtIndex:vIndexPath.row];
                    [self.tableView reloadInMain];
                    //更新评论数量与界面
                    self.viewModel.model.criticismCount -= 1;
                    [self loadDataToView];
                    
                }
                else{
                    ShowError(@"删除失败");
                }
            }];
            
        }];
    
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - 点赞
- (void)likeRequest:(NSIndexPath *)valueIndex
{
    @weakify(self);
    VoiceCommentListModel *m = self.viewModel.datas[valueIndex.row];
    GPraiseRequest *r = [GPraiseRequest new];
    r.subjectTypeId = 2;
    r.subjectId = m.ID;
    r.type = 2;
    r.praiseType= m.ispraise ? 1 : 0;
    [r startRequestWithCompleted:^(ResponseState *state) {
        @strongify(self);
        if (state.isSuccess){
            
            if (m.ispraise){
                m.ispraise = 0;
                m.praise -= 1;
            }
            else{
                m.ispraise = 1;
                m.praise += 1;
            }
            
            [self.tableView reloadRowsAtIndexPaths:@[valueIndex]withRowAnimation:UITableViewRowAnimationNone];
        }
        else{
            ShowError(state.message);
        }
    }];
}

#pragma mark - Click
- (IBAction)userInfoClick:(id)sender
{
   UserInfoViewController *userInfoVC = [UserInfoViewController initSBWithSBName:@"UserInfoSB"];
    User *m = [User new];
    m.userId = self.viewModel.model.userId;
    userInfoVC.userModel = m;
    PushViewController(userInfoVC);
}

@end
