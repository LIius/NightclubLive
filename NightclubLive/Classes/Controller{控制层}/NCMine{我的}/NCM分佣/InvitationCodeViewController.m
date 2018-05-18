//
//  InvitationCodeViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//  Edit by cr

#import "InvitationCodeViewController.h"
#import "ShareView.h"
#import "OpenShareHeader.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "BlocksKit+UIKit.h"
@interface InvitationCodeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *ivBtn;

@property (weak, nonatomic) IBOutlet UILabel *inviteCodeLabel;
@end

@implementation InvitationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

 
    UITapGestureRecognizer *tap = [[ UITapGestureRecognizer alloc ] initWithTarget:self action:@selector ( clickView )];
    [ self.ivBtn addGestureRecognizer: tap ];
    _inviteCodeLabel.text = [NSString stringWithFormat:@"邀请码：%@",CurrentUser.user.userInvitationCode];
}
- (void)clickView{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[ShareView shareView] dismissMaskView];
}

- (IBAction)copyInvationClick:(id)sender
{
    [UIPasteboard generalPasteboard].string = CurrentUser.user.userInvitationCode;
    ShowSuccess(@"复制成功");
}

- (IBAction)invateFriendClick:(id)sender
{
    
}

- (void)inv{
    @weakify(self);
    ShareView *shareV =  [ShareView shareView];
    [shareV setUP];
    [shareV showMaskView];
    
    // 分享到朋友圈
    [[shareV.pyqBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x)
     {
         @strongify(self);
         [self showInvite: SSDKPlatformSubTypeWechatTimeline];
     }];
    
    // 发给微信好友
    [[shareV.weiXinBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self showInvite:SSDKPlatformSubTypeWechatSession];
    }];
    
    // 发给QQ好友
    [[shareV.qqBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self showInvite:SSDKPlatformSubTypeQQFriend];
    }];
    
    // 分享到微博
    [[shareV.weiBoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self showInvite:SSDKPlatformTypeSinaWeibo];
    }];
}

- (OSMessage *)getMessgeContent
{
    OSMessage *message = [[OSMessage alloc] init];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日HH时mm分ss秒";
    message.title = @"夜店网请求";
    message.desc = [NSString stringWithFormat:@"我的夜店网邀请码为%@，一起加入夜店网吧：http://www.yd2019.cn",CurrentUser.user.userInvitationCode];
    message.link = @"http://www.yd2019.cn";
    return message;
}

- (void)showInvite:(SSDKPlatformType)type
{
    NSString *title = @"夜店网邀请";
    NSString *content = [NSString stringWithFormat:@"我的夜店网邀请码为%@，一起加入夜店网吧：http://www.yd2019.cn",CurrentUser.user.userInvitationCode];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:nil
                                        url:[NSURL URLWithString:@"www.yd2019.cn"]
                                      title:title
                                       type:SSDKContentTypeAuto];
    [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
    }];
}

- (IBAction)nextClick:(id)sender
{
    PushViewController(ViewController(@"MyNextSB", @"MyNextViewController"));
}

@end
