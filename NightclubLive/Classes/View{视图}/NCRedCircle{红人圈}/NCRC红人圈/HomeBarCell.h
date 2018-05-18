//
//  HomeBarCell.h
//  NightclubLive
//
//  Created by RDP on 2017/6/9.
//  Copyright © 2017年 WanBo. All rights reserved.
//
#import "ObjectCollectionViewCell.h"

@interface HomeBarCell : ObjectCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *barLogoIV;
@property (weak, nonatomic) IBOutlet UIView *barContentView;
@property (weak, nonatomic) IBOutlet UIImageView *barTypeIV;
@property (weak, nonatomic) IBOutlet UILabel *barNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *barAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *barDistanceLabel;
@property (weak, nonatomic) IBOutlet UIView *backV;

@end
