//
//  BlacklistCell.h
//  NightclubLive
//
//  Created by SuperDanny on 2017/1/17.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

@interface BlacklistCell : ObjectTableViewCell

+ (CGFloat)cellHeight;
- (void)configureDataWithModel:(id)model;

@property(nonatomic,strong)NIMUser *nUserModel;

@end
