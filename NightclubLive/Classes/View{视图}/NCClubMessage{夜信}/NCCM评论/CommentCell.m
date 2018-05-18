//
//  CommentCell.m
//  NightclubLive
//
//  Created by RDP on 2017/7/5.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "CommentCell.h"
#import "MessageModelList.h"

@implementation CommentCell

- (void)awakeFromNib{
    [super awakeFromNib];
    _logoIV.layer.cornerRadius =  19;
    _logoIV.layer.masksToBounds = YES;
}

- (void)setModel:(CommentModel *)model{
    [super setModel:model];
    
    _nameLabel.text = model.from_user_name;
    [_logoIV sd_setImageWithURL:model.from_user_img placeholderImage:[UIImage userPlaceholder]];
    _timeLabel.text = model.date;
    _contentLabel.text = model.content;
}
@end
