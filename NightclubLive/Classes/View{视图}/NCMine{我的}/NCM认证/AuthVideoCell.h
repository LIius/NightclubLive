//
//  AuthVideoCell.h
//  NightclubLive
//
//  Created by RDP on 2017/9/11.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

@interface AuthVideoCell : ObjectTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *recordBtn;
@property (weak, nonatomic) IBOutlet UIImageView *playIV;
@property (weak, nonatomic) IBOutlet UIButton *palyBtn;
@property (weak, nonatomic) IBOutlet UILabel *passTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *noPassTipLabel;
@property (weak, nonatomic) IBOutlet UILabel *recordTipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoBackIV;

@end
