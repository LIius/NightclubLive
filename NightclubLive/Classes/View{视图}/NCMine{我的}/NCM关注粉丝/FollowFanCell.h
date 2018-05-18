//
//  FollowFanCell.h
//  NightclubLive
//
//  Created by RDP on 2017/4/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

static NSString *FollowFanCellReuseID = @"FollowFanCell";

@interface FollowFanCell : ObjectTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;

@property (weak, nonatomic) IBOutlet UIButton *operationBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, copy) CalkBackBlock followBlock;
@end
