//
//  PaPaDetailCell.m
//  NightclubLive
//
//  Created by WanBo on 16/12/8.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "PaPaDetailCell.h"
#import "Comment.h"


#import "BlocksKit+UIKit.h"
@implementation PaPaDetailCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    @weakify(self);
    [_pBtn bk_whenTapped:^{
        @strongify(self);
        if (self.praiseBlock)
            self.praiseBlock(self.indexPath);
    }];
    
    [_rBtn bk_whenTapped:^{
        @strongify(self);
        if (self.replyBlock)
            self.replyBlock(self.model);
    }];
    
    [_dBtn bk_whenTapped:^{
        @strongify(self);
        if (self.deleteBlock)
            self.deleteBlock(self.indexPath);
    }];
}

- (void)setModel:(id)model
{
    [super setModel:model];
    
    CommentObject *c = (CommentObject *)model;
    
    NSString *userID = [NSString stringWithFormat:@"%ld",c.userId];
    DLog(@"%ld----%@",c.userId,[CurrentUser userID]);
    if ( [userID isEqualToString:[CurrentUser userID]])
    {
        _dBtn.hidden = NO;
    }else{
        _dBtn.hidden = YES;
    }

    
    [_logoImageView sd_setImageWithURL:c.from_user_img placeholderImage:[UIImage userPlaceholder]];

    
    {
        _nameLabel.text = c.from_user_name;
    }
    
    
    {
        NSDateFormatter *dft = [[NSDateFormatter alloc] init];
        [dft setDateFormat:@"yyyy-MM-dd"];
        self.timeLabel.text = [dft stringFromDate:c.createtime];
    }
    
    
    
    {
        [_pBtn setTitle:[NSString stringWithFormat:@"%ld",c.praise] forState:UIControlStateNormal];
        [_pBtn setImage:c.ispraise == 1 ? [UIImage praiseImage] : [UIImage nopraiseImage] forState:UIControlStateNormal];
        [_pBtn setTitleColor:c.ispraise == 1 ? [UIColor praiseColor] : [UIColor nopraiseColor] forState:UIControlStateNormal];
    }
    
    
    {
        NSString *content = nil;
        if (c.toUser)
        {
            content = [NSString stringWithFormat:@"回复%@ %@",c.toUser.userName,c.content];
        }
        else{
            content = c.content;
        }
        self.contentLabel.text = content;
    }
    
}

//- (IBAction)deleteBlock:(id)sender
//{
//    if (self.deleteBlock)
//        self.deleteBlock(self.indexPath);
//}

@end
