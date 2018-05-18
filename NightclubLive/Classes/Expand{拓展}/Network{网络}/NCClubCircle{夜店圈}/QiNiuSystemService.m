//
//  QiNiuSystemService.m
//  NightclubLive
//
//  Created by WanBo on 17/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//
#import "QiNiuSystemService.h"
#import "QiNiuUploadHelper.h"
#import "ClubCircleRequest.h"
#import "QiniuSDK.h"

@implementation QiNiuSystemService

+ (void)uploadImage:(UIImage *)image currentIndex:(NSUInteger)index  progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure{
    [QiNiuSystemService qiNiuUploadToken:^(NSString *token) {
        
        NSData *data = UIImageJPEGRepresentation(image, 1);
        if (!data) {
            if (failure) {
                failure();
            }
            return;
        }
        
        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:progress params:nil checkCrc:NO cancellationSignal:nil];
        QNUploadManager *uploadManager = [[QNUploadManager alloc]initWithRecorder:nil];
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval fix=[dat timeIntervalSince1970]*1000;
        NSLog(@"%@",[NSString stringWithFormat:@"%ldimage%lu.jpg",(long)fix,(unsigned long)index]);
        [uploadManager putData:data key:[NSString stringWithFormat:@"%ldimage%lu.jpg",(long)fix,(unsigned long)index] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.statusCode == 200 && resp) {
                NSLog(@"%@--%llu",info.host,info.timeStamp);
                NSString *url;
                url = [NSString stringWithFormat:@"%@%@",URL_QINIU,resp[@"key"]];
                
                if (success) {
                    success(url);
                }
            }
            else {
                if (failure) {
                    failure();
                }
            }
        } option:opt];
    } failure:^{
        if (failure) {
            failure();
        }
    }];
}

//上传图片
+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    __block float totalProgress = 0.0f;
    __block float partProgress = 1.0f / [imageArray count];
    __block NSUInteger currentIndex = 0;
    
    QiNiuUploadHelper *uploadHelper = [QiNiuUploadHelper sharedInstance];
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    
    uploadHelper.singleFailureBlock = ^() {
        failure();
        return;
    };
    uploadHelper.singleSuccessBlock  = ^(NSString *url) {
        [array addObject:url];
        totalProgress += partProgress;
        progress(totalProgress);
        currentIndex++;
        if ([array count] == [imageArray count]) {
            success([array copy]);
            return;
        }
        else {
            [QiNiuSystemService uploadImage:imageArray[currentIndex] currentIndex:currentIndex progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
        }
    };
    
    [QiNiuSystemService uploadImage:imageArray[0]  currentIndex:currentIndex progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
}

#pragma mark 上传视频
+ (void)uploadVideoWithPath:(NSString *)recordedVideoURL progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure {
    [QiNiuSystemService qiNiuUploadToken:^(NSString *token) {
        
        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:progress params:nil checkCrc:NO cancellationSignal:nil];
        QNUploadManager *uploadManager = [[QNUploadManager alloc]initWithRecorder:nil];
        
        NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval fix = [dat timeIntervalSince1970]*1000;
        NSString *key = [NSString stringWithFormat:@"%ldvideo.mp4",(long)fix];
        NSLog(@"%@",[NSString stringWithFormat:@"%ldvideo.mp4",(long)fix]);
        
        [uploadManager putFile:recordedVideoURL key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.statusCode == 200 && resp) {
                NSLog(@"%@--%llu",info.host,info.timeStamp);
                NSString *url;
                url = [NSString stringWithFormat:@"%@%@",URL_QINIU,resp[@"key"]];
                if (success) {
                    success(url);
                }
            }
            else {
                if (failure) {
                    failure();
                }
            }
        } option:opt];
    } failure:^{
        if (failure) {
            failure();
        }
    }];
    
}

//获取七牛的token
+ (void)qiNiuUploadToken:(void (^)(NSString *))success failure:(void (^)())failure{
    
    GetQNAuthTokenRequest *request = [GetQNAuthTokenRequest new];
    [request startWithCompletedBlock:^(GJBaseRequest *request) {
        if (!request.error) {
            success(request.responseJson[@"result"]);
        }
    }];

}
// 获取七牛上传成功的key

+ (void)qiNiuUrlkey:(NSString *)key success:(void (^)(NSString *url))success failure:(void (^)())failure{
    
//    [HotelRequest requestHotelSubjectPicPathChangeWithPicpath:key
//                                                      manager:[HttpRequest requestOperationManager]
//                                                      success:^(id responseObject) {
//                                                          
//                                                          NSString *picUrl = responseObject[@"picurl"];
//                                                          if (success) {
//                                                              success(picUrl);
//                                                          }
//                                                          
//                                                      } failure:^(NSOperation *operation, NSError *error) {
//                                                          if (failure) {
//                                                              failure();
//                                                          }
//                                                      }];
    
}

// 获取七牛上传成功的成功后服务端返回的url
+ (void)qiNiuUrlKeyArray:(NSArray *)keyArray success:(void (^)(NSArray *array))success failure:(void (^)())failure{
    NSMutableArray *UrlArray = [[NSMutableArray alloc] init];
    
    __block NSUInteger currentIndex = 0;
    QiNiuUploadHelper *uploadHelper = [QiNiuUploadHelper sharedInstance];
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    
    uploadHelper.singleFailureBlock = ^() {
        failure();
        return;
    };
    uploadHelper.singleSuccessBlock  = ^(NSString *url) {
        [UrlArray addObject:url];
        currentIndex++;
        if ([UrlArray count] == [keyArray count]) {
            success([UrlArray copy]);
            return;
        }
        else {
            [QiNiuSystemService qiNiuUrlkey:url success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
        }
    };
    
    [QiNiuSystemService qiNiuUrlkey:keyArray[0] success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
}
//压缩上传图片的大小比例
+ (UIImage*)originImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
@end
