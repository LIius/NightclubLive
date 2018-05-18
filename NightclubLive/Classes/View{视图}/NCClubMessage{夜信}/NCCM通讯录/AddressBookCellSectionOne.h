//
//  AddressBookCellSectionOne.h
//  NightclubLive
//
//  Created by RDP on 2017/4/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

@class NIMUser;

@interface AddressBookCellSectionOne : ObjectTableViewCell

@property (nonatomic,strong)NIMUser *userModel;

+ (CGFloat)cellHeight;

@end
