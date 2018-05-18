
//
//  ConvertTool.m
//  NightclubLive
//
//  Created by RDP on 2017/3/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ConvertTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation ConvertTool


- (NSURL *)convertMP4:(NSURL *)sourceUrl{
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    NSLog(@"%@",compatiblePresets);
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        
        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        
        NSString *mp4Path = [[NSString nowTimeString] stringByAppendingFormat:@".mp4"];
        
        NSString * resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@", mp4Path];
        
        NSLog(@"resultPath = %@",resultPath);
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         
         {
             
             switch (exportSession.status) {
                     
                 case AVAssetExportSessionStatusUnknown:
                     
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     
                     break;
                     
                 case AVAssetExportSessionStatusWaiting:
                     
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     
                     break;
                     
                 case AVAssetExportSessionStatusExporting:
                     
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     
                     break;
                     
                 case AVAssetExportSessionStatusCompleted:
                     
                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     
                     break;  
                     
                 case AVAssetExportSessionStatusFailed:  
                     
                     NSLog(@"AVAssetExportSessionStatusFailed");  
                     
                     break;  
                     
             }  
             
         }];  
        
        return exportSession.outputURL;
    }
    
    return nil;
}

@end
