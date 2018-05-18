//
//  ViewController.m
//  VideoRecord
//
//  Created by Coderiding on 16/2/23.
//  Copyright © 2016年 Coderiding. All rights reserved.
//

#import "VideoVC.h"
#import <AVFoundation/AVFoundation.h>
#import "RAFileManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PostVideoPlayerController.h"
#import "MRCViewModel.h"
#import "PaiPaiPostVideoViewModel.h"
#import "ObjectNavigationController.h"
#import "UIAlertController+Factory.h"

#define TIMER_INTERVAL 0.1
#define VIDEO_RECORDER_MAX_TIME 30 //视频最大时长 (单位/秒)
#define VIDEO_RECORDER_MIN_TIME 3  //最短视频时长 (单位/秒)
#define KMainScreenW [UIScreen mainScreen].bounds.size.width
#define KMainScreenH [UIScreen mainScreen].bounds.size.height

@interface VideoVC ()
<
AVCaptureFileOutputRecordingDelegate
>
{
    AVCaptureDevice *_videoDevice;//时间长度
    CGFloat timeLength;
    NSURL * CompressURL;
}

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *takeVideoButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

/**
 *  AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
 */
@property (nonatomic, strong) AVCaptureSession* session;
/**
 *  视频输入设备
 */
@property (nonatomic, strong) AVCaptureDeviceInput* videoInput;
/**
 *  声音输入
 */
@property (nonatomic, strong) AVCaptureDeviceInput* audioInput;
/**
 *  视频输出流
 */
@property(nonatomic,strong)AVCaptureMovieFileOutput *movieFileOutput;
/**
 *  预览图层
 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer* previewLayer;
/**
 *  记录录制时间
 */
@property (nonatomic, strong) NSTimer* timer;

@property (nonatomic, strong) MRCViewModel *viewModel;
@property (nonatomic) dispatch_queue_t sessionQueue;

@end

@implementation VideoVC
@dynamic viewModel;

- (IBAction)disMissAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initAVCaptureSession];
    
    self.timeLable.text = [NSString stringWithFormat:@"00:%.2d",VIDEO_RECORDER_MAX_TIME];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self startSession];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self stopSession];
}

#pragma mark - 视频输出
- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    if (CMTimeGetSeconds(captureOutput.recordedDuration) < VIDEO_RECORDER_MIN_TIME) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频时间过短" message:nil delegate:self
    cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
     NSLog(@"%s-- url = %@ ,recode = %f , int %lld kb", __func__, outputFileURL, CMTimeGetSeconds(captureOutput.recordedDuration), captureOutput.recordedFileSize / 1024);
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib writeVideoAtPathToSavedPhotosAlbum:outputFileURL completionBlock:^(NSURL *assetURL, NSError *error) {
    }];

    [self compressionWithUrl:outputFileURL];
}

// 切换闪光灯    闪光模式开启后,并无明显感觉,所以还需要开启手电筒
- (IBAction)changeFlashlight:(UIButton *)sender
{
    BOOL con1 = [_videoDevice hasTorch];    //支持手电筒模式
    BOOL con2 = [_videoDevice hasFlash];    //支持闪光模式
    
    if (con1 && con2)
    {
        [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
            if (_videoDevice.flashMode == AVCaptureFlashModeOn)         //闪光灯开
            {
                [_videoDevice setFlashMode:AVCaptureFlashModeOff];
                [_videoDevice setTorchMode:AVCaptureTorchModeOff];
            }else if (_videoDevice.flashMode == AVCaptureFlashModeOff)  //闪光灯关
            {
                [_videoDevice setFlashMode:AVCaptureFlashModeOn];
                [_videoDevice setTorchMode:AVCaptureTorchModeOn];
            }

            NSLog(@"现在的闪光模式是AVCaptureFlashModeOn么?是你就扣1, %zd",_videoDevice.flashMode == AVCaptureFlashModeOn);
        }];
        sender.selected=!sender.isSelected;
    }else{
        NSLog(@"不能切换闪光模式");
    }
}

#pragma mark 获取摄像头-->前/后
- (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = devices.firstObject;
    
    for ( AVCaptureDevice *device in devices )
    {
        if ( device.position == position )
        {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

#pragma mark -切换前后镜头
- (IBAction)changeCamera
{
    switch (_videoDevice.position)
    {
        case AVCaptureDevicePositionBack:
            _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionFront];
            break;
        case AVCaptureDevicePositionFront:
            _videoDevice = [self deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
            break;
        default:
            return;
            break;
    }
    
    [self changeDevicePropertySafety:^(AVCaptureDevice *captureDevice) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:&error];
        
        if (newVideoInput != nil) {
            //必选先 remove 才能询问 canAdd
            [_session removeInput:_videoInput];
            if ([_session canAddInput:newVideoInput]) {
                [_session addInput:newVideoInput];
                _videoInput = newVideoInput;
            }else{
                [_session addInput:_videoInput];
            }
          } else if (error) {
            NSLog(@"切换前/后摄像头失败, error = %@", error);
        }
        
    }];
}

#pragma mark -更改设备属性前一定要锁上
-(void)changeDevicePropertySafety:(void (^)(AVCaptureDevice *captureDevice))propertyChange
{
    //也可以直接用_videoDevice,但是下面这种更好
    AVCaptureDevice *captureDevice= [_videoInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁,意义是---进行修改期间,先锁定,防止多处同时修改
    BOOL lockAcquired = [captureDevice lockForConfiguration:&error];
    if (!lockAcquired) {
        NSLog(@"锁定设备过程error，错误信息：%@",error.localizedDescription);
    }else{
        [_session beginConfiguration];
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
        [_session commitConfiguration];
    }
}

#pragma mark - private mehtod
- (void)initAVCaptureSession
{
    self.session = [[AVCaptureSession alloc] init];
    
    //这里根据需要设置  可以设置4K
    self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    NSError *error;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    _videoDevice = device;
    //更改这个设置的时候必须先锁定设备，修改完后再解锁，否则崩溃
    [device lockForConfiguration:nil];
    //设置闪光灯为自动
    [device setFlashMode:AVCaptureFlashModeOff];
    [device unlockForConfiguration];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:nil];
    
    if (error) {
        NSLog(@"%@",error);
    }
    self.movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    
    if ([self.session canAddInput:self.audioInput]) {
        
        [self.session addInput:self.audioInput];
    }
    
    if ([self.session canAddOutput:self.movieFileOutput]) {
        [self.session addOutput:self.movieFileOutput];
    }
    
    //初始化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    //    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    self.previewLayer.frame = CGRectMake(0, 0,KMainScreenW, KMainScreenH);
    self.backView.layer.masksToBounds = YES;
    [self.backView.layer insertSublayer:self.previewLayer atIndex:0];
}

- (void)startSession
{
    if (![self.session isRunning]) {
        [self.session startRunning];
    }
}

- (void)stopSession
{
    if ([self.session isRunning]) {
        [self.session stopRunning];
    }
}

- (void)timerFired
{
    timeLength = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TIMER_INTERVAL target:self selector:@selector(timerRecord) userInfo:nil repeats:YES];
}

- (void)timerStop
{
    if ([self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma 视频名以当前日期为名
- (NSString*)getVideoSaveFilePathString
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString* nowTimeStr = [formatter stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    return nowTimeStr;
}

#pragma mark 开始录制和结束录制
- (void)startVideoRecorder
{
    AVCaptureConnection *movieConnection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    AVCaptureVideoOrientation avcaptureOrientation = AVCaptureVideoOrientationPortrait;
    [movieConnection setVideoOrientation:avcaptureOrientation];
    [movieConnection setVideoScaleAndCropFactor:1.0];
    
     NSURL *url = [[RAFileManager defaultManager] filePathUrlWithUrl:[self getVideoSaveFilePathString]];
    [self.movieFileOutput startRecordingToOutputFileURL:url recordingDelegate:self];
    [self timerFired];
}

- (void)stopVideoRecorder
{
    [self.movieFileOutput stopRecording];
    [self timerStop];

    self.timeLable.text = [NSString stringWithFormat:@"00:%.2d",VIDEO_RECORDER_MAX_TIME];
}

#pragma  截图方法
- (UIImage *)videoSnap:(NSString *)videoPath
{
    NSURL *url = [NSURL fileURLWithPath:videoPath];
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    CMTime snaptime = CMTimeMake(10, 10);
    CMTime time2;
    
    CGImageRef cgImageRef = [generator copyCGImageAtTime:snaptime actualTime:&time2 error:nil];
    
    UIImage *tempImage = [UIImage imageWithCGImage:cgImageRef];
    
    CGImageRelease(cgImageRef);
    
    return tempImage;
}

#pragma mark -点击拍摄
- (IBAction)recordClick:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    
    if (tag == 1)
    {
        // 拍摄中
        [self stopVideoRecorder];
    }
    else{
        // 未开始
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            ShowSuccess(@"无摄像头权限");
            return;
        }
        
        // 判断用户是否允许访问麦克风权限
        authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            // 无权限
            ShowSuccess(@"无麦克风权限");
            return;
        }
        
        [self startVideoRecorder];

    }
    sender.tag *= -1;
}

- (IBAction)takeVideoButtonPress:(UILongPressGestureRecognizer *)sender
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        return;
    }
    
    // 判断用户是否允许访问麦克风权限
    authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        // 无权限
        return;
    }
    
    switch (sender.state)
    {
        case UIGestureRecognizerStateBegan:
            [self startVideoRecorder];
            break;
        case UIGestureRecognizerStateCancelled:
            [self stopVideoRecorder];
            break;
        case UIGestureRecognizerStateEnded:
            [self stopVideoRecorder];
            break;
        case UIGestureRecognizerStateFailed:
            [self stopVideoRecorder];
            break;
        default:
            break;
    }
}

- (void)timerRecord
{
    timeLength += TIMER_INTERVAL;
    NSInteger showtime = VIDEO_RECORDER_MAX_TIME - (int)timeLength;
    self.timeLable.text = [NSString stringWithFormat:@"00:%.2d",(int)showtime];

    if (timeLength/VIDEO_RECORDER_MAX_TIME >= 1.0) {
        
        [self stopVideoRecorder];
        
        [self timerStop];
    }
}

#pragma mark -计算压缩大小
- (CGFloat)fileSize:(NSURL *)path
{
    return [[NSData dataWithContentsOfURL:path] length]/1024.00 /1024.00;
}

#pragma mark -压缩
- (void)compressionWithUrl:(NSURL *)url
{
    MBProgressHUD *hud = [MBProgressHUD bwm_showHUDAddedTo:self.view title:@"压缩中"];
    
    NSLog(@"压缩前大小 %f MB",[self fileSize:url]);
    //    创建AVAsset对象
    AVAsset* asset = [AVAsset assetWithURL:url];
    /*   创建AVAssetExportSession对象
     压缩的质量
     AVAssetExportPresetLowQuality   最low的画质最好不要选择实在是看不清楚
     AVAssetExportPresetMediumQuality  使用到压缩的话都说用这个
     AVAssetExportPresetHighestQuality  最清晰的画质
     
     */
    AVAssetExportSession * session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    //优化网络
    session.shouldOptimizeForNetworkUse = YES;
    //转换后的格式
    
    //拼接输出文件路径 为了防止同名 可以根据日期拼接名字 或者对名字进行MD5加密
    
    NSString* path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"hello.mp4"];
    //判断文件是否存在，如果已经存在删除
    [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
    //设置输出路径
    session.outputURL = [NSURL fileURLWithPath:path];
    
    //设置输出类型  这里可以更改输出的类型 具体可以看文档描述
    session.outputFileType = AVFileTypeMPEG4;
    
    [session exportAsynchronouslyWithCompletionHandler:^
    {
        NSLog(@"%@",[NSThread currentThread]);
        // 压缩完成
        if (session.status==AVAssetExportSessionStatusCompleted) {
            
            // 在主线程中刷新UI界面，弹出控制器通知用户压缩完成
            dispatch_async(dispatch_get_main_queue(), ^{
               // NSLog(@"导出完成");
                [hud hide:YES];
                CompressURL = session.outputURL;
                NSLog(@"压缩完毕,压缩后大小 %f MB",[self fileSize:CompressURL]);
                NSString *string = [NSString stringWithFormat:@"file:///%@",[[CompressURL absoluteString] substringFromIndex:7]];

                if (self.VideoBlock){
                    
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"视频录制完毕,是否要上传" action:@[@"立即上传",@"重新录制"] calk:^(NSNumber *indexNum) {
                        
                        NSInteger num = [indexNum integerValue];
                        
                        if (num == 0){
                            //coderiding
//                            [self dismissViewControllerAnimated:YES completion:nil];
//                            self.VideoBlock(string);
                            
                            // 跳转进入完善视频信息控制器{上传视频}
                            [self uploadVideToServer:[NSURL URLWithString:string] withVideo:@"MP4" withType:0];
                            NSLog(@"uploadVideToServer{=%@",[NSThread currentThread]);
                            
                        }
                        else{
                            [self startVideoRecorder];
                        }
                        
                        
                    }];
                    
                    [self presentViewController:ac animated:YES completion:nil];
                    
                }
            });
            
        }
        
    }];
}

- (void)uploadVideToServer:(NSURL *)videoURL withVideo:(NSString *)typeString withType:(NSInteger)type
{
    PaiPaiPostVideoViewModel *viewModel = [[PaiPaiPostVideoViewModel alloc] init];
    viewModel.videoUrl = videoURL;
    
    PostVideoPlayerController *vc = [PostVideoPlayerController controllerWithViewModel:viewModel andSbName:@"CLPostVideoSB"];
    vc.sourceType = type;
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end
