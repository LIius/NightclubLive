//
//  NTESSessionViewController.m
//  NIM
//
//  Created by amao on 8/11/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//  会话--子类

#import "NTESSessionViewController.h"
@import MobileCoreServices;
@import AVFoundation;
#import "Reachability.h"
#import "UIActionSheet+NTESBlock.h"
#import "NTESSessionConfig.h"
#import "NIMMediaItem.h"
#import "NTESSessionMsgConverter.h"
#import "NTESFileLocationHelper.h"
#import "NTESSessionMsgConverter.h"
#import "UIView+Toast.h"

#import "NSDictionary+NTESJson.h"
#import "NTESSessionRemoteHistoryViewController.h"
#import "UIView+NTES.h"
#import "NTESBundleSetting.h"
#import "NTESSessionLocalHistoryViewController.h"
#import "NIMContactSelectViewController.h"
#import "NTESTimerHolder.h"
#import "NTESFPSLabel.h"
#import "UIAlertView+NTESBlock.h"
#import "NIMKit.h"
#import "NTESSessionUtil.h"
#import "NIMKitMediaFetcher.h"
#import "ChangeRemarkView.h"
#import "NIMKitUtil.h"
#import "XLPhotoBrowser.h"
#import "UserInfoViewController.h"
#import "ScottAlertController.h"
#import "UIAlertController+Factory.h"
#import "NCAlert.h"

@interface NTESSessionViewController ()
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
NIMSystemNotificationManagerDelegate,
NIMMediaManagerDelgate,
NTESTimerHolderDelegate,
NIMContactSelectDelegate>

@property (nonatomic,strong)    NTESSessionConfig       *sessionConfig;
@property (nonatomic,strong)    UIImagePickerController *imagePicker;
@property (nonatomic,strong)    NTESTimerHolder         *titleTimer;
@property (nonatomic,strong)    UIView *currentSingleSnapView;
@property (nonatomic,strong)    NTESFPSLabel *fpsLabel;
@property (nonatomic,strong)    NIMKitMediaFetcher *mediaFetcher;
@end

@implementation NTESSessionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"enter session, id = %@",self.session.sessionId);
    
    if (![self.session.sessionId isEqualToString:@"礼物管家"])
    {
        [self setUpNav];
    }
    
    BOOL disableCommandTyping = self.disableCommandTyping || (self.session.sessionType == NIMSessionTypeP2P &&[[NIMSDK sharedSDK].userManager isUserInBlackList:self.session.sessionId]);
    if (!disableCommandTyping)
    {
        _titleTimer = [[NTESTimerHolder alloc] init];
        [[[NIMSDK sharedSDK] systemNotificationManager] addDelegate:self];
    }
    
    if ([[NTESBundleSetting sharedConfig] showFps])
    {
        self.fpsLabel = [[NTESFPSLabel alloc] initWithFrame:CGRectZero];
        [self.view addSubview:self.fpsLabel];
        self.fpsLabel.right = self.view.width;
        self.fpsLabel.top   = self.tableView.top + self.tableView.contentInset.top;
    }
}

- (void)dealloc
{
    [[[NIMSDK sharedSDK] systemNotificationManager] removeDelegate:self];
    [_fpsLabel invalidate];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.fpsLabel.right = self.view.width;
    self.fpsLabel.top   = self.tableView.top + self.tableView.contentInset.top;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NIMSDK sharedSDK].mediaManager stopRecord];
    [[NIMSDK sharedSDK].mediaManager stopPlay];
}

- (id<NIMSessionConfig>)sessionConfig
{
    if (_sessionConfig == nil) {
        _sessionConfig = [[NTESSessionConfig alloc] init];
        _sessionConfig.session = self.session;
    }
    return _sessionConfig;
}

#pragma mark - NIMSystemNotificationManagerProcol
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    if (!notification.sendToOnlineUsersOnly)
    {
        return;
    }
}

- (void)onNTESTimerFired:(NTESTimerHolder *)holder
{
    self.title = [self sessionTitle];
}

- (NSString *)sessionTitle
{
    if ([self.session.sessionId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount])
    {
        return @"我";
    }
    return [super sessionTitle];
}

- (void)onTextChanged:(id)sender
{
    
}

#pragma mark - 提醒消息
- (void)onTapMediaItemTip:(NIMMediaItem *)item
{
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"输入提醒" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        switch (index) {
            case 1:{
                UITextField *textField = [alert textFieldAtIndex:0];
                NIMMessage *message = [NTESSessionMsgConverter msgWithTip:textField.text];
                [self sendMessage:message];
            }
                break;
            default:
                break;
        }
    }];
}

#pragma mark - 录音事件
- (void)onRecordFailed:(NSError *)error
{
    [self.view makeToast:@"录音失败" duration:2 position:CSToastPositionCenter];
}

- (BOOL)recordFileCanBeSend:(NSString *)filepath
{
    NSURL    *URL = [NSURL fileURLWithPath:filepath];
    AVURLAsset *urlAsset = [[AVURLAsset alloc]initWithURL:URL options:nil];
    CMTime time = urlAsset.duration;
    CGFloat mediaLength = CMTimeGetSeconds(time);
    return mediaLength > 2;
}

- (void)showRecordFileNotSendReason
{
    [self.view makeToast:@"录音时间太短" duration:0.2f position:CSToastPositionCenter];
}

#pragma mark - Cell事件
- (void)onTapCell:(NIMKitEvent *)event
{
    BOOL handled = NO;
    NSString *eventName = event.eventName;
    if ([eventName isEqualToString:NIMKitEventNameTapContent])
    {
        NIMMessage *message = event.messageModel.message;
        NSDictionary *actions = [self cellActions];
        NSString *value = actions[@(message.messageType)];
        if (value) {
            SEL selector = NSSelectorFromString(value);
            if (selector && [self respondsToSelector:selector]) {
                SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:message]);
                handled = YES;
            }
        }
    }
    else if([eventName isEqualToString:NIMKitEventNameTapLabelLink])
    {
        NSString *link = event.data;
        [self.view makeToast:[NSString stringWithFormat:@"tap link : %@",link]
                    duration:2
                    position:CSToastPositionCenter];
        handled = YES;
    }
    else if([eventName isEqualToString:NIMKitEventImage]){
        // 图片浏览
        NIMImageObject *imageObject = (NIMImageObject *)event.messageModel.message.messageObject;
        [XLPhotoBrowser showPhotoBrowserWithImages:@[imageObject.url] currentImageIndex:0];
        handled = YES;
    }
    else if ([eventName isEqualToString:NIMKitEventLocation]){//定位
         NIMLocationObject *locationObject = (NIMLocationObject*)event.messageModel.message.messageObject;
        handled = YES;
        
        [NCAlert showActionSheetWithDataSource:@[@"苹果地图导航"] blockHandel:^(NSInteger index) {
            if (index == 0){
                
                
                CLLocationCoordinate2D loc = CLLocationCoordinate2DMake
                (locationObject.latitude, locationObject.longitude);
                NSDictionary *mapDic = @{@"name": locationObject.title};
                MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
                MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:mapDic]];
                toLocation.name = locationObject.title;
                [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                               launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                               MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
            }
        }];

    }

    if (!handled) {
        NSAssert(0, @"invalid event");
    }
}

- (void)onLongPressCell:(NIMMessage *)message inView:(UIView *)view {
    [super onLongPressCell:message
                    inView:view];
}

- (void)onTapAvatar:(NSString *)userId
{
    User *model = [[User alloc] init];
    model.phone_num = userId;
    
    UserInfoViewController *infoVC = [UserInfoViewController initSBWithSBName:@"UserInfoSB"];
    infoVC.userModel = model;
    PushViewController(infoVC);
}


#pragma mark - Cell Actions
- (void)showImage:(NIMMessage *)message
{
//#warning 这需要后期替换查看图片模型以及逻辑
    NIMImageObject *object = message.messageObject;
//    NTESGalleryItem *item = [[NTESGalleryItem alloc] init];
//    item.thumbPath      = [object thumbPath];
//    item.imageURL       = [object url];
//    item.name           = [object displayName];
//    NTESGalleryViewController *vc = [[NTESGalleryViewController alloc] initWithItem:item];
//    [self.navigationController pushViewController:vc animated:YES];
    if(![[NSFileManager defaultManager] fileExistsAtPath:object.thumbPath]){
        //如果缩略图下跪了，点进看大图的时候再去下一把缩略图
        __weak typeof(self) wself = self;
        [[NIMSDK sharedSDK].resourceManager download:object.thumbUrl filepath:object.thumbPath progress:nil completion:^(NSError *error) {
            if (!error) {
                [wself uiUpdateMessage:message];
            }
        }];
    }
}

- (void)showCustom:(NIMMessage *)message {
   //普通的自定义消息点击事件可以在这里做哦~
}

#pragma mark - 导航按钮
- (void)onTouchUpInfoBtn:(id)sender {
    
    //修改资料
    ChangeRemarkView *v = [ChangeRemarkView initFromXIB];
//    v.frame = KEYWINDOW.bounds;
//    [KEYWINDOW addSubview:v];
    
    v.calkBackBlock = ^(NSString *name){
        
        
        if (name.length > 10){
            ShowError(@"不能超过10个字")
        }else{
            NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:self.session.sessionId];
            user.alias = name;
            [[NIMSDK sharedSDK].userManager updateUser:user completion:^(NSError * _Nullable error) {
                
                UILabel *nameLab = (UILabel *)self.navigationItem.titleView;
                nameLab.text = [NIMKitUtil showNick:self.session.sessionId inSession:self.session];
            }];
        }

    };
    
    ScottAlertViewController *ac = [ScottAlertViewController alertControllerWithAlertView:v];
    ac.tapBackgroundDismissEnable = YES;
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)enterHistory:(id)sender
{
    [self.view endEditing:YES];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"云消息记录",@"搜索本地消息记录",@"清空本地聊天记录", nil];
    
    [sheet showInView:self.view completionHandler:^(NSInteger index)
     {
        switch (index)
        {
            case 0:{ //查看云端消息
                NTESSessionRemoteHistoryViewController *vc = [[NTESSessionRemoteHistoryViewController alloc] initWithSession:self.session];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1:{ //搜索本地消息
                NTESSessionLocalHistoryViewController *vc = [[NTESSessionLocalHistoryViewController alloc] initWithSession:self.session];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:{ //清空聊天记录
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确定清空聊天记录？" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
                __weak UIActionSheet *wSheet;
                [sheet showInView:self.view completionHandler:^(NSInteger index) {
                    if (index == wSheet.destructiveButtonIndex) {
                        BOOL removeRecentSession = [NTESBundleSetting sharedConfig].removeSessionWheDeleteMessages;
                        [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:self.session removeRecentSession:removeRecentSession];
                    }
                }];
                break;
            }
            default:
                break;
        }
    }];
}

#pragma mark - 菜单
- (NSArray *)menusItems:(NIMMessage *)message
{
    NSMutableArray *items = [NSMutableArray array];
    NSArray *defaultItems = [super menusItems:message];
    if (defaultItems) {
        [items addObjectsFromArray:defaultItems];
    }
    
    if ([NTESSessionUtil canMessageBeForwarded:message]) {
        [items addObject:[[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(forwardMessage:)]];
    }
    
    if ([NTESSessionUtil canMessageBeRevoked:message]) {
        [items addObject:[[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(revokeMessage:)]];
    }
    return items;
}

- (void)forwardMessage:(id)sender
{
    NIMMessage *message = [self messageForMenu];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择会话类型" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"个人",@"群组", nil];
    __weak typeof(self) weakSelf = self;
    [sheet showInView:self.view completionHandler:^(NSInteger index) {
        switch (index) {
            case 0:{
                NIMContactFriendSelectConfig *config = [[NIMContactFriendSelectConfig alloc] init];
                config.needMutiSelected = NO;
                NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
                vc.finshBlock = ^(NSArray *array){
                    NSString *userId = array.firstObject;
                    NIMSession *session = [NIMSession session:userId type:NIMSessionTypeP2P];
                    [weakSelf forwardMessage:message toSession:session];
                };
                [vc show];
            }
                break;
            case 1:{
                NIMContactTeamSelectConfig *config = [[NIMContactTeamSelectConfig alloc] init];
                NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
                vc.finshBlock = ^(NSArray *array){
                    NSString *teamId = array.firstObject;
                    NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
                    [weakSelf forwardMessage:message toSession:session];
                };
                [vc show];
            }
                break;
            case 2:
                break;
            default:
                break;
        }
    }];
}

- (void)revokeMessage:(id)sender
{
    NIMMessage *message = [self messageForMenu];
    __weak typeof(self) weakSelf = self;
    [[NIMSDK sharedSDK].chatManager revokeMessage:message completion:^(NSError * _Nullable error) {
        if (error)
        {
            if (error.code == NIMRemoteErrorCodeDomainExpireOld) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发送时间超过2分钟的消息，不能被撤回" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                NSLog(@"revoke message eror code %zd",error.code);
                [weakSelf.view makeToast:@"消息撤回失败，请重试" duration:2.0 position:CSToastPositionCenter];
            }
        }
        else
        {
            NIMMessageModel *model = [self uiDeleteMessage:message];
            NIMMessage *tip = [NTESSessionMsgConverter msgWithTip:[NTESSessionUtil tipOnMessageRevoked:message]];
            tip.timestamp = model.messageTime;
            [self uiAddMessages:@[tip]];
            
            tip.timestamp = message.timestamp;
            // saveMessage 方法执行成功后会触发 onRecvMessages: 回调，但是这个回调上来的 NIMMessage 时间为服务器时间，和界面上的时间有一定出入，所以要提前先在界面上插入一个和被删消息的界面时间相符的 Tip, 当触发 onRecvMessages: 回调时，组件判断这条消息已经被插入过了，就会忽略掉。
            [[NIMSDK sharedSDK].conversationManager saveMessage:tip forSession:message.session completion:nil];
        }
    }];
}

- (void)forwardMessage:(NIMMessage *)message toSession:(NIMSession *)session
{
    NSString *name;
    if (session.sessionType == NIMSessionTypeP2P)
    {
        name = [[NIMKit sharedKit] infoByUser:session.sessionId inSession:session].showName;
    }
    else
    {
        name = [[NIMKit sharedKit] infoByTeam:session.sessionId].showName;
    }
    NSString *tip = [NSString stringWithFormat:@"确认转发给 %@ ?",name];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认转发" message:tip delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    
    __weak typeof(self) weakSelf = self;
    [alert showAlertWithCompletionHandler:^(NSInteger index) {
        if(index == 1){
            [[NIMSDK sharedSDK].chatManager forwardMessage:message toSession:session error:nil];
            [weakSelf.view makeToast:@"已发送" duration:2.0 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark - 辅助方法
- (BOOL)checkCondition
{
    BOOL result = YES;
    
    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
        [self.view makeToast:@"请检查网络" duration:2.0 position:CSToastPositionCenter];
        result = NO;
    }
    NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
    if ([currentAccount isEqualToString:self.session.sessionId]) {
        [self.view makeToast:@"不能和自己通话哦" duration:2.0 position:CSToastPositionCenter];
        result = NO;
    }
    return result;
}

- (NSDictionary *)cellActions
{
    static NSDictionary *actions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actions = @{@(NIMMessageTypeImage) : @"showImage:",
                    @(NIMMessageTypeCustom): @"showCustom:"};
    });
    return actions;
}

- (NIMKitMediaFetcher *)mediaFetcher
{
    if (!_mediaFetcher) {
        _mediaFetcher = [[NIMKitMediaFetcher alloc] init];
        _mediaFetcher.limit = 1;
        _mediaFetcher.mediaTypes = @[(NSString *)kUTTypeImage];
    }
    return _mediaFetcher;
}

- (void)setUpNav
{
    UIButton *infoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoBtn addTarget:self action:@selector(onTouchUpInfoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [infoBtn setTitle:@"备注" forState:UIControlStateNormal];
    [infoBtn sizeToFit];
    [infoBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    UIBarButtonItem *enterUInfoItem = [[UIBarButtonItem alloc] initWithCustomView:infoBtn];
    
    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [historyBtn addTarget:self action:@selector(enterHistory:) forControlEvents:UIControlEventTouchUpInside];
    [historyBtn setImage:[UIImage imageNamed:@"icon_history_normal"] forState:UIControlStateNormal];
    [historyBtn setImage:[UIImage imageNamed:@"icon_history_pressed"] forState:UIControlStateHighlighted];
    [historyBtn sizeToFit];

    self.navigationItem.rightBarButtonItems = @[enterUInfoItem];
}

- (BOOL)shouldAutorotate
{
    return !self.currentSingleSnapView;
}

@end
