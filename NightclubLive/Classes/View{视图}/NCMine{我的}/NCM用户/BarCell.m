//
//  BarCell.m
//  NightclubLive
//
//  Created by SuperDanny on 2017/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "BarCell.h"

@implementation BarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight {
    return 50;
}

- (void)configureDataWithModel:(id)model {
    
}

@end
