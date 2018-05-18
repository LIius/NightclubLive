//
//  NIMSessionViewController.m
//  NIMKit
//
//  Created by NetEase.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//  会话--父类

#import "NIMSessionConfigurateProtocol.h"
#import "NIMInputTextView.h"
#import "NIMKit.h"
#import "NIMMessageCellProtocol.h"
#import "NIMMessageModel.h"
#import "NIMKitUtil.h"
#import "NIMCustomLeftBarView.h"
#import "NIMBadgeView.h"
#import "UITableView+NIMScrollToBottom.h"
#import "NIMMessageMaker.h"
#import "NIMKitUIConfig.h"
#import "UIView+NIM.h"
#import "NIMSessionConfigurator.h"
#import "ChatGiftTipView.h"
#import "NTESChartletAttachment.h"
#import "NTESSessionMsgConverter.h"
#import "GiftView.h"
#import "GiftCountAlertView.h"
#import "GiftTool.h"

@interface NIMSessionViewController ()<NIMMediaManagerDelgate,NIMInputDelegate>

@property (nonatomic,readwrite) NIMMessage *messageForMenu;

@property (nonatomic,strong)    NSIndexPath *lastVisibleIndexPathBeforeRotation;

@property (nonatomic,strong)  NIMSessionConfigurator *configurator;

@property (nonatomic,weak)    id<NIMSessionInteractor> interactor;

/** 礼物提示 */
@property (nonatomic, strong) ChatGiftTipView *giftTipView;

@end

@implementation NIMSessionViewController

- (instancetype)initWithSession:(NIMSession *)session{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _session = session;
    }
    return self;
}

- (void)dealloc
{
    [self removeListener];

    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航栏
    [self setupNav];
    //消息 tableView
    [self setupTableView];
    //下拉刷新 refreshControl
    [self setupRefreshControl];
    //会话相关逻辑配置器安装
    [self setupConfigurator];
    //添加监听
    [self addListener];
    
    //进入会话时，标记所有消息已读，并发送已读回执
    [[NIMSDK sharedSDK].conversationManager markAllMessagesReadInSession:self.session];
    [self sendMessageReceipt:self.interactor.items];
    
    //清楚读取消息
    [UIApplication sharedApplication].applicationIconBadgeNumber -= self.interactor.items.count;
    
    //更新已读位置
    [self uiCheckReceipt];
    
    if (![self.session.sessionId isEqualToString:@"礼物管家"])
    {
        [self.view addSubview:self.giftTipView];
        
        [self.view bringSubviewToFront:self.giftTipView];
        
        [self.giftTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.view);
            make.height.mas_equalTo(32);
            make.top.and.left.equalTo(self.view).offset(0);
        }];
        //输入框 inputView
        [self setupInputView];

    }
}

- (void)setupNav
{
////    self.navigationItem.title =  [NIMKitUtil showNick:self.session.sessionId inSession:self.session];
////    self.title = self.navigationItem.title;
    
    //返回键coderiding{与自定义的返回键重复}
    //NIMCustomLeftBarView *leftBarView = [[NIMCustomLeftBarView alloc] init];
    //UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarView];
    //self.navigationItem.leftBarButtonItem = leftItem;
    //self.navigationItem.leftItemsSupplementBackButton = YES;
    
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.frame = CGRectMake(0, 0, self.view.width * 0.5, 42);
    navTitle.text =  [NIMKitUtil showNick:self.session.sessionId inSession:self.session];
    navTitle.textAlignment = NSTextAlignmentCenter;
    navTitle.textColor = [UIColor whiteColor];

    self.navigationItem.titleView = navTitle;
}

- (void)setupTableView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBCOLOR(240, 240, 240);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // 兼容iOS11计算contenSize不准
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    [self.view addSubview:self.tableView];
}

- (void)setupInputView
{
    CGRect inputViewRect = CGRectMake(0, 0, self.view.nim_width, [[[NIMKitUIConfig sharedConfig] globalConfig] topInputViewHeight]);
    BOOL disableInputView = NO;
    if ([self.sessionConfig respondsToSelector:@selector(disableInputView)]) {
        disableInputView = [self.sessionConfig disableInputView];
    }
    if (!disableInputView) {
        self.sessionInputView = [[NIMInputView alloc] initWithFrame:inputViewRect];
        self.sessionInputView.nim_bottom = self.view.height;
      //  self.sessionInputView.y = self.view.height - self.sessionInputView.height;
        [self.sessionInputView setInputConfig:self.sessionConfig];
        [self.sessionInputView setInputDelegate:self];
        [self.sessionInputView setInputActionDelegate:self];
        [self.view addSubview:_sessionInputView];
        
        self.tableView.nim_height -= self.sessionInputView.nim_height;
    }
}

- (void)setupRefreshControl
{
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.tableView addSubview:_refreshControl];
    [self.refreshControl addTarget:self action:@selector(headerRereshing:) forControlEvents:UIControlEventValueChanged];
}

- (void)setupConfigurator
{
    _configurator = [[NIMSessionConfigurator alloc] init];
    [_configurator setup:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // fix bug: 竖屏进入会话界面，然后右上角进入群信息，再横屏，左上角返回，横屏的会话界面显示的就是竖屏时的大小
    [self.interactor cleanCache];
    [self.tableView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.sessionInputView endEditing:YES];
}

- (void)viewDidLayoutSubviews{
    [self changeLeftBarBadge:self.conversationManager.allUnreadCount];
    [self.interactor resetLayout];
}

- (void)headerRereshing:(id)sender
{
    __weak typeof(self) wself = self;
    [self.interactor loadMessages:^(NSArray *messages, NSError *error) {
        [wself.refreshControl endRefreshing];
        if (messages.count) {
            [wself uiCheckReceipt];
        }
    }];
}

#pragma mark - 消息收发接口
- (void)sendMessage:(NIMMessage *)message
{
    message.apnsContent = @"给你发送了一条消息";
    [self.interactor sendMessage:message];
}

#pragma mark - Touch Event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [_sessionInputView endEditing:YES];
}

#pragma mark - NIMSessionConfiguratorDelegate
- (void)didFetchMessageData
{
    [self uiCheckReceipt];
    [self.tableView reloadData];
    [self.tableView nim_scrollToBottom:NO];
}

- (void)didRefreshMessageData
{
 //   self.navigationItem.title = [self sessionTitle];
    [self.tableView reloadData];
}

#pragma mark - 会话title
- (NSString *)sessionTitle
{
    NSString *title = @"";
    NIMSessionType type = self.session.sessionType;
    switch (type) {
        case NIMSessionTypeTeam:{
            NIMTeam *team = [[[NIMSDK sharedSDK] teamManager] teamById:self.session.sessionId];
            title = [NSString stringWithFormat:@"%@(%zd)",[team teamName],[team memberNumber]];
        }
            break;
        case NIMSessionTypeP2P:{
            title = [NIMKitUtil showNick:self.session.sessionId inSession:self.session];
        }
            break;
        default:
            break;
    }
    return title;
}

#pragma mark - NIMChatManagerDelegate
- (void)willSendMessage:(NIMMessage *)message
{
    id<NIMSessionInteractor> interactor = self.interactor;
    
    if ([message.session isEqual:self.session]) {
        if ([interactor findMessageModel:message]) {
            [interactor updateMessage:message];
        }else{
            [interactor addMessages:@[message]];
        }
    }
}

//发送结果
- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error
{
    if ([message.session isEqual:_session]) {
        [self.interactor updateMessage:message];
    }
}

//发送进度
-(void)sendMessage:(NIMMessage *)message progress:(CGFloat)progress
{
    if ([message.session isEqual:_session]) {
        [self.interactor updateMessage:message];
    }
}

//接收消息
- (void)onRecvMessages:(NSArray *)messages
{
    NIMMessage *message = messages.firstObject;
    NIMSession *session = message.session;
    if (![session isEqual:self.session] || !messages.count){
        return;
    }
    
    [self uiAddMessages:messages];
    [self sendMessageReceipt:messages];
    
    [self.conversationManager markAllMessagesReadInSession:self.session];
}


- (void)fetchMessageAttachment:(NIMMessage *)message progress:(CGFloat)progress
{
    if ([message.session isEqual:_session]) {
        [self.interactor updateMessage:message];
    }
}

- (void)fetchMessageAttachment:(NIMMessage *)message didCompleteWithError:(NSError *)error
{
    if ([message.session isEqual:_session]) {
        NIMMessageModel *model = [self.interactor findMessageModel:message];
        //下完缩略图之后，因为比例有变化，重新刷下宽高。
        [model calculateContent:self.tableView.frame.size.width force:YES];
        [self.interactor updateMessage:message];
    }
}

- (void)onRecvMessageReceipt:(NIMMessageReceipt *)receipt
{
    if ([receipt.session isEqual:self.session] && [self shouldHandleReceipt]) {
        [self uiCheckReceipt];
    }
}


#pragma mark - NIMConversationManagerDelegate
- (void)messagesDeletedInSession:(NIMSession *)session{
    [self.interactor resetMessages];
    [self.tableView reloadData];
}

- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount{
    [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
}

- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
    [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount{
    [self changeUnreadCount:recentSession totalUnreadCount:totalUnreadCount];
}


- (void)changeUnreadCount:(NIMRecentSession *)recentSession
         totalUnreadCount:(NSInteger)totalUnreadCount{
    if ([recentSession.session isEqual:self.session]) {
        return;
    }
    [self changeLeftBarBadge:totalUnreadCount];
}

#pragma mark - 录音相关接口
- (void)onRecordFailed:(NSError *)error{}

- (BOOL)recordFileCanBeSend:(NSString *)filepath
{
    return YES;
}

- (void)showRecordFileNotSendReason{}

#pragma mark - NIMInputDelegate
- (void)showInputView
{
    [self.tableView setUserInteractionEnabled:NO];
}

- (void)hideInputView
{
    [self.tableView setUserInteractionEnabled:YES];
}

- (void)inputViewSizeToHeight:(CGFloat)height showInputView:(BOOL)show
{
    [self.tableView setUserInteractionEnabled:!show];
    [self.interactor changeLayout:height];
}

#pragma mark - NIMInputActionDelegate
- (BOOL)onTapMediaItem:(NIMMediaItem *)item{
    SEL sel = item.selctor;
    BOOL handled = sel && [self respondsToSelector:sel];
    if (handled) {
        NIMKit_SuppressPerformSelectorLeakWarning([self performSelector:sel withObject:item]);
        handled = YES;
    }
    return handled;
}

- (void)onTextChanged:(id)sender{}

- (void)onSendText:(NSString *)text
{
    NIMMessage *message = [NIMMessageMaker msgWithText:text];
    [self sendMessage:message];
}

- (void)onSelectChartlet:(NSString *)chartletId catalog:(NSString *)catalogId{
    
    NTESChartletAttachment *attachment = [[NTESChartletAttachment alloc] init];
    attachment.chartletId = chartletId;
    attachment.chartletCatalog = catalogId;
    [self sendMessage:[NTESSessionMsgConverter msgWithChartletAttachment:attachment]];
}

- (void)onTapAvatar:(NSString *)userId{
    
}

- (void)onCancelRecording
{
    [[NIMSDK sharedSDK].mediaManager cancelRecord];
    
    _sessionInputView.recording = NO;
}

- (void)onStopRecording
{
    [[NIMSDK sharedSDK].mediaManager stopRecord];
    
    _sessionInputView.recording = NO;
}

- (void)onStartRecording
{
    _sessionInputView.recording = YES;
    
    NIMAudioType type = NIMAudioTypeAAC;
    if ([self.sessionConfig respondsToSelector:@selector(recordType)])
    {
        type = [self.sessionConfig recordType];
    }
    
    NSTimeInterval duration = [NIMKitUIConfig sharedConfig].globalConfig.recordMaxDuration;
    
    [[[NIMSDK sharedSDK] mediaManager] addDelegate:self];
    
    [[[NIMSDK sharedSDK] mediaManager] record:type
                                     duration:duration];
}

- (void)recordAudio:(NSString *)filePath didCompletedWithError:(NSError *)error
{
    //发语音
    if (!error){
        NIMAudioObject *audioObject = [[NIMAudioObject alloc] initWithSourcePath:filePath];
        NIMMessage *message        = [[NIMMessage alloc] init];
        message.messageObject      = audioObject;
        
        [self sendMessage:message];
    }
}

- (void)recordAudioProgress:(NSTimeInterval)currentTime
{
    //改变界面进度
    [self.sessionInputView updateAudioRecordTime:currentTime];
}

#pragma mark - CellActionDelegate
- (void)onTapCell:(NIMKitEvent *)message{}

- (void)onRetryMessage:(NIMMessage *)message
{
    if (message.isReceivedMsg) {
        [[[NIMSDK sharedSDK] chatManager] fetchMessageAttachment:message
                                                           error:nil];
    }else{
        [[[NIMSDK sharedSDK] chatManager] resendMessage:message
                                                  error:nil];
    }
}

- (void)onLongPressCell:(NIMMessage *)message
                 inView:(UIView *)view
{
    NSArray *items = [self menusItems:message];
    if ([items count] && [self becomeFirstResponder]) {
        UIMenuController *controller = [UIMenuController sharedMenuController];
        controller.menuItems = items;
        _messageForMenu = message;
        [controller setTargetRect:view.bounds inView:view];
        [controller setMenuVisible:YES animated:YES];
        
    }
}

#pragma mark - 配置项
- (id<NIMSessionConfig>)sessionConfig
{
    return nil;
}

#pragma mark - 菜单
- (NSArray *)menusItems:(NIMMessage *)message
{
    NSMutableArray *items = [NSMutableArray array];
    
    if (message.messageType == NIMMessageTypeText) {
        [items addObject:[[UIMenuItem alloc] initWithTitle:@"复制"
                                                    action:@selector(copyText:)]];
    }
    [items addObject:[[UIMenuItem alloc] initWithTitle:@"删除"
                                                action:@selector(deleteMsg:)]];
    return items;
    
}

- (NIMMessage *)messageForMenu
{
    return _messageForMenu;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    NSArray *items = [[UIMenuController sharedMenuController] menuItems];
    for (UIMenuItem *item in items) {
        if (action == [item action]){
            return YES;
        }
    }
    return NO;
}


- (void)copyText:(id)sender
{
    NIMMessage *message = [self messageForMenu];
    if (message.text.length) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:message.text];
    }
}

- (void)deleteMsg:(id)sender
{
    NIMMessage *message    = [self messageForMenu];
    [self uiDeleteMessage:message];
    [self.conversationManager deleteMessage:message];
}

- (void)menuDidHide:(NSNotification *)notification
{
    [UIMenuController sharedMenuController].menuItems = nil;
}


#pragma mark - 操作接口
- (void)uiAddMessages:(NSArray *)messages
{
    [self.interactor addMessages:messages];
}


- (NIMMessageModel *)uiDeleteMessage:(NIMMessage *)message{
    NIMMessageModel *model = [self.interactor deleteMessage:message];
    if (model.shouldShowReadLabel)
    {
        [self uiCheckReceipt];
    }
    return model;
}

- (void)uiUpdateMessage:(NIMMessage *)message{
    [self.interactor updateMessage:message];
}

- (void)uiCheckReceipt
{
    if ([self shouldHandleReceipt]) {
        [self.interactor checkReceipt];
    }
}

#pragma mark - NIMMeidaButton
#pragma mark - 相册
- (void)onTapMediaItemPicture:(NIMMediaItem *)item
{
    [self.interactor mediaPicturePressed];
}

#pragma mark - 拍照
- (void)onTapMediaItemShoot:(NIMMediaItem *)item
{
    [self.interactor mediaShootPressed];
}

#pragma mark - 位置
- (void)onTapMediaItemLocation:(NIMMediaItem *)item
{
    [self.interactor mediaLocationPressed];
}

#pragma mark - 送礼物
- (void)onTapItemGift:(NIMMediaItem *)item
{
    // 送礼
    GiftTool *tool = [GiftTool defaultGiftTool];
    tool.giftType = 6;
    tool.projectID = 0;
    tool.phoneNum = self.session.sessionId;
 //   tool.pushVC = self;
    [tool showGiftView];
    
    tool.giftBlock = ^(NSString *giftName){
        
        //送礼提示
        //2.发送通知
        NIMMessage *message = [[NIMMessage alloc] init];
        message.text    = [NSString stringWithFormat:@"Ta给你送了%@",giftName];
        [self sendMessage:message];

        
    };

}

#pragma mark - 旋转处理 (iOS8 or above)
- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    self.lastVisibleIndexPathBeforeRotation = [self.tableView indexPathsForVisibleRows].lastObject;
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    if (self.view.window) {
        __weak typeof(self) wself = self;
        [coordinator animateAlongsideTransition:^(id <UIViewControllerTransitionCoordinatorContext> context)
         {
             [[NIMSDK sharedSDK].mediaManager cancelRecord];
             [wself.interactor cleanCache];
             [wself.tableView reloadData];
             [wself.tableView scrollToRowAtIndexPath:wself.lastVisibleIndexPathBeforeRotation atScrollPosition:UITableViewScrollPositionBottom animated:NO];
         } completion:nil];
    }
}

#pragma mark - 已读回执
- (void)sendMessageReceipt:(NSArray *)messages
{
    if ([self shouldHandleReceipt]) {
        [self.interactor sendMessageReceipt:messages];
    }
}

#pragma mark - Private
- (void)addListener
{
    if (![self.sessionConfig respondsToSelector:@selector(disableReceiveNewMessages)]
        || ![self.sessionConfig disableReceiveNewMessages]) {
        [[NIMSDK sharedSDK].chatManager addDelegate:self];
    }
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
}

- (void)removeListener
{
    [[NIMSDK sharedSDK].chatManager removeDelegate:self];
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
}

- (void)changeLeftBarBadge:(NSInteger)unreadCount
{
    NIMCustomLeftBarView *leftBarView = (NIMCustomLeftBarView *)self.navigationItem.leftBarButtonItem.customView;
    leftBarView.badgeView.badgeValue = @(unreadCount).stringValue;
    leftBarView.badgeView.hidden = !unreadCount;
}

- (BOOL)shouldHandleReceipt
{
    return self.session.sessionType == NIMSessionTypeP2P &&
    [self.sessionConfig respondsToSelector:@selector(shouldHandleReceipt)] &&
    [self.sessionConfig shouldHandleReceipt];
}

- (id<NIMConversationManager>)conversationManager
{
    switch (self.session.sessionType)
    {
        case NIMSessionTypeChatroom:
            return nil;
            break;
        case NIMSessionTypeP2P:
        case NIMSessionTypeTeam:
        default:
            return [NIMSDK sharedSDK].conversationManager;
    }
}

#pragma mark - Getter
- (ChatGiftTipView *)giftTipView
{
    
    if (!_giftTipView){
        
        _giftTipView = [ChatGiftTipView tipView];

    }
    return _giftTipView;
}

@end

