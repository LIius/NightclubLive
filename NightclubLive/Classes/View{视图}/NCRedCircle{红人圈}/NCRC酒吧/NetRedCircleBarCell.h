//
//  NetRedCircleBarCell.h
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

static NSString *NetRedCircleBarCellReuseID = @"NetRedCircleBarCell";

@interface NetRedCircleBarCell : ObjectTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *barLogoIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *logoBackV;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *barTypeIV;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tuijianIV;

@end
