//
//  ContributionCell.m
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ContributionCell.h"
#import "NetRedCircleListModel.h"

@implementation ContributionCell

- (void)setModel:(RankListModel *)model{
    
    [super setModel:model];
    
    _nameLabel.text = model.user_name;
    _ybtLabel.text = model.contribution_value;
    [_logoIV sd_setImageWithURL:model.profile_photo placeholderImage:[UIImage userPlaceholder]];
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    
    [super setIndexPath:indexPath];
    
    _numIV.hidden = indexPath.row >= 3;
    
    if (indexPath.row < 3){
        NSString *imageName = [NSString stringFromeArray:@[@"icon_numberonerank",@"icon_numbertworank",@"icon_numberthreerank"] index:indexPath.row];
        _numIV.image = KGetImage(imageName);
        _numIV.hidden = NO;
    }
    else{
        _numIV.hidden = YES;

    }
    
    _numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
}
@end
