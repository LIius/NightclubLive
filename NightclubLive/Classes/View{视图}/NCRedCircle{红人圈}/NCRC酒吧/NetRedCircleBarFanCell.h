//
//  NetRedCircleBarFanCell.h
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

static NSString *NetRedCircleBarFanCellReuseID = @"NetRedCircleBarFanCell";

@interface NetRedCircleBarFanCell : ObjectTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *designLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;
@property (weak, nonatomic) IBOutlet UIButton *invitionBtn;
@property (weak, nonatomic) IBOutlet UILabel *ybtLabel;
@property (weak, nonatomic) IBOutlet UIView *logoBackV;
@property (weak, nonatomic) IBOutlet UIImageView *rankIV;
/** 显示类型 0- 魅力达人 1-泡吧达人*/
@property (weak, nonatomic) IBOutlet UIImageView *ybtIV;
@property (nonatomic, assign) NSInteger showType;
@property (weak, nonatomic) IBOutlet UIImageView *sexIV;
/** 约台按键回调 */
@property (nonatomic, copy) CalkBackBlock appointmentBlock;


@end
