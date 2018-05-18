//
//  LocationPlayerVC.h
//  NightclubLive
//
//  Created by RDP on 2017/8/30.
//  Copyright © 2017年 WanBo. All rights reserved.
//  ：播放本地的视频

#import <AVKit/AVKit.h>

@interface LocationPlayerVC : AVPlayerViewController

@property (nonatomic, copy) CalkBackBlock  finishBlock;
@property (nonatomic, strong) NSURL  *playURL;

@end
