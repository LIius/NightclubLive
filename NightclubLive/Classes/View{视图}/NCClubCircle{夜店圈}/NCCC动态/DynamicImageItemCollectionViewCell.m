//
//  DynamicImageItemCollectionViewCell.m
//  NightclubLive
//
//  Created by RDP on 2017/3/1.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "DynamicImageItemCollectionViewCell.h"
#import "DynamicListModel.h"


@interface DynamicImageItemCollectionViewCell()

@end

@implementation DynamicImageItemCollectionViewCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self layoutIfNeeded];
    
//    [self setShadowColor:RGBACOLOR(61, 9, 66, 0.3) radius:5 opacity:10 offset:CGSizeMake(0, 0)];
    [self setShadowColor:RGBACOLOR(61, 9, 33, 0.3) radius:2.5 opacity:10 offset:CGSizeMake(0, 0)];
}

- (void)setModel:(id)model{
}

- (void)setFrame:(CGRect)frame{
    
    [super setFrame:frame];
    
  //  _itemImageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}
@end
