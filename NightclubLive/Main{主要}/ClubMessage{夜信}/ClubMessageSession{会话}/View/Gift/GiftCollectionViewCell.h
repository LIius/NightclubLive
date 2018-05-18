//
//  GiftCollectionViewCell.h
//  NightclubLive
//
//  Created by RDP on 2017/3/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectCollectionViewCell.h"

static NSString *GiftCollectionViewCellReuseID = @"GiftCollectionViewCell";

@interface GiftCollectionViewCell : ObjectCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *giftIV;
@property (weak, nonatomic) IBOutlet UILabel *giftNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftYBTLabel;

@end
