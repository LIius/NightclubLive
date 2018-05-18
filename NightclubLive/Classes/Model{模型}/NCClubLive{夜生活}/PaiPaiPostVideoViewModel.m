//
//  PaiPaiPostVideoViewModel.m
//  NightclubLive
//
//  Created by WanBo on 17/2/7.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "PaiPaiPostVideoViewModel.h"
#import "AFNetworking.h"
#import "QiNiuUploadHelper.h"
#import "QiNiuSystemService.h"
#import "LiveRequest.h"
#import "QiniuTool.h"
#import "VideoTool.h"

@interface PaiPaiPostVideoViewModel()

@property (nonatomic, strong, readwrite) RACCommand *commintReuqesCommand;

@end

@implementation PaiPaiPostVideoViewModel

- (void)initialize {
    
    [super initialize];
}

- (RACCommand *)commintReuqesCommand{
    
    if (!_commintReuqesCommand){
        
        _commintReuqesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            
            RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    __block NSString *imgUrl = @"";
                    __block NSString *videoUrl = @"";
                    
                    QiniuTool *tool = [QiniuTool shareTool];
                    dispatch_group_t group = dispatch_group_create();
                    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
                    
                    //进入等待
                    dispatch_group_enter(group);
                    dispatch_group_enter(group);
                    
                    
                    //1.上传封面图片
                    dispatch_group_async(group, queue, ^{
                        
                        [tool uploadImages:self.imageArr type:UploadTypeSpaceTypePaipai success:^(id value) {
                            imgUrl = [value firstObject];
                            dispatch_group_leave(group);
                        } failure:^(NSError *error) {
                            dispatch_group_leave(group);
                        }];
                        
                        
                    });
                    
                    // 2.上传视频
                    dispatch_group_async(group, queue, ^{
                        
                        [tool uploadVideo:self.videoUrl type:UploadTypeSpaceTypePaipai success:^(id value) {
                            videoUrl = value;
                            dispatch_group_leave(group);
                        } failure:^(NSError *error) {
                            dispatch_group_leave(group);
                        }];
                    });
                    
                    dispatch_group_wait(group,dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 20));
                    dispatch_group_notify(group, queue, ^{
                        
                        UserInfo *user = [UserInfo shareUser];
                        
                        //3.上传资料登录资料上传完毕
                        PaiPaiPostVideoRequest *r = [PaiPaiPostVideoRequest new];
                        
                        //获取视频长度
                        VideoTool *tool = [[VideoTool alloc] initWithURL:self.videoUrl];
                        
                        NSMutableDictionary *param = [[NSMutableDictionary alloc]initWithDictionary:@{@"userId":user.userID,@"videoUrl":videoUrl,@"coverUrl":imgUrl,@"content":self.content,@"longitude":user.location.lclongitude,@"latitude":user.location.lclatitude,@"city":user.location.lccity,@"duration":@(tool.timeLength)}];
                        
                        if (_address.length > 0)
                            [param setValue:_address forKey:@"releaseAddress"];
                        
                        r.param = [param copy];
                        
                        [r startWithCompletedBlock:^(GJBaseRequest *request) {
                            
                            ResponseState *state = [ResponseState objectWithDic:request.responseObject];
                            
                            [subscriber sendNext:state];
                            [subscriber sendCompleted];
                        }];
                        
                        
                    });
                    
                });
                
                
                return nil;
                
            }];
            
            return signal;
        }];
    }
    return _commintReuqesCommand;
}

@end
