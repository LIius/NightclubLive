//
//  NetRedCircleRankCell.h
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

static NSString *NetRedCircleRankCellReuseID = @"NetRedCircleRankCell";

@interface NetRedCircleRankCell : ObjectTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeIV;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *charmLabel;
/** 显示类型 魅力榜还是土豪榜 */
@property (nonatomic, assign) NSInteger showRankListType;

@end
