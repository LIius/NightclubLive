//
//  AuthVideoCell.m
//  NightclubLive
//
//  Created by RDP on 2017/9/11.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AuthVideoCell.h"
#import "AuthModel.h"


@implementation AuthVideoCell

- (void)setModel:(AuthVideoModel *)model{

    [super setModel:model];
    
    //设置背景
    [_videoBackIV sd_setImageWithURL:model.coverUrl placeholderImage:[UIImage picturePlaceholder] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_videoBackIV autoAdjustWidth];
    }];
    
  //  _playIV.hidden = YES;
    _recordBtn.hidden = YES;
    _recordTipLabel.hidden = YES;
    
    _noPassTipLabel.hidden = !(model.status == 0);
    _passTipLabel.hidden   = !_noPassTipLabel.hidden;
}

@end
