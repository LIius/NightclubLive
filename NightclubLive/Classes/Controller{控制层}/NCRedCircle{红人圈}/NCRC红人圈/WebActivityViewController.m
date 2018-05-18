//
//  WebActivityViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/6/22.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "WebActivityViewController.h"
#import "WebViewJavascriptBridge.h"
#import "UpLoadVideoVC.h"
#import "PaiPaiPostVideoViewModel.h"
#import "PostVideoPlayerController.h"
#import "ReleaseDynamicVC.h"
#import "PaiPaiViewModel.h"
#import "VideoVC.h"
#import "VideoTool.h"
#import "ConvertTool.h"
#import "NetRedCircleRequest.h"
#import "MineRequest.h"
#import "BaseTabBarController.h"
#import "UserInfoViewController.h"
#import "PaiPaiUpload.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

static NSString * const ReleaseVideo = @"video";
static NSString * const ReleaseDynamic = @"dynamic";
static NSString * const ReleaseVoice = @"voice";
static NSString * const SendGift = @"gift";
static NSString * const Appointment = @"appointment";
static NSString * const DownOrder = @"order";

@interface WebActivityViewController ()<AXWebViewControllerDelegate>

@property (nonatomic, strong) WebViewJavascriptBridge *bridge;/** js桥接 */
@property (nonatomic, strong) PaiPaiViewModel *viewmodel;/** paopaimode */
@property (nonatomic, strong) id charamRankList;/** 魅力榜 */
@property (nonatomic, strong) id theRichRankList;/** 富豪榜 */
@property (nonatomic, strong) PaiPaiUpload  *paipaiUpload;

@end

@implementation WebActivityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTitleView];
    
    self.delegate = self;
    self.showsBackgroundLabel = NO;
    self.showsToolBar = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupBridge];
     [self registerHandler];
     [self setupRequest];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupTitleView
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor whiteColor]; // Your color here
    label.text =  @"";
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = label;
}

- (void)setupBridge
{
    // 设置能够进行桥接
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
}

- (void)setupRequest
{
    if (!_bridge) {
        return;
    }
    
    ObjectRequest *theRichR  = [AcitvityTheRichListRequest new];
    kWeakSelf(theRichR);
    [theRichR startRequestWithCompleted:^(ResponseState *state) {
        
        [_bridge callHandler:@"daifug" data:weaktheRichR.responseData responseCallback:nil];
        _theRichRankList = weaktheRichR.responseData;
        
    }];
    
    ObjectRequest *charamR = [AcitvityCharamListRequest new];
    kWeakSelf(charamR);
    [charamR startRequestWithCompleted:^(ResponseState *state)
     {
         [_bridge callHandler:@"charm" data:weakcharamR.responseData  responseCallback:nil];
         _charamRankList = weakcharamR.responseData;
     }];
    
    ObjectRequest *personR = [PersonRankListRequest new];
    kWeakSelf(personR);
    personR.model = CurrentUser.userID;
    [personR startRequestWithCompleted:^(ResponseState *state)
     {
         [_bridge callHandler:@"user" data:weakpersonR.responseData responseCallback:nil];
     }];
}

/**
 *  注册事件{网页内点击事件}
 */
- (void)registerHandler
{
    if (!_bridge) {
        return;
    }
    
    @weakify(self);
    
    //发布视频
    [_bridge registerHandler:ReleaseVideo handler:^(id data, WVJBResponseCallback responseCallback)
    {
        UpLoadVideoVC *uploadVC = [UpLoadVideoVC controllerWithViewModel:nil andSbName:@"CLPaiPaiSB"];
        @strongify(self);
        uploadVC.calkBlock = ^(NSNumber *type) {
            @strongify(self);
            NSInteger t = [type intValue];
            self.paipaiUpload = [[PaiPaiUpload alloc] init];
            self.paipaiUpload.completionBlock = ^(NSURL *url)
            {
                @strongify(self);
                [self uploadVideToServer:url withVideo:@"MP4" withType:0];
            };
            
            [self.paipaiUpload selectVideoSourceWithType:t sourceVC:self];
        };
        [self presentViewController:uploadVC animated:YES completion:nil];
    }];
    
    //发布动态
    [_bridge registerHandler:ReleaseDynamic handler:^(id data, WVJBResponseCallback responseCallback)
    {
        @strongify(self);
        ReleaseDynamicVC *vc = [ReleaseDynamicVC initSBWithSBName:@"CCReleaseDynamic"];
        
        [self.navigationController pushViewController:vc animated:YES];

    }];
    
    //发布心声
    [_bridge registerHandler:ReleaseVoice handler:^(id data, WVJBResponseCallback responseCallback)
    {
        @strongify(self);
        BaseTabBarController *tab = (BaseTabBarController *)ShareWindow.rootViewController;
        
        tab.selectedIndex = 1;
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SWITCHHEAERT object:nil];
    }];
    
    
    //送礼物
    [_bridge registerHandler:@"gift" handler:^(id data, WVJBResponseCallback responseCallback)
    {
        @strongify(self);
        BaseTabBarController *tab = (BaseTabBarController *)ShareWindow.rootViewController;
        
        tab.selectedIndex = 1;
        [self.navigationController popToRootViewControllerAnimated:YES];
     }];
    
    //约台
    [_bridge registerHandler:@"about" handler:^(id data, WVJBResponseCallback responseCallback)
    {
        @strongify(self);
        BaseTabBarController *tab = (BaseTabBarController *)ShareWindow.rootViewController;
        
        tab.selectedIndex = 1;
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }];
    
    //下单
    [_bridge registerHandler:DownOrder handler:^(id data, WVJBResponseCallback responseCallback)
    {
        @strongify(self);
        [self.navigationController pushViewController:ViewController(@"AllBarListSB", @"AllBarListViewController") animated:YES];
    }];
    
    //查看更多
    [_bridge registerHandler:@"more" handler:^(id data, WVJBResponseCallback responseCallback)
    {
        
    }];
    
    //进入个人主要
    [_bridge registerHandler:@"index" handler:^(NSDictionary *data, WVJBResponseCallback responseCallback)
    {
        @strongify(self);
        [self jumpUserInfoWithID:data[@"user_id"]];
        
    }];
    
    [_bridge registerHandler:@"myseft" handler:^(id data, WVJBResponseCallback responseCallback)
    {
        @strongify(self);
        [self jumpUserInfoWithID:data[@"user_id"]];
    }];

}


- (void)jumpUserInfoWithID:(NSString *)userID
{
    UserInfoViewController *infoVC = ViewController(@"UserInfoSB", @"UserInfoViewController");

    User *user = [User new];
    user.userId = userID;
    infoVC.userModel = user;
    
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)uploadVideToServer:(NSURL *)videoURL withVideo:(NSString *)typeString withType:(NSInteger)type
{
    PaiPaiPostVideoViewModel *viewModel = [[PaiPaiPostVideoViewModel alloc] init];
    viewModel.videoUrl = videoURL;
    PostVideoPlayerController *vc = [PostVideoPlayerController controllerWithViewModel:viewModel andSbName:@"CLPostVideoSB"];
    vc.sourceType = type;
    vc.fd_interactivePopDisabled = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - AXWebView Controller Delegate

- (void)webViewControllerWillGoBack:(AXWebViewController *)webViewController{
}

- (void)webViewControllerWillGoForward:(AXWebViewController *)webViewController{
}

- (void)webViewControllerWillReload:(AXWebViewController *)webViewController{
}

- (void)webViewControllerWillStop:(AXWebViewController *)webViewController{
}

- (void)webViewControllerDidFinishLoad:(AXWebViewController *)webViewController
{
    [_bridge callHandler:@"All_Charm" data:_charamRankList responseCallback:nil];
    [_bridge callHandler:@"All_Daifug" data:_theRichRankList responseCallback:nil];
}

- (void)webViewController:(AXWebViewController *)webViewController didFailLoadWithError:(NSError *)error{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
