//
//  PaiPaiHomeCell.m
//  NightclubLive
//
//  Created by WanBo on 16/12/4.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "PaiPaiHomeCell.h"
#import "PaiPaiModel.h"


@implementation PaiPaiHomeLayout

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    self.itemSize = CGSizeMake((SCREEN_WIDTH-10)/2, 215);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.minimumLineSpacing = 14;
}

@end


@implementation PaiPaiHomeCell

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PaiPaiHomeCell" owner:self options:nil];
        if(array.count < 1)
            return nil;
        if(![[array firstObject] isKindOfClass:[UICollectionViewCell class]])
            return nil;
        self = [array firstObject];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
}
- (void)bindModel:(PaiPaiModel *)model
{
    self.titleLable.text = model.user.userName;
    self.subtitleLable.text = model.content;
    _cityLabel.text = model.city;
    
    [_imageView autoAdjustHeight];
    
    // [_imageView sd_setImageWithURL:URL(model.coverUrl) placeholderImage:[UIImage picturePlaceholder] options:SDWebImageProgressiveDownload];
    
    [_imageView sd_setImageWithURL:URL(model.coverUrl) placeholderImage:[UIImage picturePlaceholder]];
    
    [_imageView autoAdjustWidth];
    
    [_iconImageV sd_setImageWithURL:model.user.profilePhoto placeholderImage:[UIImage userPlaceholder]];
}

@end



