//
//  BarListCell.m
//  NightclubLive
//
//  Created by RDP on 2017/4/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "BarListCell.h"

#import "MineModelList.h"

@implementation BarListCell

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setBorderColor:RGBCOLOR(230, 230, 230) borderWidth:1];
    self.layer.cornerRadius = 10;

}

- (void)setFrame:(CGRect)frame{
    
    frame.origin.y += 10;
    frame.origin.x += 10;
    frame.size.width -= 20;
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)setModel:(BarModel *)model{
    [super setModel:model];
    
    _barNameLabel.text = model.name;
    [_barLogoIV sd_setImageWithURL:model.image placeholderImage:[UIImage picturePlaceholder]];
    _addressLable.text = model.address;
}
@end
