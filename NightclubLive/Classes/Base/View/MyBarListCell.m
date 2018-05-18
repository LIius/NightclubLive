//
//  MyBarListCell.m
//  NightclubLive
//
//  Created by rdp on 2017/5/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MyBarListCell.h"
#import "MineModelList.h"

@implementation MyBarListCell

- (void)setModel:(BarBindModel *)model{
    
    [super setModel:model];
    
    [_logoIV sd_setImageWithURL:model.image placeholderImage:[UIImage picturePlaceholder]];
    _barNameLabel.text = model.name;
    _statueLabel.text = model.bindStatus ? @"已经绑定" : @"申请中";
    _statueIV.image = KGetImage(model.bindStatus ? @"icon_yibangding" : @"icon_shenqingzhong");
}

@end
