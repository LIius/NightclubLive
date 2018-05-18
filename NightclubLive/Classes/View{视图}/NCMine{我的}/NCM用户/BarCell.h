//
//  BarCell.h
//  NightclubLive
//
//  Created by SuperDanny on 2017/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//
//  酒吧Cell

#import <UIKit/UIKit.h>

@interface BarCell : UITableViewCell

+ (CGFloat)cellHeight;
- (void)configureDataWithModel:(id)model;

@end
