//
//  MerchantActivityCell.m
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MerchantActivityCell.h"
#import "NetRedCircleListModel.h"


@implementation MerchantActivityCell

- (void)setModel:(BarActivityModel *)model{
    
    [super setModel:model];
    _titleLabel.text = model.party_name;
    [_contentIV sd_setImageWithURL:model.coverImage placeholderImage:[UIImage picturePlaceholder] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_contentIV autoAdjustWidth];
    }];
}

@end
