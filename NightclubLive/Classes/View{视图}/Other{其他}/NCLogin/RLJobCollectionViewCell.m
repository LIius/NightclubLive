//
//  RLJobCollectionViewCell.m
//  NightclubLive
//
//  Created by RDP on 2017/4/7.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "RLJobCollectionViewCell.h"
#import "GlobalModel.h"

@implementation RLJobCollectionViewCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.layer.cornerRadius = self.height * 0.5;
    
    self.layer.borderColor = RGBCOLOR(153, 153, 153).CGColor;
    self.layer.borderWidth = 0.5;

}

- (void)setModel:(id)model{
    
    [super setModel:model];
    
    JobModel *m = model;
    
    _jobNameLabel.text = m.name;
    
}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    //选中
    if (selected){
    
        self.backgroundColor = RGBCOLOR(205, 79, 161);
        self.jobNameLabel.textColor = [UIColor whiteColor];
        self.layer.borderWidth = 0;
    }
    else{
        self.backgroundColor = [UIColor whiteColor];
        self.jobNameLabel.textColor = RGBCOLOR(153, 153, 153);
        self.layer.borderWidth = 0.5;
    }
}
@end
