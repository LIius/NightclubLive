//
//  lsMediaCapture.h
//  lsMediaCapture
//
//  Created by NetEase on 15/8/12.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "nMediaLiveStreamingDefs.h"

/*! \file */

/**
 *  直播中的NSNotificationCenter消息广播
 */
#define LS_LiveStreaming_Started             @"LSLiveStreamingStarted"       //!< 直播推流已经开始
#define LS_LiveStreaming_Finished            @"LSLiveStreamingFinished"      //!< 直播推流已经结束
#define LS_LiveStreaming_Bad                 @"LSLiveStreamingBad"           //!< 直播推流状况不好，建议降低分辨率
#define LS_AudioFile_eof                     @"LSAudioFileEof"               //!< 当前audio文件播放结束

/**
 *  @brief 获取最新一帧视频截图后的回调
 *
 *  @param latestFrameImage 最新一帧视频截图
 */
typedef void(^LSFrameCaptureCompletionBlock)(UIImage *latestFrameImage);

/**
 *  @brief 摄像头裸流的回调，开发者可以修改该数据，美颜增加滤镜等，推出的流便随之发生变化
 *
 *  @param uiRgbaData 摄像头采集的rgba数据，iWideth，iHeight分别为该摄像头采集的长宽
 */
typedef void(^LSCameraCaptureDataCB)( uint8_t *uiRgbaData, int iWideth, int iHeight);

/**
 *  @brief 采集的原始pcm数据回调，开发者可以修改该pcm，推出的声音便随之发生变化
 *
 *  @param uiPcmData 摄像头采集的pcm数据，iLen该pcm数据长度大小
 */
typedef void(^LSAudioCaptureDataCB)( uint8_t *uiPcmData, int iLen);

/**
 *  @brief 直播类LSMediacapture，用于推流
 */
@interface LSMediaCapture : NSObject

/**
 *  直播过程中发生错误的回调函数
 *
 *  @param error 具体错误信息
 */
@property (nonatomic,copy) void (^onLiveStreamError)(NSError *error);
/**
 *  初始化mediacapture
 *
 *  @param  liveStreamingURL 推流的url地址
 *
 *  @return LSMediaCapture
 */
- (instancetype)initLiveStream:(NSString *)liveStreamingURL;
/**
 *  初始化mediacapture
 *
 *  @param  liveStreamingURL 推流的url
 *  @param  videoParaCtx 推流视频参数
 *
 *  @return LSMediaCapture
 */
- (instancetype)initLiveStream:(NSString *)liveStreamingURL withVideoParaCtx:(LSVideoParaCtx)videoParaCtx ;
/**
 *  初始化mediacapture
 *
 *  @param  liveStreamingURL 推流的url
 *  @param  lsParaCtx 推流参数
 *
 *  @return LSMediaCapture
 */
- (instancetype)initLiveStream:(NSString *)liveStreamingURL withLivestreamParaCtx:(LSLiveStreamingParaCtx)lsParaCtx;

/**
 反初始化：释放资源
 */
-(void)unInitLiveStream;

/**
 *  打开视频预览
 *
 *  @param  preview 预览窗口
 */
- (void)startVideoPreview:(UIView*)preview;

/**
 *  @warning 暂停视频预览，如果正在直播，则同时关闭视频预览以及视频推流
 *
 */
- (void)pauseVideoPreview;

/**
 *  @warning 继续视频预览，如果正在直播，则开始视频推流
 *
 */
- (void)resumeVideoPreview;

/**
 *
 *  推流地址
 */
@property(nonatomic,copy)NSString* pushUrl;

/**
 *  直播推流之前，可以再次设置一下视频参数
 *  @param  videoResolution 采集分辨率
 *  @param  bitrate 推流码率 default会按照分辨率设置
 *  @param  fps     采集帧率 default ＝ 15
 *
 */
- (void)setVideoParameters:(LSVideoStreamingQuality)videoResolution
                   bitrate:(int)bitrate
                       fps:(int)fps
         cameraOrientation:(LSCameraOrientation) cameraOrientation;

/**
 *  开始直播
 *
 *  @param outError 具体错误信息
 */

- (BOOL)startLiveStreamWithError:(NSError**)outError;

/**
 *  结束推流
 * @warning 只有直播真正开始后，也就是收到LSLiveStreamingStarted消息后，才可以关闭直播,error为nil的时候，说明直播结束，否则直播过程中发生错误，
 */
- (void)stopLiveStream:(void(^)(NSError *))completionBlock;


/**
 *  重启开始视频推流
 *  @warning 需要先启动推流startLiveStreamWithError，开启音视频推流，才可以中断视频推流，重启视频推流，
 */
- (void)resumeVideoLiveStream;

/**
 *  中断视频推流
 *  @warning 需要先启动推流startLiveStreamWithError，开启音视频推流，才可以中断视频推流，重启视频推流，
 */
- (void)pauseVideoLiveStream;


/**
 *  重启音频推流，
 *  @warning：需要先启动推流startLiveStreamWithError，开启音视频推流，才可以中断音频推流，重启音频推流，
 */
- (BOOL)resumeAudioLiveStream;

/**
 *  中断音频推流，
 *  @warning：需要先启动推流startLiveStreamWithError，开启音视频推流，才可以中断音频推流，重启音频推流，
 */
- (BOOL)pauseAudioLiveStream;


/**
 *  切换前后摄像头
 *
 *  @return 当前摄像头的位置，前或者后
 */
- (LSCameraPosition)switchCamera;

//!<  本地录制部分（目前仅支持flv）
/**
 *  开始录制并保存本地文件
 *
 *  @param recordFileName 本地录制的文件全路径
 */
- (BOOL)startRecord:(NSString *)recordFileName;

/**
 *  停止本地录制
 */
- (void)stopRecord;

//!<  混音相关部分
/**
 *  开始播放混音文件
 *
 *  @param musicURL 音频文件地址/文件名
 *  @param enableLoop 当前音频文件是否单曲循环
 */
- (BOOL)startPlayMusic:(NSString*)musicURL withEnableSignleFileLooped:(BOOL)enableLoop;
/**
 *  结束播放混音文件，释放播放文件
 */
- (BOOL)stopPlayMusic;
/**
 *  继续播放混音文件
 */
- (BOOL)resumePlayMusic;
/**
 *  中断播放混音文件
 */
- (BOOL)pausePlayMusic;
/**
 *  设置混音强度
 *  @param value 混音强度范围【1-10】
 */
- (void)setMixIntensity:(int )value;

//!< 滤镜相关部分
/**
 *  设置滤镜类型
 *
 *  @param filterType 滤镜类型，目前支持7种滤镜，参考 GPUImageFilterType 描述
 *
 */
- (void)setFilterType:(LSGpuImageFilterType)filterType;
/**
 *  设置磨皮滤镜强度
 *
 *   @param value 滤镜强度设置
 *
 *    注意： 对于不同滤镜类型，可调节强度不同
 * 只有四种滤镜提供了 强度调节，其他款滤镜只有一种强度值:
 * LS_GPUIMAGE_BEAUTY    [0~1]
 * LS_GPUIMAGE_SEPIA     [0~1]
 * LS_GPUIMAGE_TONECURVE [0~1]
 * LS_GPUIMAGE_CONTRAST  [0~4]
 */
- (void)setSmoothFilterIntensity:(float)value;


/**
 *  设置对比度滤镜强度
 *
 *   @param value 滤镜强度设置
 *
 *    注意： 对于不同滤镜类型，可调节强度不同
 * 只有四种滤镜提供了 强度调节，其他款滤镜只有一种强度值:
 * LS_GPUIMAGE_BEAUTY    [0~1]
 * LS_GPUIMAGE_SEPIA     [0~1]
 * LS_GPUIMAGE_TONECURVE [0~1]
 * LS_GPUIMAGE_CONTRAST  [0~4]
 */
- (void)setContrastFilterIntensity:(float)value;


/**
 *  flash摄像头
 *
 *  @return 打开或者关闭摄像头flash
 */
@property (nonatomic, assign)BOOL flash;

/**
 *  摄像头变焦功能属性：最大拉伸值，系统最大为：videoMaxZoomFactor
 *
 *  @warning iphone4s以及之前的版本，videoMaxZoomFactor＝1；不支持拉伸
 */
@property (nonatomic, assign) CGFloat maxZoomScale;

/**
 *  摄像头变焦功能属性：拉伸值，［1，maxZoomScale］
 *
 *  @warning iphone4s以及之前的版本，videoMaxZoomFactor＝1；不支持拉伸
 */
@property (nonatomic, assign) CGFloat zoomScale;

/**
 *  摄像头变焦功能属性：拉伸值变化回调block
 *
 *  摄像头响应uigesture事件，而改变了拉伸系数反馈
 *  @warning  zoom功能考虑到性能需求，目前仅用于非滤镜模块
 */
@property (nonatomic,copy) void (^onZoomScaleValueChanged)(CGFloat value);


/**
 *  设置水印，
 *  @param  image 水印图片
 *  @param  rect 水印图片位置
 *  @param  rect 水印图片标准位置，左右上下，中心店，当第一种位置模式时，具体位置由rect origin点决定
 *  @return 当前摄像头的位置，前或者后
 */

- (void) addWaterMark: (UIImage*) image
                 rect: (CGRect) rect
             location: (LSWaterMarkLocation) location;

/**
 *  设置动态水印，随着时间变化水印图片变化
 *  @param  imageArray 水印图片数组
 *  @param  fps 动态水印的变化频率 fps 次/s,建议和摄像头采集帧率匹配，最大帧率为摄像头采集的频率
 *  @param  interval 水印滚动动态间隔
 *  @param  rect 水印图片位置
 *  @param  rect 水印图片标准位置，左右上下，中心店，当第一种位置模式时，具体位置由rect origin点决定
 *  @return 当前摄像头的位置，前或者后
 */

- (void) addDynamicWaterMarks: (NSArray*) imageArray
                          fps: (unsigned int) fps
                         loop: (BOOL)looped
                         rect: (CGRect) rect
                     location: (LSWaterMarkLocation) location;

/**
 *  获取视频截图，
 *
 *  @param  LSFrameCaptureCompletionBlock 获取最新一幅视频图像的回调
 *
 */

- (void)snapShotWithCompletionBlock:(LSFrameCaptureCompletionBlock)completionBlock;

/**
 *  设置音视频采集的原始裸流，在编码传输前的回调
 *
 *  @param  cameraCaptureDataCB 视频采集的裸流回调函数 audioRawDataCB音频采集的裸流回调函数
 *
 */
- (void)setCaptureRawDataCB:(LSCameraCaptureDataCB)cameraCaptureDataCB audioRawDataCB:(LSAudioCaptureDataCB)audioRawDataCB;

/**
 *  得到直播过程中的统计信息
 *
 *  @param statistics 统计信息结构体
 *
 */
@property (nonatomic,copy) void (^onStatisticInfoGot)(LSStatistics* statistics);

/**
 *  设置trace 的level
 *
 *  @param loglevl trace 信息的级别
 */
- (void)setTraceLevel:(LSMediaLog)logLevel;

/**
 *  设置是否输出到文件，
 *
 *  默认存放在／library/cache
 *
 *  @param  isToFile   是否输出到文件，默认是输出到文件，当为false时，则不输出到文件
 */
- (void)isLogToFile:(BOOL)isToFile;

/**
 *  获取当前sdk的版本号
 *
 */
- (NSString*) getSDKVersionID;

/**
 开始测速
 */
-(void)startSpeedCalc:(NSString *)url success:(void(^)(NSMutableArray *array))success fail:(void(^)())fail;

/**
 结束测速
 */
-(void)stopSpeedCalc;
/**
 测速之前设置测速次数和上传数据大小
 
 @param count 测速次数（默认为1次）,测速之后，取平均值返回结果
 @param capacity 上传数据大小(仅限于文件上传类型,经测试，NTS2不能超过500k（含500k)),单位是字节，500k＝500*1024，默认为499k（控制最大不超过10M）
 */
-(void)setSpeedCacl:(NSInteger)count Capacity:(unsigned long long)capacity;

@end



