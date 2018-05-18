//
//  UserDynamicCell.m
//  NightclubLive
//
//  Created by RDP on 2017/4/17.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "UserDynamicCell.h"
#import "DynamicListModel.h"


#import "NSDate+Utilities.h"


@interface UserDynamicCell()

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentIV;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end
@implementation UserDynamicCell


- (void)setModel:(DynamicListModel *)model{
    
    [super setModel:model];
    
    _cityLabel.text = model.city;
//    [_contentIV sd_setImageWithURL:URL([model.images firstObject]) placeholderImage:[UIImage userPlaceholder]];
//    
    [_contentIV sd_setImageWithURL:URL([model.images firstObject]) completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_contentIV autoAdjustWidth];
    }];
    
    _contentLabel.text = model.content;
    
    _dayLabel.text = [NSString stringWithFormat:@"%0.2ld日",model.createtime.month];
    _monthLabel.text = [NSString stringWithFormat:@"%ld月",model.createtime.day];
    
}
@end
