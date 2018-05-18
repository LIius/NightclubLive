//
//  ClubCircleGuiMiVoiceVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/2.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "ClubCircleGuiMiVoiceVC.h"
#import "ClubCircleGuiMiVoiceCell.h"
#import "VoiceCommentDetailVC.h"
#import "ClubCircleGuiMiVoiceViewModel.h"

#import "LGAudioKit.h"
#import "DownloadAudioService.h"
#import "VoiceCommentDetailViewModel.h"
#import "VoiceView.h"
#import "HeartsoundListModel.h"

#import "QiniuTool.h"
#import "GPraiseRequest.h"
#import "ClubCircleRequest.h"
#import "UserInfoViewController.h"
#import "LimitInput.h"
#import "EmptyBigView.h"
#import "UILabel+NavTitleView.h"

@interface ClubCircleGuiMiVoiceSuperVC ()

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UIButton *anonymousBtn;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (nonatomic, strong) ClubCircleGuiMiVoiceViewModel *viewModel;
@property (nonatomic, strong) ClubCircleGuiMiVoiceVC *subVC;
@property (strong, nonatomic)  UIButton *dismissView;

@end

@implementation ClubCircleGuiMiVoiceSuperVC

@dynamic viewModel;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupSubVC];
 
    self.navigationItem.titleView = [UILabel navWithTitle:self.viewModel.model.title];
    [_tf setValue:@(80) forKey:@"limit"];
    [self.tf setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self setupAnonymousBtn];
    
    [self setupVoiceRequest];
    
    [self setupLikeRequest];
    
    RAC(self.viewModel, content) = self.tf.rac_textSignal;
    
    [self setupSendBtn];
    
    [self setupRecordBtn];
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
    [[LGAudioPlayer sharePlayer] stopAudioPlayer];
}

- (void)setupSubVC
{
    ClubCircleGuiMiVoiceVC *vc = [ClubCircleGuiMiVoiceVC initSBWithSBName:@"CCGuiMiVoiceSB"];
    vc.model = self.viewModel.model;
    self.subVC = vc;
    [self addChildViewController:vc];
    vc.view.frame = CGRectMake(0, -54, self.contentView.bounds.size.width, self.contentView.bounds.size.height + 10);
    [self.contentView insertSubview:vc.view atIndex:0];
}

#pragma mark - 启动录音控件
- (void)setupRecordBtn
{
    [[_recordButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self setUPShareView];
    }];
}

- (void)setupLikeRequest
{
    [self.viewModel.likeReuqesCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        if ([x boolValue]) {
            [self.view makeToast:@"点赞成功" duration:2 position:CSToastPositionCenter];
            [self.viewModel.requestRemoteDataCommand execute:nil];
        }
    }];
}

- (void)setupAnonymousBtn
{
    _anonymousBtn.backgroundColor = [UIColor colorWithHexString:@"3c3c3c"];
    [_anonymousBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _anonymousBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _anonymousBtn.layer.borderWidth =  0.5;
    //匿名功能
    
    [[_anonymousBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        x.selected = !x.selected;
        if (x.selected) {
            _anonymousBtn.backgroundColor = [UIColor whiteColor];
            [_anonymousBtn setTitleColor:[UIColor colorWithHexString:@"c34c9c"] forState:UIControlStateNormal];
            _anonymousBtn.layer.borderColor = [UIColor colorWithHexString:@"c34c9c"].CGColor;
            _anonymousBtn.layer.borderWidth =  0.5;
            
            self.viewModel.isNiming = @1;
        }else{
            _anonymousBtn.backgroundColor = [UIColor colorWithHexString:@"3c3c3c"];
            [_anonymousBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _anonymousBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            _anonymousBtn.layer.borderWidth =  0.5;
            
            
            self.viewModel.isNiming = @0;
            
        }
    }];
}

- (void)setupVoiceRequest
{
    [self.viewModel.voiceCommintCommand.executing subscribeNext:^(NSNumber *executing) {
        if (executing.boolValue) {
            ShowLoading
        } else {
            CloseLoading
        }
    }];
    
    
    [self.viewModel.voiceCommintCommand.executionSignals.switchToLatest subscribeNext:^(ResponseState *state) {
        
        if (state.isSuccess) {
            [self.view makeToast:@"发布成功" duration:2 position:CSToastPositionCenter];
            //[self.viewModel.getListCommand execute:nil];
            [self.subVC getListButNotRefresh];
            
        }else{
            [self.view makeToast:@"发布失败" duration:2 position:CSToastPositionCenter];
            [self.viewModel.requestRemoteDataCommand execute:nil];
            
        }
    }];
}

- (void)setupSendBtn
{
    [[self.sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
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
        
        //发布内容文本评论 添加参数
        self.viewModel.isAnonymous = self.anonymousBtn.isSelected ? 1 : 0;
        self.viewModel.content = self.tf.text;
        self.viewModel.messageType = 1;
        [self.viewModel.voiceCommintCommand execute:@1];
        [_tf resignFirstResponder];
        _tf.text = nil;
        
    }];
}

- (void)setUPShareView
{
    self.navigationItem.title = self.viewModel.model.title;
    [_tf resignFirstResponder];

    VoiceView *view = [VoiceView voiceView];
    //发送录音
    
    kWeakSelf(view);
    
    view.sendCallback = ^(NSNumber *x){
        
        [weakview dismissMaskView];
        
        NSString *url = [LGSoundRecorder shareInstance].soundFilePath;
        NSData *soundData = [[LGSoundRecorder shareInstance] convertCAFtoAMR:url];
        NSTimeInterval recordTime = [[LGSoundRecorder shareInstance] soundRecordTime];
        [[QiniuTool shareTool] uploadSound:soundData type:UploadTypeSpaceTypeHeartSound success:^(NSString *soundStr) {
            
            DLog(@"%@",soundStr);
            
            self.viewModel.voicelen = soundStr;
            self.viewModel.duration = recordTime;
            self.viewModel.messageType = 2;
            [self.viewModel.voiceCommintCommand execute:nil];
            
        } failure:^(NSError *error) {
            
            [self.view makeToast:@"发送语音失败" duration:1.0 position:CSToastPositionCenter];
        }];
        [_tf resignFirstResponder];

        
    };
    [view setUP];
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
    
    [UIView animateWithDuration:0.5 animations:^{
        view.frame=CGRectMake(0, SCREEN_HEIGHT-300, SCREEN_WIDTH, 300);
    }];
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

#pragma mark -      当键盘即将消失
-(void)didKboardDisappear:(NSNotification *)sender
{
    CGFloat duration = [sender.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.bottomView.transform = CGAffineTransformIdentity;
    }];
}

@end













@interface ClubCircleGuiMiVoiceVC ()
<
ClubCircleGuiMiVoiceCellDelegate,
LGAudioPlayerDelegate
>

@property (nonatomic, strong) ClubCircleGuiMiVoiceViewModel *viewModel;
@property(nonatomic,strong)UIView *emptyView;

@end


@implementation ClubCircleGuiMiVoiceVC

@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.refreshView = self.tableView;
    self.isHead = YES;
    self.isFoot = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadInMain];
}

#pragma mark - Request
- (void)refreshMethod
{
    UserInfo *userInfo = [UserInfo shareUser];
    HeartsoundRequest *request = [HeartsoundRequest new];
    VoiceListModel *m = self.model;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.pageNow) {
        [params setValue:@(self.pageNow) forKey:@"pageNow"];
    }
    if (m.ID.length > 0) {
        [params setValue:m.ID forKey:@"type"];
    }
    if (userInfo.location.lclatitude) {
        [params setValue:userInfo.location.lclatitude forKey:@"latitude"];
    }
    if (userInfo.location.lclongitude) {
        [params setValue:userInfo.location.lclongitude forKey:@"longitude"];
    }
    if (userInfo.userID.length >0  ) {
        [params setValue:userInfo.userID forKey:@"userId"];
    }
    
    request.param = params;
    //request.param = @{@"pageNow":@(self.pageNow),@"type":m.ID,@"latitude":userInfo.location.lclatitude,@"longitude":userInfo.location.lclongitude,@"userId":userInfo.userID};
    [request startRequestWithCompleted:^(ResponseState *state) {
        
        self.parses = [HeartsoundListModel arrayObjectWithDS:state.datas];
        [self requestEnd];
    }];
}

- (void)getListButNotRefresh
{
    [self refreshMethod];
}

#pragma mark - LGAudioPlayerDelegate
- (void)audioPlayerStateDidChanged:(LGAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    ClubCircleGuiMiVoiceCell *voiceMessageCell = [self.tableView cellForRowAtIndexPath:indexPath];
    LGVoicePlayState voicePlayState;
    switch (audioPlayerState) {
        case LGAudioPlayerStateNormal:
            voicePlayState = LGVoicePlayStateNormal;
            break;
        case LGAudioPlayerStatePlaying:
            voicePlayState = LGVoicePlayStatePlaying;
            break;
        case LGAudioPlayerStateCancel:
            voicePlayState = LGVoicePlayStateCancel;
            break;
            
        default:
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [voiceMessageCell setVoicePlayState:voicePlayState];
    });
}

#pragma mark - LGTableViewCellDelegate
- (void)voiceMessageTaped:(ClubCircleGuiMiVoiceCell *)cell
{
    [cell setVoicePlayState:LGVoicePlayStatePlaying];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    HeartsoundListModel *messageModel = [self.dataSource objectAtIndex:indexPath.row];
    
    ShowLoading
    
    [DownloadAudioService downloadAudioWithUrl:messageModel.voicelen saveDirectoryPath:DocumentPath fileName:@"xxxxxxx.amr" finish:^(NSString *filePath) {
        
        CloseLoading;
        
        [[LGAudioPlayer sharePlayer] playAudioWithURLString:filePath atIndex:indexPath.row];
        [LGAudioPlayer sharePlayer].delegate  = self;

    } failed:^(id x){
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (self.dataSource.count == 0 )
    {
        if (!_emptyView)
        {
            UIView *v = [EmptyBigView viewWithTip:@"心声话题准备中哦~"];
            v.frame = [NCEmpty getEmtpyViewRectWithScrollView:self.tableView];
            [self.view addSubview:v];
            _emptyView = v;
        }
        
    }else{
        if (_emptyView){
            [_emptyView removeFromSuperview];
        }
        
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ClubCircleGuiMiVoiceCellID";
    ClubCircleGuiMiVoiceCell *cell = (ClubCircleGuiMiVoiceCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    HeartsoundListModel *model = self.dataSource[indexPath.row];
    @weakify(self);
    cell.likeCallback = ^(NSIndexPath *cellIndexPath){
        @strongify(self);
        [self likeRequest:cellIndexPath];
    };
    
    cell.logoBlock = ^(NSIndexPath *vIndexPath){
        @strongify(self);
        [self goUserInfo:vIndexPath];
    };
    
    cell.model = model;
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    return cell;
}

#pragma mark - 点赞
- (void)likeRequest:(NSIndexPath *)cellIndexPath
{
    @weakify(self);
    HeartsoundListModel *m = self.dataSource[cellIndexPath.row];
    GPraiseRequest *r = [GPraiseRequest new];
    r.subjectTypeId = 2;
    r.subjectId = m.ID;
    r.type = 1;
    r.praiseType= m.ispraise ? 1 : 0;
    [r startRequestWithCompleted:^(ResponseState *state)
    {
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
            
            [self.tableView reloadRowsAtIndexPaths:@[cellIndexPath]withRowAnimation:UITableViewRowAnimationNone];
        }
        else{
            ShowError(state.message);
        }
    }];
}

#pragma mark - 跳转至用户资料
- (void)goUserInfo:(NSIndexPath *)vIndexPath
{
    UserInfoViewController *userVC = [UserInfoViewController initSBWithSBName:@"UserInfoSB"];
    
    HeartsoundListModel *m = self.dataSource[vIndexPath.row];
    User *u = [User new];
    u.userId = m.userId;
    userVC.userModel = u;
    [self.navigationController pushViewController:userVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ClubCircleGuiMiVoiceCell cellHeightWithObj:self.dataSource[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoiceCommentDetailViewModel *viewModel = [[VoiceCommentDetailViewModel alloc] initWithParams:nil];
    HeartsoundListModel *model = self.dataSource[indexPath.row];
    VoiceListModel *m = self.model;
    viewModel.model = model;
    viewModel.themID = m.ID;
    VoiceCommentDetailSuperVC *vc = [VoiceCommentDetailSuperVC controllerWithViewModel:viewModel andSbName:@"VoiceCommentDetailSuperSB"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
