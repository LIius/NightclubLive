//
//  NTESSessionListViewController.m
//  NIMDemo
//
//  Created by chris on 15/2/2.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESSessionListViewController.h"
#import "NTESSessionViewController.h"
#import "UIView+NTES.h"
#import "NTESBundleSetting.h"
#import "NTESListHeader.h"
#import "NTESClientsTableViewController.h"
#import "FindFriendViewController.h"
#import "EmptyBigView.h"
#import "NTESSessionUtil.h"
#import "CommentListViewController.h"
#import "XHPopMenu.h"
#import "XHPopMenu+UnRead.h"
#import "UILabel+NavTitleView.h"
#import "BlacklistViewController.h"

#define SessionListTitle @"消息"

@interface NTESSessionListViewController ()<NIMLoginManagerDelegate,NTESListHeaderDelegate>

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) NTESListHeader *header;

@property (strong, nonatomic) XHPopMenu *popMenu;

@end

@implementation NTESSessionListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.autoRemoveRemoteSession = [[NTESBundleSetting sharedConfig] autoRemoveRemoteSession];
    }
    return self;
}

- (void)dealloc
{
    [[NIMSDK sharedSDK].loginManager removeDelegate:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [UILabel navWithTitle:@"夜信"];
    
    [[NIMSDK sharedSDK].loginManager addDelegate:self];
    
    self.header = [[NTESListHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    self.header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.header.delegate = self;
    [self.view addSubview:self.header];
}

- (void)reload
{
    [super reload];
}

- (void)onSelectedRecent:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath
{
    NIMSession *session = recent.session;
    if ([session.sessionId isEqualToString:@"评论"])
    {
        CommentListViewController *listVC = [CommentListViewController initSBWithSBName:@"CommentListSB"];
        listVC.model = session;
        [self.navigationController pushViewController:listVC animated:YES];
    }
    else{
        // 聊天+礼物管家+充值
        NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)onDeleteRecentAtIndexPath:(NIMRecentSession *)recent atIndexPath:(NSIndexPath *)indexPath
{
    [super onDeleteRecentAtIndexPath:recent atIndexPath:indexPath];
}

#pragma mark - Private
- (void)refreshSubview
{
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX   = self.navigationItem.titleView.width * .5f;
    self.tableView.top = self.header.height;
    self.tableView.height = self.view.height - self.tableView.top;
    self.header.bottom    = self.tableView.top + self.tableView.contentInset.top;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self refreshSubview];
}

- (NSString *)nameForRecentSession:(NIMRecentSession *)recent
{
    if ([recent.session.sessionId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        return @"我的电脑";
    }
    
    return [super nameForRecentSession:recent];
}

#pragma mark - SessionListHeaderDelegate
- (void)didSelectRowType:(NTESListHeaderType)type
{
    // 多人登录
    switch (type) {
        case ListHeaderTypeLoginClients:
        {
            NTESClientsTableViewController *vc = [[NTESClientsTableViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - NIMLoginManagerDelegate
- (void)onLogin:(NIMLoginStep)step
{
    [super onLogin:step];
    
//    switch (step) {
//        case NIMLoginStepLinkFailed:
//            self.title = [SessionListTitle stringByAppendingString:@"(未连接)"];
//            break;
//        case NIMLoginStepLinking:
//            self.title = [SessionListTitle stringByAppendingString:@"(连接中)"];
//            break;
//        case NIMLoginStepLinkOK:
//        case NIMLoginStepSyncOK:
//            self.title = SessionListTitle;
//            break;
//        case NIMLoginStepSyncing:
//            self.title = [SessionListTitle stringByAppendingString:@"(同步数据)"];
//            break;
//        default:
//            break;
//    }
//
//    [self.titleLabel sizeToFit];
//    self.titleLabel.centerX   = self.navigationItem.titleView.width * .5f;
//    [self.header refreshWithType:ListHeaderTypeNetStauts value:@(step)];
//    [self.view setNeedsLayout];
}

- (void)onMultiLoginClientsChanged
{
    [self.header refreshWithType:ListHeaderTypeLoginClients value:[NIMSDK sharedSDK].loginManager.currentLoginClients];
    [self.view setNeedsLayout];
}

- (NSString *)contentForRecentSession:(NIMRecentSession *)recent
{
    if (recent.lastMessage.messageType == NIMMessageTypeCustom)
    {
        NSString *text = @"";
        
        NSString *nickName = [NTESSessionUtil showNick:recent.lastMessage.from inSession:recent.lastMessage.session];
        return nickName.length ? [nickName stringByAppendingFormat:@" : %@",text] : @"";
    }
    
    return [super contentForRecentSession:recent];
}

#pragma mark - 导航栏右键
- (IBAction)showMenuOnView:(UIBarButtonItem *)sender
{
    [self.popMenu showMenuOnView:self.navigationController.view atPoint:CGPointZero];
    
    // 筛选好友申请消息
    NIMSystemNotificationFilter *filter = [NIMSystemNotificationFilter new];
    filter.notificationTypes = @[@5];
    
    NSInteger unRead = [[[NIMSDK sharedSDK] systemNotificationManager] allUnreadCount:filter];
    
    self.popMenu.unReadRow = 1;
    self.popMenu.isUnRead  = !(unRead > 0);
}

#pragma mark - Propertys
- (XHPopMenu *)popMenu
{
    if (!_popMenu) {
        NSMutableArray *popMenuItems = [NSMutableArray array];
        for (int i = 0; i < 3; i ++) {
         
            NSString *title;
            switch (i) {
                case 0: {
                    title = @"通讯录";
                    break;
                }
                case 1: {
                    title = @"添加好友";
                    break;
                }
                case 2: {
                    title = @"黑名单";
                    break;
                }
                default:
                    break;
            }
            XHPopMenuItem *popMenuItem = [[XHPopMenuItem alloc] initWithImage:nil title:title];
            [popMenuItems addObject:popMenuItem];
        }
        
        @weakify(self);
        _popMenu = [[XHPopMenu alloc] initWithMenus:popMenuItems];
        _popMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *popMenuItems)
        {
            @strongify(self);
            if (index == 0) {
                [self addressBook];
            } else if (index == 1) {
                [self searchFriends];
            } else if (index == 2) {
                [self blacklist];
            }
        };
    }
    
    return _popMenu;
}

#pragma mark - 通讯录
- (void)addressBook
{
    [self.navigationController pushViewController:ViewController(@"AddressBookSB", @"AddressBookViewController") animated:YES];
}

#pragma mark - 搜索好友
- (void)searchFriends
{
    /*UINavigationController *nav = self.navigationController;
     NIMSession *session = [NIMSession session:@"13250061261"self.userId type:NIMSessionTypeP2P];
     NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
     [nav pushViewController:vc animated:YES];
     UIViewController *root = nav.viewControllers[0];
     nav.viewControllers = @[root,vc];*/
    
    FindFriendViewController *ffVC = [FindFriendViewController initSBWithSBName:@"FindFriendSB"];
    [self.navigationController pushViewController:ffVC animated:YES];
}

#pragma mark - 黑名单
- (void)blacklist
{
    BlacklistViewController *vc = [BlacklistViewController initSBWithSBName:@"BlackListSB"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
