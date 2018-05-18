//
//  QiniuTool.m
//  NightclubLive
//
//  Created by RDP on 2017/3/1.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "QiniuTool.h"
#import <Qiniu/QiniuSDK.h>
#import "GetQiniuTokenRequest.h"

typedef enum{
    QinuiBaseURLTypeDynamic = 0,
    QinuiBaseURLTypeHeartSound = 3,
    QinuiBaseURLTypePaiPai = 2,
    QinuiBaseURLTypeCampain = 1,
    QinuiBaseURLTypeAuth = 4
}QinuiBaseURLType;

typedef void (^GetTokenSuccessBlock)(NSString *token,NSString *url,NSString *requestURL);
typedef void (^GetTokenFailureBlock)(NSError *error);

static float Image_Zip = 7.5;
//动态
static NSString *UploadTypeSpaceTypeDynamicKey = @"0";
//竞选活动动态
static NSString *UploadTypeSpaceTypeCampaignKey = @"1";
//竞选活动
static NSString *UploadTypeSpaceTypePaipaiKey = @"2";
//心声
static NSString *UploadTypeSpaceTypeXSKey = @"3";

@interface QiniuTool()
@property (nonatomic, strong) QNUploadManager *uploadManager;
@property (nonatomic, strong) NSDictionary *uploadTokens;
@property (nonatomic, strong) NSMutableArray *urls;
@end

@implementation QiniuTool

#pragma mark - Init

- (instancetype)init{
    
    if (self = [super init]){
        
        self.uploadManager = [[QNUploadManager alloc] init];
    }
    return self;
}

+ (instancetype)shareTool{
    
    static QiniuTool *shareTool;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        shareTool = [[QiniuTool alloc] init];
    });
    
    return shareTool;
};


#pragma mark - Private Method

- (void)getQiniuToken:(GetTokenSuccessBlock)successBlock withFailure:(GetTokenFailureBlock)failureBlock{
    
    GetQiniuTokenRequest *request = [[GetQiniuTokenRequest alloc] init];
    request.param = @{@"file_type":@(_uploadSpaceType)};
    
    [request startWithCompletedBlock:^(GJBaseRequest *request) {
        
        NSDictionary *responseDic = request.responseObject;
        
        if ([responseDic[@"code"] integerValue] == 0){
            
            if (successBlock){
                successBlock(responseDic[@"upToken"],responseDic[@"upToken"],responseDic[@"request_url"]);
            }
        }
        else{
            
            if (failureBlock){
                failureBlock(nil);
            }
        }
        
    }];
    
}

- (NSString *)fullImageURLWithKey:(NSString *)key{

    NSString *imageUrl = [[self QinuiBaseUrlWtihType:(QinuiBaseURLType)_uploadSpaceType] stringByAppendingFormat:@"/%@",key];
    
    return imageUrl;
}

- (NSString *)QinuiBaseUrlWtihType:(QinuiBaseURLType)type{
    
    NSString *baseURL = nil;
    
    if (type == QinuiBaseURLTypeDynamic)
        baseURL = @"http://om377q7db.bkt.clouddn.com";
    else if (type == QinuiBaseURLTypeHeartSound)
        baseURL = @"http://om37giruz.bkt.clouddn.com";
    else if (type == QinuiBaseURLTypePaiPai)
        baseURL = @"http://om377pxnl.bkt.clouddn.com";
    else if (type == QinuiBaseURLTypeCampain)
        baseURL = @"http://om37o53fw.bkt.clouddn.com";
    else if (type == QinuiBaseURLTypeAuth)
        baseURL = @"http://omu0yczmt.bkt.clouddn.com";
    return baseURL;
}

#pragma mark - 上传函数

- (void)uploadImage:(UIImage *)image withToken:(NSString *)token withRequestURL:(NSString *)requestURL FinishBlock:(void (^)(NSString *imgURL))finishBlock
{
    // 压缩图片
    NSData *imageData = UIImageJPEGRepresentation(image, Image_Zip);
    
    [_uploadManager putData:imageData key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp)
    {
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@",requestURL,resp[@"key"]];
        
        DLog(@"{requestURL=%@----key=%@",requestURL,resp[@"key"]);
        DLog(@"{imageUrl=%@",imageUrl);
        if (finishBlock)
            finishBlock(imageUrl);
        
    } option:nil];
}

- (void)uploadImages:(NSArray *)images type:(UploadTypeSpaceType)type success:(UploadSuccessBlock)successBlock failure:(UploadFailureBlock)failure{
    
    _uploadSpaceType = type;
    
    [self getQiniuToken:^(NSString *token, NSString *url,NSString *requsetURL) {
        
        _urls = [NSMutableArray array];
        
        dispatch_async(dispatch_queue_create("Group Upload Image", nil), ^{
            
            //开线程上传图片
            dispatch_group_t group = dispatch_group_create();
            dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
            
            for (NSInteger i = 0 ; i < images.count ; i ++){
                
                dispatch_group_enter(group);
                
                dispatch_group_async(group, queue, ^{
                    
                    [self uploadImage:images[i] withToken:token withRequestURL:requsetURL FinishBlock:^(NSString *imgURL)
                     {
                        [_urls addObject:imgURL];
                        dispatch_group_leave(group);

                    }];
                });
            };
            
            //20秒超时
            dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 20));
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                
                NSLog(@"imageurl.count = %@",url);
                if (successBlock)
                    successBlock([_urls copy]);
            });
        });
        
    } withFailure:^(NSError *error) {
        
        if (failure)
            failure(nil);
    }];
}


- (void)uploadSound:(NSData *)sounddata type:(UploadTypeSpaceType)type success:(UploadSuccessBlock)successBlock failure:(UploadFailureBlock)failureBlock{
    
    [self getQiniuToken:^(NSString *token, NSString *url,NSString *requestURL) {
        
        NSString *key = [NSString nowTimeString];
        key = [key stringByAppendingFormat:@".amr"];
        
        [_uploadManager putData:sounddata key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
           NSString *url = [requestURL stringByAppendingPathComponent:key];
            
            if (successBlock)
                successBlock(url);
            
        } option:nil];

    } withFailure:^(NSError *error) {
        
        if (failureBlock)
            failureBlock(nil);
    }];
}

- (void)uploadVideo:(NSURL *)videoURL
               type:(UploadTypeSpaceType)type
            success:(UploadSuccessBlock)successBlock
            failure:(UploadFailureBlock)failure{
    
    
    NSError *readErro;
    
    NSData *videoData = [NSData dataWithContentsOfURL:videoURL options:NSDataReadingUncached error:&readErro];
    
    NSInteger length = videoData.length;
    
    DLog(@"len = %ld",(long)length);
    
    [self getQiniuToken:^(NSString *token, NSString *url,NSString *requestURL) {
        
        NSString *key = [[NSString nowTimeString] stringByAppendingFormat:@".mp4"];
        
        [_uploadManager putData:videoData key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            
            NSString *fullPath = [requestURL stringByAppendingPathComponent:key];
            
            if (successBlock)
                successBlock(fullPath);
            
        } option:nil];

        
    } withFailure:^(NSError *error) {
        
        if (failure)
            failure(nil);
        
    }];
    
}

#pragma mark - Getter

- (NSMutableArray *)urls{
    
    if (!_urls){
        _urls = [NSMutableArray array];
    }
    return _urls;
}
@end
