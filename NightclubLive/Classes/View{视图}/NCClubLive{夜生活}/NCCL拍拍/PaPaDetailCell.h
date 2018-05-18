//
//  PaPaDetailCell.h
//  NightclubLive
//
//  Created by WanBo on 16/12/8.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

@interface PaPaDetailCell : ObjectTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *pBtn;
@property (weak, nonatomic) IBOutlet UIButton *rBtn;
@property (weak, nonatomic) IBOutlet UIButton *dBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

/** 点赞 */
@property (nonatomic, copy) CalkBackBlock praiseBlock;
@property (nonatomic, copy) CalkBackBlock replyBlock;
/** 删除 */
@property (nonatomic, copy) CalkBackBlock deleteBlock;

@end

