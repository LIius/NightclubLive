//
//  QiniuTool.h
//  NightclubLive
//
//  Created by RDP on 2017/3/1.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    //动态文件
    UploadTypeSpaceTypeDynamic = 0,
    //心声
    UploadTypeSpaceTypeHeartSound = 3,
    //拍拍
    UploadTypeSpaceTypePaipai = 2,
    //竞选
    UploadTypeSpaceTypeCampaign = 1,
    //认证
    UploadTypeSpaceTypeAuth = 4,
    
}UploadTypeSpaceType;

typedef void (^UploadSuccessBlock)(id value);
typedef void (^UploadFailureBlock)(NSError *error);

@interface QiniuTool : NSObject
/** 上传类型 */
@property (nonatomic, assign) UploadTypeSpaceType uploadSpaceType;
/**
 *  单例上传工具类
 *
 *  @return 对象
 */
+(instancetype)shareTool;

#pragma mark - 上传

/**
 *  上传图片
 *
 *  @param images       图片源
 *  @param successBlock 成功之后调用的block
 *  @param type         上传到的空间
 *  @param failure      失败调用的block
 */
- (void)uploadImages:(NSArray *)images
                type:(UploadTypeSpaceType)type
             success:(UploadSuccessBlock)successBlock
             failure:(UploadFailureBlock)failure;

/**
 *  上传语音文件
 *
 *  @param sounddata    语音文件
 *  @param type         空间累心
 *  @param successBlock 成功回调
 *  @param failureBlock 失败回调
 */
- (void)uploadSound:(NSData *)sounddata
               type:(UploadTypeSpaceType)type
            success:(UploadSuccessBlock)successBlock
            failure:(UploadFailureBlock)failureBlock;

/**
 *  上传视频文件
 *
 *  @param videoURL     视频文件路径
 *  @param type         控件类型
 *  @param successBlock 成功回调
 *  @param failure      失败回调
 */
- (void)uploadVideo:(NSURL *)videoURL
               type:(UploadTypeSpaceType)type
            success:(UploadSuccessBlock)successBlock
            failure:(UploadFailureBlock)failure;


@end
