//
//  GiftCollectionViewCell.m
//  NightclubLive
//
//  Created by RDP on 2017/3/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GiftCollectionViewCell.h"
#import "GlobalModel.h"


@implementation GiftCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]){
        
        UICollectionViewCell *cell =  [[[NSBundle mainBundle] loadNibNamed:@"GiftCollectionViewCell" owner:nil options:nil] firstObject];
        
        return (GiftCollectionViewCell *)cell;
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    
    if (selected){
        /*self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.2];*/
        [self setBorderColor:RGBCOLOR(252, 235, 70) borderWidth:1];
    }
    else{
        /*self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:1.0];*/
        [self setBorderColor:RGBCOLOR(252, 235, 70) borderWidth:0];
    }
}

- (void)setModel:(GiftModel *)model{
    
    [super setModel:model];
    
    [_giftIV sd_setImageWithURL:model.gift_icon_url placeholderImage:[UIImage picturePlaceholder]];
    _giftNameLabel.text = model.gift_name;
    _giftYBTLabel.text = [NSString stringWithFormat:@"%@夜比特",model.night_bit];
}
@end
