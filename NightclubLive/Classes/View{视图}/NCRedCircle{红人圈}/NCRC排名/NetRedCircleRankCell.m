//
//  NetRedCircleRankCell.m
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NetRedCircleRankCell.h"
#import "NetRedCircleListModel.h"


@interface NetRedCircleRankCell()
@end

@implementation NetRedCircleRankCell

- (void)setModel:(RankListModel *)model{
    
    [super setModel:model];
    
    UIImage *typeImge;
    
    if (self.showRankListType == 0){
        _charmLabel.text = model.charm_value;
        typeImge = KGetImage(@"icon_meilizhibig");
    }else{
        _charmLabel.text = model.daifug_value;
        typeImge = KGetImage(@"icon_yiebiterankbig");
    }
    
    [_logoIV sd_setImageWithURL:model.profile_photo placeholderImage:[UIImage userPlaceholder]];
    _typeIV.image = typeImge;
    _nameLabel.text = model.user_name;
    
    NSArray *strArray = @[@"af09d4",@"ffb600"];
    NSString *textStr = [strArray stringAtIndex:_showRankListType];
    _charmLabel.textColor = [UIColor colorWithHexString:textStr];
}

- (void)setShowRankListType:(NSInteger)showRankListType{
    
    _showRankListType = showRankListType;
    
    NSArray *nameArr = @[@"icon_meilizhibig",@"icon_yiebiterankbig"];
    NSString *imagename = [nameArr stringAtIndex:showRankListType];

    _typeIV.image = KGetImage(imagename);
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    
    [super setIndexPath:indexPath];
    _numLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 4];
}

@end
