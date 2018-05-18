//
//  PackageListCell.h
//  NightclubLive
//
//  Created by RDP on 2017/6/29.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"
static NSString *PackageListCellReuseID = @"PackageListCell";
@interface PackageListCell : ObjectTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *packageIV;
@property (weak, nonatomic) IBOutlet UILabel *packageNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *packNowPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;

/** 点击查看 */
@property (nonatomic, copy) CalkBackBlock seeDetailsBlock;


@end
