//
//  PostVideoPlayerController.h
//  MKCustomCamera
//
//  Created by ykh on 16/1/6.
//  Copyright © 2016年 MK. All rights reserved.
//  完善信息

#import "BaseViewController.h"

@interface PostVideoPlayerController : BaseViewController

@property (nonatomic,strong) NSURL *videoUrl;

/** 视频来源 */
@property (nonatomic, assign) NSInteger sourceType;

@end
