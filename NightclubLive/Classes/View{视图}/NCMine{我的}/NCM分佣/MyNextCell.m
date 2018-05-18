//
//  MyNextCell.m
//  NightclubLive
//
//  Created by RDP on 2017/4/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MyNextCell.h"
#import "MineModelList.h"


@implementation MyNextCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self layoutIfNeeded];
    
    self.logoIV.layer.cornerRadius = 21;
    
    self.logoIV.layer.masksToBounds = YES;
}

- (void)setModel:(MyNextListModel *)model{
    
    [super setModel:model];
    
    _nameLabel.text = model.user_name;
    [_logoIV sd_setImageWithURL:model.profile_photo placeholderImage:[UIImage userPlaceholder]];
    _timeLabel.text = [NSString stringWithFormat:@"%@ 加入",model.createtime.YMDSlashString];
}

@end
