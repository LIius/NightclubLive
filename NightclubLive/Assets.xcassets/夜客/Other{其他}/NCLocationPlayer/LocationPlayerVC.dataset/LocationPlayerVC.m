//
//  LocationPlayerVC.m
//  NightclubLive
//
//  Created by RDP on 2017/8/30.
//  Copyright © 2017年 WanBo. All rights reserved.
//  ：播放本地的视频

#import <AVFoundation/AVFoundation.h>
#import "LocationPlayerVC.h"

@interface LocationPlayerVC ()

@end

@implementation LocationPlayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AVPlayer *player = [AVPlayer playerWithURL:self.playURL];
    self.player = player;
    [self.player play];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    if (_finishBlock)
        _finishBlock(nil);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
