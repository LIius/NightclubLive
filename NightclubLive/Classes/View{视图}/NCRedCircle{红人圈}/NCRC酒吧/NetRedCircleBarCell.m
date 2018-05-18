//
//  NetRedCircleBarCell.m
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NetRedCircleBarCell.h"
#import "NetRedCircleListModel.h"




@implementation NetRedCircleBarCell

- (void)awakeFromNib{
    [super awakeFromNib];

}

- (void)setModel:(NetRedCircleBarModel *)model{
    
    [super setModel:model];
    
    [_barLogoIV sd_setImageWithURL:model.logoURL placeholderImage:[UIImage picturePlaceholder] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_barLogoIV autoAdjustWidth];
    }];
    
    _nameLabel.text = model.seller_name;
    _distanceLabel.text = model.distance;
    _contentLabel.text = model.address;
    _tuijianIV.hidden = !model.isHot;
    
    NSArray *nameArr = @[@"icon_qingba",@"icon_jiubafirst",@"icon_KTV"];
    NSString *imagename = [nameArr stringAtIndex:model.barType];

    _barTypeIV.image = KGetImage(imagename);

    //更新
    [self layoutIfNeeded];
    
    BOOL isContain =  CGRectContainsRect(_nameLabel.frame, _distanceLabel.frame);
    
    [self layoutIfNeeded];
}

@end
