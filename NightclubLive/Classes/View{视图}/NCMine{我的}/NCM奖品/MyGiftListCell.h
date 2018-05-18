//
//  MyGiftListCell.h
//  NightclubLive
//
//  Created by RDP on 2017/4/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

static NSString *MyGiftListCellReuseID = @"MyGiftListCell";

@interface MyGiftListCell : ObjectTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mncLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendNamelabel;
@property (weak, nonatomic) IBOutlet UIImageView *userLogoIV;
@property (weak, nonatomic) IBOutlet UILabel *prizeNameLabel;

@end
