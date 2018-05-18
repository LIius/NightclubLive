//
//  VideoTool.h
//  NightclubLive
//
//  视频工具
//  Created by RDP on 2017/3/13.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoTool : NSObject
//视频长度（毫秒）
@property (nonatomic, assign) NSTimeInterval timeLength;
/** 视频大小 */
@property (nonatomic, assign) NSInteger size;
/** 视频来源  0-拍摄  1-从相册*/
@property (nonatomic, assign) NSInteger sourceType;

/**
 *  定义对象
 *
 *  @param url 本地视频连接
 *
 *  @return 对象
 */
- (instancetype)initWithURL:(NSURL *)url;

/**
 *  获取视频帧
 *  @param time     时间
 *
 *  @return 对应帧的图片
 */
- (UIImage*)atTime:(NSTimeInterval)time;

/**
 *  视频裁剪
 * *  @param startTime        视频开始时间(裁剪)
 *  @param endTime          视频结束时间(结束)
 *  @param completionHandle 回调
 */
- (void)cropWithStart:(CGFloat)startTime end:(CGFloat)endTime completion:(void (^)(NSURL *outputURL, Float64 videoDuration, BOOL isSuccess))completionHandle;
@end
