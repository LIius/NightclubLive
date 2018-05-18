//
//  VideoTool.m
//  NightclubLive
//
//  Created by RDP on 2017/3/13.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "VideoTool.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

@interface VideoTool()
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) AVURLAsset *asset;
@end

@implementation VideoTool

- (instancetype)initWithURL:(NSURL *)url{
    
    self = [super init];
    
    if (!self)
        return nil;
    
    self.videoURL = url;
    
    self.asset = [AVURLAsset assetWithURL:url];
    
    CMTime time = [_asset duration];
    
    _timeLength = (int)(time.value/time.timescale);
    
    return self;
}


- (UIImage*)atTime:(NSTimeInterval)time {

    NSURL *videoURL = self.videoURL;
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime ctime = CMTimeMakeWithSeconds(time, 600);
    NSError *error = nil;
    CMTime actualTime;
    
    //休眠一秒,不知道为什么大视频要停止2秒才会获取成功
    sleep(3);
    CGImageRef image = [assetGen copyCGImageAtTime:ctime actualTime:&actualTime error:&error];
    if (error){
        image = [assetGen copyCGImageAtTime:ctime actualTime:&actualTime error:&error];
    }
    
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

- (void)cropWithStart:(CGFloat)startTime end:(CGFloat)endTime completion:(void (^)(NSURL *outputURL, Float64 videoDuration, BOOL isSuccess))completionHandle
{
    AVURLAsset *asset =[[AVURLAsset alloc] initWithURL:self.videoURL options:nil];
    
    //获取视频总时长
  //  Float64 duration = CMTimeGetSeconds(asset.duration);
    
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init]; // 用时间给文件全名，以免重复
    
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    
    NSString *mp4Path = [[NSString nowTimeString] stringByAppendingFormat:@".mp4"];
    
    NSString * resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", mp4Path];
    
    NSString *outputFilePath = resultPath;
    
    NSURL *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality])
    {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]
                                               initWithAsset:asset presetName:AVAssetExportPresetPassthrough];
        
        NSURL *outputURL = outputFileUrl;
        
        exportSession.outputURL = outputURL;
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        CMTime start = CMTimeMakeWithSeconds(startTime, asset.duration.timescale);
        CMTime duration = CMTimeMakeWithSeconds(endTime - startTime,asset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        exportSession.timeRange = range;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status])
            {
                case AVAssetExportSessionStatusFailed:
                {
                    NSLog(@"合成失败：%@", [[exportSession error] description]);
                    completionHandle(outputURL, endTime, NO);
                }
                    break;
                case AVAssetExportSessionStatusCancelled:
                {
                    completionHandle(outputURL, endTime, NO);
                }
                    break;
                case AVAssetExportSessionStatusCompleted:
                {
                    completionHandle(outputURL, endTime, YES);
                }
                    break;
                default:
                {
                    completionHandle(outputURL, endTime, NO);
                } break;
            }
        }];
    }
}

@end
