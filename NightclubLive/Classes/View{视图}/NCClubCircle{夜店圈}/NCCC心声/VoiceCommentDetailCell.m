//
//  VoiceCommentDetailCell.m
//  NightclubLive
//
//  Created by WanBo on 16/12/30.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "VoiceCommentDetailCell.h"

#import "VoiceCommentModel.h"
#import "BlocksKit+UIKit.h"
@implementation VoiceCommentDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    @weakify(self);
    [_praiseBtn bk_whenTapped:^{
        @strongify(self);
        if (self.praiseBlock)
            self.praiseBlock(self.indexPath);
    }];
    
    [_replyBtn bk_whenTapped:^{
        @strongify(self);
        if (self.replayCallback)
            self.replayCallback(self.indexPath);
    }];
    
    
    [_iconV bk_whenTapped:^{
        @strongify(self);
        if (self.logoBlock)
            self.logoBlock(self.indexPath);
    }];
    
}

- (void)setModel:(VoiceCommentListModel  *)model{
    
    [super setModel:model];

    _addressLable.text = model.user.address.length>0?model.user.address:@"未知";
    _timeLable.text = model.createtime;
    if ([model.toUserId intValue]!=0) {
        _contentLable.text = [NSString stringWithFormat:@"回复%@:%@",model.toUser.userName,model.content];
    }else{
        _contentLable.text = model.content;
    }
    
    [self.iconV sd_setImageWithURL:model.from_user_img placeholderImage:[UIImage userPlaceholder]];
    self.nameLable.text = model.from_user_name;
    
    [_praiseBtn setImage:[UIImage praiseWithType:model.ispraise]forState:UIControlStateNormal];
    
    [_praiseBtn setTitleColor:model.ispraise == 1 ? APPDefaultColor : [UIColor grayColor] forState:UIControlStateNormal];

    [_praiseBtn setTitle:[NSString stringWithFormat:@"点赞(%ld)",model.praise] forState:UIControlStateNormal];
    
    //判断是不是自己的回复
    _deleteBtn.hidden = ![CurrentUser.userID isEqualToString:model.userId];
}

- (IBAction)deleteClick:(id)sender
{
    if (_deleteBlock)
        _deleteBlock(self.indexPath);
}

@end
