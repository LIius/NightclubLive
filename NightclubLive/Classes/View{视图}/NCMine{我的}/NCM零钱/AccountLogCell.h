//
//  AccountLogCell.h
//  NightclubLive
//
//  Created by rdp on 2017/5/25.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

static NSString *AccountLogCellReuseID = @"AccountLogCell";
@interface AccountLogCell : ObjectTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeIV;
@property (weak, nonatomic) IBOutlet UILabel *logNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@end
