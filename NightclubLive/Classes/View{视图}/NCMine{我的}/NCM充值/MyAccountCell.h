//
//  MyAccountCell.h
//  NightclubLive
//
//  Created by RDP on 2017/4/13.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectCollectionViewCell.h"

static NSString *MyAccountCellReuseID = @"MyAccountCell";

@interface MyAccountCell : ObjectCollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nightBitLabel;
@property (weak, nonatomic) IBOutlet UILabel *rmbLabel;

@end
