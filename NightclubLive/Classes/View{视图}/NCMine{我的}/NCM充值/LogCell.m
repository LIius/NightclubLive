//
//  LogCell.m
//  NightclubLive
//
//  Created by RDP on 2017/4/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "LogCell.h"
#import "MineModelList.h"


@implementation LogCell


- (void)setModel:(RechargeLogModel *)model{
    
    [super setModel:model];
    
    _timeLabel.text = model.purchase_date.YMDSlashString;
    
    _moneyLabel.text = [NSString stringWithFormat:@"%@",model.order_subject];
    
}
@end
