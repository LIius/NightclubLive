//
//  AuthenticationCell.h
//  NightclubLive
//
//  Created by SuperDanny on 2017/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//
//  认证信息Cell

#import <UIKit/UIKit.h>

@interface AuthenticationCell : UITableViewCell

+ (CGFloat)cellHeight;
- (void)configureDataWithModel:(id)model;

@end
