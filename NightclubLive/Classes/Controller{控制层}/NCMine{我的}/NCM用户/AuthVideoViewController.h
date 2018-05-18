//
//  AuthVideoViewController.h
//  NightclubLive
//
//  Created by RDP on 2017/7/29.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectViewController.h"

@interface AuthVideoViewController : ObjectViewController

/** 视频认证cover */
@property (nonatomic, weak) NSURL *coverURL;
@property (nonatomic, weak) UIImage *coverImage;
/** 封面 */
@property (nonatomic, weak) NSURL *videoURL;

@end
