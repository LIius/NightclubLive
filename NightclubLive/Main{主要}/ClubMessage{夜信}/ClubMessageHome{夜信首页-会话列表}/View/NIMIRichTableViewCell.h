//
//  NIMIRichTableViewCell.h
//  NightclubLive
//
//  富文本显示(纯文本,富文本)
//  Created by RDP on 2017/3/17.
//  Copyright © 2017年 WanBo. All rights reserved.
//
#import "NIMIChatTableViewCell.h"
@class TYAttributedLabel;

@interface NIMIRichTableViewCell : NIMIChatTableViewCell
/** 内容显示Lablel */
@property (nonatomic, strong) TYAttributedLabel *contentLab;
@end
