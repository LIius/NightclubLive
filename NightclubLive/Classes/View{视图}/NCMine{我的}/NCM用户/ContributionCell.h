//
//  ContributionCell.h
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

static NSString *ContributionCellReuseID = @"ContributionCell";

@interface ContributionCell : ObjectTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *numIV;
@property (weak, nonatomic) IBOutlet UILabel *ybtLabel;
@end
