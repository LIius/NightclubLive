//
//  PackageDetailsCell.m
//  NightclubLive
//
//  Created by RDP on 2017/6/29.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "PackageDetailsCell.h"
#import "ClubCircleModelList.h"

@implementation PackageDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //self.backgroundColor = [UIColor blueColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(PackageDetailsListModel *)model{
    [super setModel:model];
    
    _nameLabel.text = model.name;
    _countLabel.text = [NSString stringWithFormat:@"x%@",model.number];
}
@end
