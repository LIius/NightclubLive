//
//  MerchantActivityCell.h
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

static NSString *MerchantActivityCellReuseID = @"MerchantActivityCell";

@interface MerchantActivityCell : ObjectTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *giftIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentIV;
@end
