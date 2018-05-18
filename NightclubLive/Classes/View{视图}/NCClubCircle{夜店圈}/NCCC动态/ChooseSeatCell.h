//
//  ChooseSeatCell.h
//  NightclubLive
//
//  Created by RDP on 2017/6/29.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectCollectionViewCell.h"

static NSString * const ChooseSeatCellReuseID = @"ChooseSeatCell";

@interface ChooseSeatCell : ObjectCollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *seatNameLabel;

@end
