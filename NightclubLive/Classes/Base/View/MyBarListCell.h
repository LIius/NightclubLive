//
//  MyBarListCell.h
//  NightclubLive
//
//  Created by rdp on 2017/5/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

static NSString *MyBarListCellReuseID = @"MyBarListCell";

@interface MyBarListCell : ObjectTableViewCell
/** 绑定状态图片 */
@property (weak, nonatomic) IBOutlet UIImageView *statueIV;
@property (weak, nonatomic) IBOutlet UILabel *barNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@end
