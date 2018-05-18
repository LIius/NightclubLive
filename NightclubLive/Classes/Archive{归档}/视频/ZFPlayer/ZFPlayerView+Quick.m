//
//  ZFPlayerView+Quick.m
//  NightclubLive
//
//  Created by RDP on 2017/3/16.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ZFPlayerView+Quick.h"

@implementation ZFPlayerView (Quick)

+ (instancetype)quickInitSuperView:(UIView *)superView title:(NSString *)title coverURL:(NSURL *)coverURL video:(NSURL *)videoURL
{
   
    ZFPlayerView *playerView = [ZFPlayerView sharedPlayerView];
    playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    
    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    controlView.backBtn.hidden = YES;
    // model
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
    playerModel.fatherView = superView;
    playerModel.videoURL = videoURL;
    playerModel.placeholderImageURLString = coverURL.absoluteString;
    playerModel.title = title;
    
    
    [playerView playerControlView:controlView playerModel:playerModel];
    playerView.cellPlayerOnCenter = NO;
    // delegate    // auto play the video
    [playerView autoPlayTheVideo];
    
    return playerView;

}

@end
