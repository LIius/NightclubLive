//
//  PersonCell.m
//  NightclubLive
//
//  Created by RDP on 2017/6/30.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "PersonCell.h"
#import "NetRedCircleListModel.h"



@implementation PersonCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = RGBCOLOR(206, 206, 206).CGColor;
}

- (void)setModel:(FindUserModel *)model
{
    [super setModel:model];
    
    if(!model)
    {
        return;
    }

    [_logoIV sd_setImageWithURL:model.profilePhoto placeholderImage:[UIImage userPlaceholder] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_logoIV autoAdjustWidth];
    }];
    
    _nameLabel.text = model.userName;
    _distanceLabel.text = model.city;
    _countLabel.text = model.order_count;
    
    if (model.sex >=0 && model.sex <= 1)
    {
        NSArray *nameArr = @[@"icon_female-1",@"icon_male-1"];
        NSString *sexName = [nameArr stringAtIndex:model.sex];
        _sexIV.image = KGetImage(sexName);
    }
}
@end
