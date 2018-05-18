//
//  ClubCircleDynamicDetailCell.h
//  NightclubLive
//
//  Created by WanBo on 16/12/2.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicCommentListModel.h"
#import "ObjectTableViewCell.h"

@interface ClubCircleDynamicDetailCell : ObjectTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (nonatomic, copy) VoidBlock_id likeCallback;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *huifuBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (nonatomic, copy) VoidBlock_id replayCallback;
@property (nonatomic, copy) CalkBackBlock logoBlock;
/** 删除回调 */
@property (nonatomic, copy) CalkBackBlock deleteBlock;

//@property (nonatomic, copy) DynamicCommentListModel *model;
/**
 *  点赞注释
 */
@property (nonatomic, copy) CalkBackBlock praiseBlock;


- (void)bindModel:(DynamicCommentListModel *)model;
+ (CGFloat)cellHeightWithObj:(id)obj;

@end
