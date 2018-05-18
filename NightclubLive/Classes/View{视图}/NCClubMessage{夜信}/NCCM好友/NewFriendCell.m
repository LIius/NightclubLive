//
//  NewFriendCell.m
//  NightclubLive
//
//  Created by RDP on 2017/4/10.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NewFriendCell.h"
#import "BlocksKit+UIKit.h"
@implementation NewFriendCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    @weakify(self);
    [_addBtn bk_whenTapped:^
    {
        @strongify(self);
        if (self.addBlock)
        {
            self.addBlock(self.indexPath);
        }
        
    }];
}

- (void)setModel:(NIMSystemNotification *)model{
    [super setModel:model];
    
    //根据ID获取用户信息
    NIMUser *user =  [[[NIMSDK sharedSDK] userManager] userInfo:model.sourceID];
    
    [_logoIV sd_setImageWithURL:URL(user.userInfo.avatarUrl) placeholderImage:[UIImage userPlaceholder]];
    _nameLab.text = user.userInfo.nickName;
    _idLab.text = model.postscript;
    
    BOOL isFriend = [[NIMSDK sharedSDK].userManager isMyFriend:user.userId];
    
    _addBtn.hidden = isFriend;
    _stateLabel.hidden = !isFriend;
    
}
@end
