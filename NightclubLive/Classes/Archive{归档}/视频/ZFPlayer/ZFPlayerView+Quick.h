//
//  ZFPlayerView+Quick.h
//  NightclubLive
//
//  Created by RDP on 2017/3/16.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ZFPlayer.h"

@interface ZFPlayerView (Quick)

/**
 *  创建播放器
 *
 *  @param superView  父视图
 *  @param title      播放标题
 *  @param coverURL   封面图
 *  @param videoURL   视频连接
 */
+ (instancetype)quickInitSuperView:(UIView *)superView title:(NSString *)title coverURL:(NSURL *)coverURL video:(NSURL *)videoURL;
@end
