//
//  FMLVideoCommand.h
//  VideoClip
//
//  Created by Collion on 16/8/7.
//  Copyright © 2016年 Collion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^VideoCommandBlock)(BOOL isSuccess,NSURL *url);

@interface FMLVideoCommand : NSObject

/**
 *  裁剪资源
 *
 *  @param asset       被裁减的资源
 *  @param startSecond 开始的秒数
 *  @param endSecond   结束的秒数
 */
- (void)cutAsset:(AVAsset *)asset WithStartSecond:(Float64)startSecond andEndSecond:(Float64)endSecond
         videoURL:(VideoCommandBlock)block;

@end
