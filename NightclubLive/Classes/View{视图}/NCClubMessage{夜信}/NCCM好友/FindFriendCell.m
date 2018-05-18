//
//  FindFriendCell.m
//  NightclubLive
//
//  Created by RDP on 2017/4/10.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "FindFriendCell.h"
#import "User.h"

@implementation FindFriendCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    /*_logoIV.layer.cornerRadius = 50;
    _logoIV.layer.masksToBounds = YES;*/
}

- (void)setModel:(DataUser *)model{
    
    [super setModel:model];
    
    _nameLabel.text = model.userName;
    _idLabel.text = [NSString stringWithFormat:@"ID:%@",model.phoneNum];
    [_logoIV sd_setImageWithURL:model.profilePhoto placeholderImage:[UIImage userPlaceholder]];
}
@end
