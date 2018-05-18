//
//  PackageDetailsCell.h
//  NightclubLive
//
//  Created by RDP on 2017/6/29.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

static NSString *PackageDetailsCellReuseID = @"PackageDetailsCell";

@interface PackageDetailsCell : ObjectTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end
