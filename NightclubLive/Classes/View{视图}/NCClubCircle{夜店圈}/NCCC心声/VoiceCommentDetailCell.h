//
//  VoiceCommentDetailCell.h
//  NightclubLive
//
//  Created by WanBo on 16/12/30.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"
//#import "VoiceCommentModel.h"


@interface VoiceCommentDetailCell : ObjectTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UILabel *stauesLable;
@property (weak, nonatomic) IBOutlet UILabel *likeLable;
@property (weak, nonatomic) IBOutlet UIButton *replyBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

/** 回复 */
@property (nonatomic, copy) VoidBlock_id replayCallback;
/** 点赞 */
@property (nonatomic, copy) CalkBackBlock praiseBlock;
@property (nonatomic, copy) CalkBackBlock logoBlock;
/** 删除按键 */
@property (nonatomic, copy) CalkBackBlock deleteBlock;

@end
