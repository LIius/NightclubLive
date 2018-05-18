//
//  ImageCollectionViewCell.m
//  NightclubLive
//
//  Created by RDP on 2017/3/11.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ImageCollectionViewCell.h"

#import "MineModelList.h"

@implementation ImageCollectionViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)setModel:(UIImage *)model{
    [super setModel:model];
    
    _imgIV.image = model;
    
    [_imgIV autoAdjustWidth];
}

- (IBAction)closeClick:(id)sender {
    
    self.calkBlock(self.indexPath);
}

- (IBAction)selectClick:(UIButton *)sender {

    self.photomodel.selects[self.indexPath.row] = @(![self.photomodel.selects[self.indexPath.row] boolValue]);
    sender.selected = !sender.selected;
    if (![self.photomodel.selects[self.indexPath.row] boolValue])
        [_selectBtn setImage:KGetImage(@"icon_gouxuankuangoff") forState:UIControlStateNormal];
    else
        [_selectBtn setImage:KGetImage(@"icon_gouxuankuangon") forState:UIControlStateNormal];
}

- (void)setPhotomodel:(PhotoAlbumList *)photomodel{
    
    _photomodel = photomodel;
    
    if (![self.photomodel.selects[self.indexPath.row] boolValue])
        [_selectBtn setImage:KGetImage(@"icon_gouxuankuangoff") forState:UIControlStateNormal];
    else
        [_selectBtn setImage:KGetImage(@"icon_gouxuankuangon") forState:UIControlStateNormal];
}

- (void)setFrame:(CGRect)frame{
    
    if (self.isAdjust){
        
        CGRect frame = self.frame;
        frame.size.width -= 14;
        frame.origin.x += 7;
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        
        maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;

    }
    
    [super setFrame:frame];
}

@end
