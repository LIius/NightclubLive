//
//  SignCell.h
//  NightclubLive
//
//  Created by SuperDanny on 2017/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//
//  个性签名Cell

#import <UIKit/UIKit.h>

@interface SignCell : UITableViewCell

+ (CGFloat)cellHeightWithModel:(id)model;
- (void)configureDataWithModel:(id)model;

@end
