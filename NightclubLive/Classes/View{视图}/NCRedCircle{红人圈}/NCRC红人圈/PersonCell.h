//
//  PersonCell.h
//  NightclubLive
//
//  Created by RDP on 2017/6/30.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectCollectionViewCell.h"

static NSString *PersonCellReuseID = @"PersonCell";

@interface PersonCell : ObjectCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *countTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexIV;

@end
