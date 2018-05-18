//
//  PaiPaiUpload.h
//  NightclubLive
//
/*
    拍拍上传视频管理,由于上传视频的地方偏多，所以抽离出来
 */
//  Created by RDP on 2017/8/26.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaiPaiUpload : NSObject
@property (nonatomic, copy) CalkBackBlock  completionBlock;

- (void)selectVideoSourceWithType:(NSInteger)sourceType sourceVC:(UIViewController *)sourceVC;

- (void)handelVideoURL:(NSURL *)videoURL sourceVC:(UIViewController *)sourceVC;

@end
