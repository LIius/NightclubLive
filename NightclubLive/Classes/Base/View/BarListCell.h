//
//  BarListCell.h
//  NightclubLive
//
//  Created by RDP on 2017/4/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

static NSString *BarListCellReuseID = @"BarListCell";

@interface BarListCell : ObjectTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *barLogoIV;
@property (weak, nonatomic) IBOutlet UILabel *barNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;

@end
