//
//  PaPaDetailVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/8.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "PaPaDetailVC.h"
#import "PaPaDetailTVC.h"
#import "ShareView.h"
#import "OpenShareHeader.h"
#import "PaiPaiDetailsViewModel.h"
#import "Comment.h"

#import "UIAlertController+Factory.h"
#import "ReportRequest.h"
#import "ReportViewController.h"
#import "PaiPaiListRequest.h"
#import "NCAlert.h"

@interface PaPaDetailVC ()

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *tf;

@property (strong, nonatomic)  UIButton *dismissView;
@property (nonatomic, strong) PaiPaiDetailsViewModel *viewModel;
@property (nonatomic, strong) PaPaDetailTVC *detailTVC;
@property (nonatomic, strong) CommentObject *comment;

@end

@implementation PaPaDetailVC

@dynamic viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];

    PaiPaiDetailsViewModel *viewModel = [[PaiPaiDetailsViewModel alloc] init];
    self.viewModel = viewModel;
    self.viewModel.model = self.model;
    [self.tf setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self setupChildVC];
    [self setupEvaluate];
    [self setupReply];
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
    PaPaDetailTVC *vc = [PaPaDetailTVC controllerWithViewModel:self.viewModel andSbName:@"PapaDetaiTSB"];
    vc.model = self.model;
    vc.superVC = self;
    self.detailTVC = vc;
    [self addChildViewController:vc];
    
    vc.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view insertSubview:vc.view belowSubview:_bottomView];
}

#pragma mark - 回复
- (void)setupReply
{
    @weakify(self);
    // 回复某一个用户
    self.commentUserBlock = ^(CommentObject *comment)
    {
        @strongify(self);
        // 获取焦点
        [self.tf becomeFirstResponder];
        // weakself.toUserID = [NSString stringWithFormat:@"%ld",comment.userId];
        self.comment = comment;
        self.tf.placeholder = [NSString stringWithFormat:@"回复%@",comment.from_user_name];
    };
}

- (void)setupEvaluate
{
    @weakify(self);
    [self.viewModel.commentCommand.executionSignals.switchToLatest subscribeNext:^(ResponseState *state) {
        @strongify(self);
        
        [self.view makeToast:state.message duration:1.0 position:CSToastPositionCenter];
        
        if (state.isSuccess)
        {
            dispatch_async(dispatch_get_main_queue(), ^
            {
                self.detailTVC.currentPage = 1;
                self.detailTVC.refreshType = RefreshTypeLoad;
                [self.detailTVC requestDataFromServer];
                self.model.dynamicCount += 1;
                [self.detailTVC reloadDataToView];
            });
            
        }
        else{
        }
        self.comment = nil;
    }];
    
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark -键盘即将跳出
-(void)didClickKeyboard:(NSNotification *)sender
{
    [self.view addSubview:self.dismissView];
    
    CGFloat durition = [sender.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    CGRect keyboardRect = [sender.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    
    [UIView animateWithDuration:durition animations:^{
        
        self.bottomView.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
    }];
}

#pragma mark -键盘即将消失
-(void)didKboardDisappear:(NSNotification *)sender
{
    CGFloat duration = [sender.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    [UIView animateWithDuration:duration animations:^
    {
        self.bottomView.transform = CGAffineTransformIdentity;

    }];
    
    self.tf.placeholder = @"请输入评论内容";
}

- (IBAction)shareAction:(id)sender
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:@[@"立即举报",@"分享"]];
    
    if ([self.model.userId isEqualToString:CurrentUser.userID]){
        [array removeAllObjects];
        [array addObject:@"删除"];
    }
    
    @weakify(self);
    [NCAlert showActionSheetWithDataSource:[array copy] blockHandel:^(NSInteger index) {
        @strongify(self);
        [self handleIndex:index];
    }];
}

- (void)handleIndex:(NSInteger)index
{
    if ([self.model.userId isEqualToString:CurrentUser.userID])
    {
        if (index == 0)
        {
            DeleteRequest *r = [DeleteRequest new];
            r.model = self.model.ID;
            [r startRequestWithCompleted:^(ResponseState *state) {
                
                if (state.isSuccess){//删除成功
                    ShowSuccess(@"删除成功");
                    //发送刷新请求
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SLPAIPAILIST object:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                }
                else
                    ShowError(@"删除失败");
            }];
            
        }
        
    }else{
        if (index == 0){
            
            [NCAlert showActionSheetWithDataSource:SelectDataForKey(@"Report") blockHandel:^(NSInteger index) {
                ReportViewController *reportVC = [ReportViewController initSBWithSBName:@"ReportSB"];
                reportVC.subjectTypeId = 5;
                reportVC.subjectId = self.model.ID;
                reportVC.reportType = index + 1;
                PushViewController(reportVC);
            }];
        }
        else if (index == 1){
            
            ShareView *view = [ShareView shareView];
            [view setUP];
            
            // 分享到朋友圈
            [[view.pyqBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                [self pyqClick];
            }];
            
            // 发给微信好友
            [[view.weiXinBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                [self wxFriendClick];
                
            }];
            
            // 发给QQ好友
            [[view.qqBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                [self qqFriend];
                
            }];
            // 分享到微博
            [[view.weiBoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                [self sinaWBClick];
                
            }];
            
            view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 105);
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            [window addSubview:view];
            
            [UIView animateWithDuration:0.5 animations:^{
                view.frame=CGRectMake(0, SCREEN_HEIGHT-105, SCREEN_WIDTH, 105);
            }];
            
        }
        
    }
}

#pragma mark - 发送评论coderiding
- (IBAction)sendClick:(id)sender
{
    NSString *msg = self.tf.text;
    if (msg.length <= 0)
    {
        [self.view makeToast:@"请输入评论内容" duration:1.0 position:CSToastPositionCenter];
    }else{
        
        self.viewModel.message = msg;
        
        if (self.comment)
        {
            self.viewModel.subjectId = self.comment.subjectId;
            self.viewModel.toUser    = [NSString stringWithFormat:@"%ld",self.comment.userId];
            self.viewModel.replayType = 1;
        }else{
            self.viewModel.subjectId = self.model.ID;
            self.viewModel.toUser = self.model.user.ID;
            self.viewModel.replayType = 0;
        }
        
        [self.viewModel.commentCommand execute:nil];
        
        self.tf.text = nil;
        [self.view endEditing:YES];
    }
}


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
