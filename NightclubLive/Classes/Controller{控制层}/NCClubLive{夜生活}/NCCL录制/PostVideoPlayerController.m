//
//  PostVideoPlayerController.m
//  MKCustomCamera
//
//  Created by ykh on 16/1/6.
//  Copyright © 2016年 MK. All rights reserved.
//  完善信息

#import "PostVideoPlayerController.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DynamicUploadSuccessView.h"

#import "TipsView.h"
#import "UIButton+WebCache.h"
#import "PaiPaiPostVideoViewModel.h"

#import "LimitInput.h"
#import "VideoTool.h"
#import "XLPhotoBrowser.h"
#import "LocationTool.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "NCPlayVideoViewController.h"
#import "AuthVideoViewController.h"
#import "BlocksKit+UIKit.h"


@interface PostVideoPlayerController()
{
    AVPlayer *_player;
    AVPlayerItem *_playItem;
    AVPlayerLayer *_playerLayer;
    AVPlayerLayer *_fullPlayer;
    BOOL _isPlaying;
}

@property (weak, nonatomic) IBOutlet UIImageView *coverIamgeV;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UITextField *contentTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *addressNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIView *videoContentView;

@property (nonatomic, strong) PaiPaiPostVideoViewModel *viewModel;
@property (nonatomic, strong) NSDictionary  *locationDic;

@end

@implementation PostVideoPlayerController

@dynamic viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    [_contentTextFiled setValue:@20 forKey:@"limit"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:KGetImage(@"icon_backwhite") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.saveBtn.enabled = YES;
    });
    
    RAC(self.viewModel, content) = self.contentTextFiled.rac_textSignal;
    [self setupCommentListArray];
    [self setupUploadBtn];
    [self setupCommitRequest];
    [self setupCoverImage];

    // 获取当前定位
    [self getLocaltion];
    [self setupLocalSwitch];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.fd_interactivePopDisabled = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:)name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.fd_interactivePopDisabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        
    }

    [_player pause];
    _player = nil;
    
    [KNotificationCenter removeObserver:self];
}

- (void)setupCoverImage
{
    dispatch_queue_t globleQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globleQueue, ^
                   {
                       [_coverIamgeV autoAdjustWidth];
                       
                       // 获取视频第一针然后
                       VideoTool *tool = [[VideoTool alloc] initWithURL:self.viewModel.videoUrl];
                       tool.sourceType = self.sourceType;
                       UIImage *image = [tool atTime:0];
                       dispatch_async(dispatch_get_main_queue(), ^{
                           if (image)
                           {
                               self.viewModel.imageArr = @[image];
                               _coverIamgeV.image = self.viewModel.imageArr[0];
                           }
                       });
                   });
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupCommitRequest
{
    [self.viewModel.commintReuqesCommand.executing subscribeNext:^(NSNumber *executing) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (executing.boolValue) {
                ShowLoading
            } else {
                CloseLoading
            }
        });
    }];
}

- (void)setupUploadBtn
{
    @weakify(self);
    [[_uploadBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.viewModel.content.length == 0){
            [self.view makeToast:@"请输入标题" duration:1 position:CSToastPositionCenter];
        }
        else  if ( self.viewModel.content.length > 15) {
            [self.view makeToast:@"请输入正确的标题(15个字以内)" duration:1 position:CSToastPositionCenter];
            return ;
        }else if(self.viewModel.imageArr.count==0){
            [self.view makeToast:@"请编辑封面" duration:1 position:CSToastPositionCenter];
            return ;
        }
        
        self.viewModel.address = self.addressNameLabel.text;
        [self.viewModel.commintReuqesCommand execute:nil];
        
    }];
}

- (void)setupCommentListArray
{
    @weakify(self);
    [self.viewModel.commintReuqesCommand.executionSignals.switchToLatest subscribeNext:^(ResponseState *state) {
        @strongify(self);
        if (state.isSuccess)
        {
            NSNotification *notification =[NSNotification notificationWithName:NOTIFICATION_SLPAIPAILIST object:nil userInfo:nil];
            //通过通知中心发送行程开始通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
             
            [ self.navigationController popToRootViewControllerAnimated:YES];
            
            [self dismissViewControllerAnimated:YES completion:^
            {
                DynamicUploadSuccessView *view = [DynamicUploadSuccessView dynamicUploadSuccessView];
                view.titleLable.text = @"你的作品已经成功上传";
                [view show];
                NSLog(@"%@",self.videoUrl);
            }];
        }else{
            [SharedAppDelegate.window makeToast:@"上传失败" duration:2 position:CSToastPositionCenter];
            
        }
    }];
}

- (void)getLocaltion
{
    @weakify(self);
    [[LocationTool shareTool] startLocationFinish:^(NSDictionary *locations) {
        @strongify(self);
        _addressNameLabel.text = locations[LocationAddress];
        self.locationDic = locations;
    } withErrorBlock:^(NSString *error) {
        
    }];
}

- (void)setupLocalSwitch
{
    @weakify(self);
    [_locationSwitch bk_addEventHandler:^(UISwitch * sender) {
        @strongify(self);
        if (sender.on)
            self.addressNameLabel.text = self.locationDic[LocationAddress];
        
        else
            self.addressNameLabel.text = nil;
    } forControlEvents:UIControlEventValueChanged];
}

- (void)back
{
    TipsView *view = [TipsView tipsView];
    [view.doneBtn setTitle:@"点错了" forState:UIControlStateNormal];
    [view.oneBtn setTitle:@"是的" forState:UIControlStateNormal];
    view.titleLable.text = @"是否取消编辑";
    [view show];
    [[view.doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [view removeFromSuperview];
    }];
    
    [[view.oneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self dismiss];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        [view removeFromSuperview];

    }];
}

-(void)playbackFinished:(NSNotification *)notification
{
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}

#pragma mark 保存压缩
- (NSURL *)compressedURL
{
    return [NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"compressed.mp4"]]];
}

- (CGFloat)fileSize:(NSURL *)path
{
    return [[NSData dataWithContentsOfURL:path] length]/1024.00 /1024.00;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)showImageClick:(id)sender
{
//    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:self.viewModel.videoUrl];
//    NCPlayVideoViewController *vc = [[NCPlayVideoViewController alloc]init];
//    vc.playerItem = item;
//    [self.navigationController pushViewController:vc animated:YES];
    
    AuthVideoViewController *authVideoVC = [AuthVideoViewController initSBWithSBName:@"AuthVideoSB"];
    authVideoVC.coverImage = [NSString imageFromeArray:self.viewModel.imageArr index:0];
    authVideoVC.videoURL = self.viewModel.videoUrl;
    [self.navigationController pushViewController:authVideoVC animated:YES];

}

@end


