//
//  CarCertificationCell.h
//  NightclubLive
//
//  Created by RDP on 2017/5/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

static NSString *CarCertificationCellReuseID = @"CarCertificationCell";

@interface CarCertificationCell : ObjectTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *carIV;
@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *statusIV;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;

@end
