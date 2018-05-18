//
//  HomeBarCell.m
//  NightclubLive
//
//  Created by RDP on 2017/6/9.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "HomeBarCell.h"

#import "NetRedCircleListModel.h"



@implementation HomeBarCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self layoutIfNeeded];
    [self.backV setShadowColor:RGBACOLOR(90, 20, 67, 0.14) radius:2.5 opacity:10 offset:CGSizeMake(0, 0)];
}

- (void)setModel:(NetRedCircleBarModel *)model
{
    [super setModel:model];
    
    _barNameLabel.text = model.seller_name;
    _barAddressLabel.text = model.city;
    _barDistanceLabel.text = model.distance ;
 
    [_barLogoIV sd_setImageWithURL:model.logoURL placeholderImage:[UIImage picturePlaceholder] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
        [_barLogoIV autoAdjustWidth];
    }];
    
    NSArray *nameArr = @[@"icon_qingba",@"icon_jiubafirst",@"icon_KTV"];
    NSString *imagename = [nameArr stringAtIndex:model.barType];
    _barTypeIV.image = KGetImage(imagename);
}

@end
