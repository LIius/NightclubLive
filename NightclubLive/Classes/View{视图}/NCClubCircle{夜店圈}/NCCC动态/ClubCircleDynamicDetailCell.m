//
//  ClubCircleDynamicDetailCell.m
//  NightclubLive
//
//  Created by WanBo on 16/12/2.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "ClubCircleDynamicDetailCell.h"



#import "BlocksKit+UIKit.h"
@implementation ClubCircleDynamicDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    @weakify(self);
    [_iconV bk_whenTapped:^{
        @strongify(self);
        if (self.logoBlock)
            self.logoBlock(self.indexPath);
    }];
}

//- (void)bindModel:(DynamicCommentListModel *)model{
//    
//    _nameLable.text = model.user.userName;
//    NSDateFormatter *dft = [[NSDateFormatter alloc] init];
//    [dft setDateFormat:@"yyyy-MM-dd"];
//    _timeLable.text = [dft stringFromDate:model.createtime];
////    [[_praiseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
////        if (_likeCallback) {
////            _likeCallback(model);
////        }
////    }];
//    
//    if ([model.toUserId intValue]!=0) {
//        _contentLable.text = [NSString stringWithFormat:@"回复%@ %@",model.toUser.userName,model.content];
//    }else{
//        _contentLable.text = model.content;
//    }
//    _model = model;
//}

- (void)setModel:(id)model{
    
    [super setModel:model];
    
    DynamicCommentListModel *m = model;

    _nameLable.text = m.from_user_name;

    NSDateFormatter *dft = [[NSDateFormatter alloc] init];
    [dft setDateFormat:@"yyyy-MM-dd"];
    _timeLable.text = [dft stringFromDate:m.createtime];
    
    if (m.toUserId) {
        if ([m.toUserId intValue]!=0)
        {
            _contentLable.text = [NSString stringWithFormat:@"回复%@ %@",m.toUser.userName,m.content];
        }else{
            _contentLable.text = m.content;
        }
    }
    
    
    [_iconV sd_setImageWithURL:m.from_user_img placeholderImage:[UIImage userPlaceholder]];
    //设置点赞数量
    [_praiseBtn setTitle:[NSString stringWithFormat:@"%ld",(long)m.praise] forState:UIControlStateNormal];
    [_praiseBtn setTitleColor:[UIColor praiseColorWithType:m.ispraise] forState:UIControlStateNormal];
    [_praiseBtn setImage:[UIImage praiseWithType:m.ispraise] forState:UIControlStateNormal];
    
    //判断是不是自己,如果是自己的话就显示删除按键
    _deleteBtn.hidden = ![CurrentUser.userID isEqualToString:m.userId];
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[DynamicCommentListModel class]])
    {
        DynamicCommentListModel *model = (DynamicCommentListModel *)obj;
        CGFloat curWidth = kScreenWidth-68;
            cellHeight += 50+8+ [model.content getHeightWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:CGSizeMake(curWidth, CGFLOAT_MAX)];
        
        NSLog(@"%f",cellHeight);
    }
    return cellHeight;
}
//回复
- (IBAction)replyAction:(id)sender {
    //
    if (_replayCallback) {
        _replayCallback(self.model);
    }
}

//点赞
- (IBAction)praiseClick:(id)sender {
    
    if (_praiseBlock){
        _praiseBlock(self.model);
    }
}

//删除
- (IBAction)deleteClick:(id)sender {
    
    if (_deleteBlock)
        _deleteBlock(self.indexPath);
}



@end
