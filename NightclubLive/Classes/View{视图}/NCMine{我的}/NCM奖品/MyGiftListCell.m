//
//  MyGiftListCell.m
//  NightclubLive
//
//  Created by RDP on 2017/4/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MyGiftListCell.h"
#import "MineModelList.h"


@implementation MyGiftListCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    _userLogoIV.layer.masksToBounds = YES;
}

- (void)setModel:(MyGiftListModel *)model{
    [super setModel:model];
    
    [_userLogoIV sd_setImageWithURL:model.profile_photo placeholderImage:[UIImage userPlaceholder]];
    _prizeNameLabel.text = model.gift_name;

    _sendNamelabel.text = [NSString stringWithFormat:@"赠送人：%@",model.user_name];
    
    _timeLabel.text = model.create_time.YMDSlashString;
    
    _mncLabel.text = [NSString stringWithFormat:@"+%@零钱",model.saya_currency_value];
    
}

@end
