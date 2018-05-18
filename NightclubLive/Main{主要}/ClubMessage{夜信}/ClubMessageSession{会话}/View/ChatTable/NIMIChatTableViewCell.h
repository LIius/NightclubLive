//
//  NIMIChatTableViewCell.h
//  NightclubLive
//
//  聊天基本类
//  两个个基本控件
//  对方的头像，我的头像，时间
//  Created by RDP on 2017/3/17.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NIMIBaseTableViewCell.h"

@interface NIMIChatTableViewCell : NIMIBaseTableViewCell
/** 时间显示 */
@property (nonatomic, strong) UILabel *timeLab;
/** 头像IV 对方显示在左边 自己显示在右边 根据内容判断*/
@property (nonatomic, strong) UIImageView *logoIV;
@end
