//
//  MyPrizeListCell.h
//  NightclubLive
//
//  Created by RDP on 2017/4/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

static NSString *MyPrizeListCellReuseID = @"MyPrizeListCell";

@interface MyPrizeListCell : ObjectTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UILabel *prizeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic, copy) CalkBackBlock getBlock;
@property (nonatomic, copy) CalkBackBlock seeBlock;
@property (weak, nonatomic) IBOutlet UILabel *campaignNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@end
