//
//  ChooseSeatCell.m
//  NightclubLive
//
//  Created by RDP on 2017/6/29.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ChooseSeatCell.h"

@implementation ChooseSeatCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = RGBCOLOR(160, 160, 160).CGColor;
}


- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    if (selected){
        self.backgroundColor = RGBCOLOR(205, 79, 161);
        self.seatNameLabel.textColor = RGBCOLOR(255, 255, 255);
        self.layer.borderWidth = 0;
    }else{
        self.backgroundColor = RGBCOLOR(255, 255, 255);
        self.seatNameLabel.textColor = [UIColor blackColor];
        self.layer.borderWidth = 0.5;
        
    }
}

- (void)setTag:(NSInteger)tag{
    
    [super setTag:tag];
    
    
    if (tag == 1){//不可选
        self.backgroundColor = RGBCOLOR(190, 190, 190);
        self.seatNameLabel.textColor = RGBCOLOR(255, 255, 255);
        self.userInteractionEnabled = NO;
    }
    else{//可选
        [self setSelected:self.isSelected];
        self.userInteractionEnabled = YES;
    }
}

@end
