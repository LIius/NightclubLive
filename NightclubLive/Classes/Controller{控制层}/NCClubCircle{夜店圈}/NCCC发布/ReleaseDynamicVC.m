//
//  ReleaseDynamicVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/2.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "ReleaseDynamicVC.h"
#import "DynamicUploadSuccessView.h"
#import "ReleaseDynamicViewModel.h"
#import "LocationTool.h"
#import "QiniuTool.h"
#import "ClubCircleRequest.h"
#import "LimitInput.h"
#import "TipsView.h"

#import "CharmHUD.h"
#import "VoiceView.h"
#import "LGAudioPlayer.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface ReleaseDynamicVC ()
{
    float addImageCellHeight;
    LocationTool *_manager;
}

@property (weak, nonatomic) IBOutlet UIView *addImageCotentView;
@property (weak, nonatomic) IBOutlet UIButton *releaseBtn;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (nonatomic, strong) ReleaseDynamicViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UISwitch *addressSwitch;
@property (weak, nonatomic) IBOutlet UIView *voiceView;
@property (nonatomic, strong) NSArray *imgs;

@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UILabel *voiceLabel;

/** 录制语音Data */
@property (nonatomic, strong) NSData *voiceData;
/** 录制语音路径 */
@property (nonatomic, copy) NSString *voiceURL;
/** 录制语音长度 */
@property (nonatomic, assign) NSInteger voicelen;

@end
//#define imageCountColumn 4
@implementation ReleaseDynamicVC
@dynamic viewModel;

#pragma mark - Init 

#pragma mark - 生命周期

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.fd_interactivePopDisabled = YES;
    
//    CGFloat itemW = ([UIScreen mainScreen].applicationFrame.size.width - 8 *(imageCountColumn+1))/imageCountColumn+8*2;
//    
//    self.imageMaxCount = 20;
//    self.imageMaxCountColumn = imageCountColumn;//一行几个
////    self.collectionViewH = 140 ;
//    [self configCollectionViewWithCountOfColumn:4 viewW:[UIScreen mainScreen].applicationFrame.size.width superView:self.addImageCotentView];

    self.showInView = self.addImageCotentView;
    [self initPickerView];
    //最大图片数量 默认是6
    self.maxCount = maxImagcount;
    self.rowCount = 3;
    
    [self changeCollectionViewHeight];
    
    _voiceView.hidden = YES;
    
    //限制输入长度
    [_contentTextView setValue:@200 forKey:@"limit"];
    
    [_releaseBtn addTarget:self action:@selector(releaseDynamicClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:KGetImage(@"icon_backwhite") style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    [self.tableView setContentSize:CGSizeMake(SCREEN_WIDTH, 9000)];
}

/**
 *  界面布局 frame
 */
- (void)updateViewsFrame
{
    // photoPicker
    [self updatePickerViewFrameY:[self getPickerViewFrame].origin.y];
    addImageCellHeight =  [self getPickerViewFrame].size.height;

//    _imgs = [self getBigImageArray];
    _imgs = self.imageArray;
    [self.tableView reloadData];
}

- (void)pickerViewFrameChanged{
    
    [self updateViewsFrame];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row==0){
        return 135.5;
        
    }else if(indexPath.row==2 || indexPath.row == 3){
        return 51;
        
    }

    else{
        return addImageCellHeight;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

#pragma mark - Button 


- (void)back{
    TipsView *view = [TipsView tipsView];
    [view.doneBtn setTitle:@"点错了" forState:UIControlStateNormal];
    [view.oneBtn setTitle:@"是的" forState:UIControlStateNormal];
    view.titleLable.text = @"是否取消编辑";
    [view show];
    [[view.doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [view removeFromSuperview];
    }];
    
    [[view.oneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController popViewControllerAnimated:YES];
        [view removeFromSuperview];
        
    }];

}
- (IBAction)recordClick:(id)sender
{
    VoiceView *view = [VoiceView voiceView];
    //发送录音
    view.keyBoardBtn.hidden = YES;
    view.anonymousBtn.hidden = YES;
    kWeakSelf(view);
    
    view.sendCallback = ^(NSNumber *x){
        
        [weakview dismissMaskView];
        
        NSString *url = [LGSoundRecorder shareInstance].soundFilePath;
        
        _voiceView.hidden = NO;
        
        NSData *soundData = [[LGSoundRecorder shareInstance] convertCAFtoAMR:url];
        NSTimeInterval recordTime = [[LGSoundRecorder shareInstance] soundRecordTime];
        _voiceData = soundData;
        _voiceURL = url;
        NSString *soundTImeStr = [[NSString stringWithFormat:@"%d",(int)recordTime * 1000] getMMSS];
        _voiceLabel.text = soundTImeStr;
        _voicelen = (NSInteger)(recordTime * 1000);
        
    };
    [view setUP];
    view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 300);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:view];
    
    [UIView animateWithDuration:0.5 animations:^{
        view.frame=CGRectMake(0, SCREEN_HEIGHT-300, SCREEN_WIDTH, 300);
    }];

}

- (void)releaseDynamicClick
{
    // 检查数据
    if (_imgs.count == 0)
    {
        ShowError(@"至少选择一张图片");
        return;
    }
    
    ShowLoading
    
    // 开始发布 两种情况1.有图片。2.无图片
    if (_imgs.count >= 1)
    {
        QiniuTool *tool = [QiniuTool shareTool];
        [tool uploadImages:_imgs type:UploadTypeSpaceTypeDynamic success:^(NSArray *urls) {
            [self releaseDynamicWithImage:urls];
            CloseLoading;
            
        } failure:^(NSError *error) {
            CloseLoading;
        }];
    }else{
        CloseLoading
        [self releaseDynamicWithImage:nil];
    }
}

#pragma mark - private method
- (void)releaseDynamicWithImage:(NSArray *)imgs
{
    // 先判断有没录制语音,有的画就得先上传到七牛然后再上传
    if (_voiceData)
    {
        [[QiniuTool shareTool] uploadSound:_voiceData type:UploadTypeSpaceTypeDynamic success:^(NSString *soundStr) {

            [self releaseWithVoiceURL:soundStr imgs:imgs];

        } failure:^(NSError *error) {
            ShowError(@"上传语音失败");
        }];

    }
    else{
        [self releaseWithVoiceURL:nil imgs:imgs];
    }
}

- (void)releaseWithVoiceURL:(NSString *)voiceurl imgs:(NSArray *)imgs
{
    ReleaseDynamicRequest *request = [ReleaseDynamicRequest new];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_addressSwitch.on)
    {
        if ([UserInfo shareUser].location.lcprovince) {
            [params setValue:[UserInfo shareUser].location.lcprovince forKey:@"province"];
        }
        if ([UserInfo shareUser].location.lccity) {
            [params setValue:[UserInfo shareUser].location.lccity forKey:@"city"];
        }
        if ([UserInfo shareUser].location.district) {
            [params setValue:[UserInfo shareUser].location.district forKey:@"district"];
        }
        if ([UserInfo shareUser].location.lcaddress) {
            [params setValue:[UserInfo shareUser].location.lcaddress forKey:@"address"];
        }
        if ([UserInfo shareUser].location.lclatitude) {
            [params setValue:[UserInfo shareUser].location.lclatitude forKey:@"latitude"];
        }
        if ([UserInfo shareUser].location.lclongitude) {
            [params setValue:[UserInfo shareUser].location.lclongitude forKey:@"longitude"];
        }
        
    }
    
    if (_contentTextView.text.length >0) {
        [params setValue:_contentTextView.text forKey:@"content"];
    }
    if ([UserInfo shareUser].userID.length >0) {
        [params setValue:[UserInfo shareUser].userID forKey:@"userId"];
    }
    

    if (voiceurl){
        [params setValue:voiceurl forKey:@"voicelen"];
        if (_voicelen) {
            [params setValue:@(_voicelen) forKey:@"duration"];
        }
        
    }
    
    if (imgs.count >= 1){
        [params setValue:imgs forKey:@"images"];
    }
    
    request.param = [params copy];
    
    [request startRequestWithCompleted:^(ResponseState *state) {
        
        CloseLoading
        
        if (state.isSuccess){
            
            
            if (state.alert_msg){
                [CharmHUD showCharHUDWithCharValue:state.alert_msg];
            }
            else{
                DynamicUploadSuccessView *view = [DynamicUploadSuccessView dynamicUploadSuccessView];
                [view show];

            }
            
            NSNotification *notification =[NSNotification notificationWithName:NOTIFICATION_SLRELEASEDYNAMIC object:nil userInfo:nil];
            //通过通知中心发送行程开始通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else{
            [SharedAppDelegate.window makeToast:@"发布失败" duration:2 position:CSToastPositionCenter];
        }
    }];

};

/**
 *  播放录制的语音
 *
 */
- (IBAction)voicePlayClick:(id)sender
{
    [[LGAudioPlayer sharePlayer] playAudioWithURLString:_voiceURL atIndex:0];
  //  [LGAudioPlayer sharePlayer].delegate  = self;
}

@end
