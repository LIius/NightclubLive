//
//  LogCell.h
//  NightclubLive
//
//  Created by RDP on 2017/4/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"


static NSString *LogCellReuseID = @"LogCell";

@interface LogCell : ObjectTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
