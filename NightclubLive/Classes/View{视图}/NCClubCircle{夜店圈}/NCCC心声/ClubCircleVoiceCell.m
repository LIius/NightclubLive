//
//  ClubCircleVoiceCell.m
//  NightclubLive
//
//  Created by WanBo on 16/12/2.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "ClubCircleVoiceCell.h"

@implementation ClubCircleVoiceCell

- (void)bindModel:(VoiceListModel *)model{

    _titleLable.text = model.title;
    _commentLable.text = model.memberNum;
    //[_imageV sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"placeholder"] options:SDWebImageProgressiveDownload];

    [_imageV sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
}


@end
