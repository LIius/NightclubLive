//
//  MyNextCell.h
//  NightclubLive
//
//  Created by RDP on 2017/4/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

static NSString *MyNextCellReuseID = @"MyNextCell";

@interface MyNextCell : ObjectTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
