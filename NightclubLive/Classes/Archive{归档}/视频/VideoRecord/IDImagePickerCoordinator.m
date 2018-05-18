//
//  IDImagePickerCoordinator.m
//  VideoCaptureDemo
//
//  Created by Adriaan Stellingwerff on 1/04/2015.
//  Copyright (c) 2015 Infoding. All rights reserved.
//

#import "IDImagePickerCoordinator.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "DTVideoConverter.h"

@interface IDImagePickerCoordinator () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *camera;
@property (nonatomic, copy) void(^FinishRecord_Block)(NSURL *, UIImage *);

@end

@implementation IDImagePickerCoordinator

- (instancetype)init {
    self = [super init];
    if(self){
        _camera = [self setupImagePicker];
    }
    return self;
}

- (UIImagePickerController *)cameraVC {
    return _camera;
}

- (void)setFinishRecordBlock:(void (^)(NSURL *, UIImage *))block {
    self.FinishRecord_Block = block;
}

#pragma mark 自定义方法

- (void)startRecorder {
    [_camera startVideoCapture];
}

- (void)stopRecoder {
    [_camera stopVideoCapture];
}

#pragma mark - Private methods

- (UIImagePickerController *)setupImagePicker {
    UIImagePickerController *camera;
    if([self isVideoRecordingAvailable]){
        camera = [UIImagePickerController new];
        camera.sourceType = UIImagePickerControllerSourceTypeCamera;
        camera.mediaTypes = @[(NSString *)kUTTypeMovie];
        camera.videoQuality = UIImagePickerControllerQualityTypeMedium;
        camera.delegate = self;
        _camera = camera;
    }
    return camera;
}

- (BOOL)isVideoRecordingAvailable {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if([availableMediaTypes containsObject:(NSString *)kUTTypeMovie]){
            return YES;
        }
    }
    return NO;
}

- (BOOL)setFrontFacingCameraOnImagePicker:(UIImagePickerController *)picker {
    if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
        [picker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
        return YES;
    }
    return NO;
}

- (void)configureCustomUIOnImagePicker:(UIImagePickerController *)picker {
    UIView *cameraOverlay = [[UIView alloc] init];
    cameraOverlay.backgroundColor = [UIColor redColor];
    picker.showsCameraControls = NO;
    picker.cameraOverlayView = cameraOverlay;
}

#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSURL *recordedVideoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:recordedVideoURL]) {
        [library writeVideoAtPathToSavedPhotosAlbum:recordedVideoURL
                                    completionBlock:^(NSURL *assetURL, NSError *error){}
         ];
    }
    //转换视频格式
    [self convertVideoWithPath:recordedVideoURL];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"---%@", editingInfo);
}

#pragma mark mov to mp4
- (void)convertVideoWithPath:(NSURL *)path {
    
    ShowLoading;
    
    NSString *destinationPath = [[NSString cacheDir] stringByAppendingPathComponent:@"temp.mp4"];
    NSURL *url = [NSURL URLWithString:destinationPath];

    if ([DTVideoConverter fileExistAtURL:url])
    {
        // 1. 创建文件管理器. 文件的增删改查都要通过这个管理器完成
        NSFileManager *manager = [NSFileManager defaultManager];
        // 2. 把要删除的文件名称拼接到caches的路径上去(我要删除icon.png这个文件)
        NSString *deleteFilePath = destinationPath;
        // 3. 让manager执行删除动作, result: 1说明删除成功, 0删除失败
        BOOL result = [manager removeItemAtPath:deleteFilePath error:nil];
        DLog(@"删除结果：%@", result?@"成功":@"失败");
    }
    
    DTVideoConverterProgressHandler progressHandler = ^(float progress) {
        NSLog(@"Process, %.0f %% Done", progress * 100.0f);
    };
    
    DTVideoConverterCompletionHandler completionHandler = ^(NSError *error) {
        
        CloseLoading;
        
        if (error != nil) {
            NSLog(@"Error: %@", error);
            
            return;
        }
       
        NSURL *url = [NSURL URLWithString:destinationPath];
        if (_FinishRecord_Block) {
            _FinishRecord_Block(url, [self getVideoPreViewImage:path]);
        }
    };
    
    DTVideoConverter *converter = [DTVideoConverter videoConverterWithSourceURL:path];
    [converter setDestinationPath:destinationPath];
    [converter setExportQuality:AVAssetExportPresetHighestQuality];
    [converter setOutputFileType:AVFileTypeMPEG4];
    [converter setProgressHandler:progressHandler];
    [converter startConvertWithCompletionHandler:completionHandler];
}

#pragma mark 获取视频第一帧
- (UIImage *)getVideoPreViewImage:(NSURL *)videoPath {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return img;
}

@end
