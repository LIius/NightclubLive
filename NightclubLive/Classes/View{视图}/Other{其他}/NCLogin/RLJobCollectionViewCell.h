//
//  RLJobCollectionViewCell.h
//  NightclubLive
//
//  Created by RDP on 2017/4/7.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectCollectionViewCell.h"

static NSString *RLJobCollectionViewCellReuseID = @"RLJobCollectionViewCell";

@interface RLJobCollectionViewCell : ObjectCollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *jobNameLabel;

@end
