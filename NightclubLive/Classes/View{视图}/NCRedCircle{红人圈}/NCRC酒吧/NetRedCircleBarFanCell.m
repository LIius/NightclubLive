//
//  NetRedCircleBarFanCell.m
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NetRedCircleBarFanCell.h"
#import "NetRedCircleListModel.h"


#import "BlocksKit+UIKit.h"
@implementation NetRedCircleBarFanCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _logoIV.layer.cornerRadius = 18.5;
    _logoIV.layer.masksToBounds = YES;
    
    [_invitionBtn bk_whenTapped:^
    {
        if (self.appointmentBlock)
        {
            self.appointmentBlock(self.indexPath);
        }
    }];
}

- (void)setModel:(BarPersonRankModel *)model
{
    [super setModel:model];
    
    _nameLabel.text = model.user_name;
    _designLabel.text = model.autograph;

    _inviteLabel.text = [NSString stringWithFormat:@"被约次数：%ld",(long)model.order_count];
    
    [_logoIV sd_setImageWithURL:model.profile_photo placeholderImage:[UIImage userPlaceholder] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [_logoIV autoAdjustWidth];
    }];
    
    _ybtLabel.text = model.contribute_value;
    
    if (_showType == 0){
        _ybtIV.hidden = YES;
        _invitionBtn.hidden = NO;
        _inviteLabel.hidden = NO;
    }else{
        _ybtIV.hidden = NO;
        _invitionBtn.hidden = YES;
        _inviteLabel.hidden = YES;
    }
    
    NSString *imagename  = model.sex == 1 ? @"icon_male-1" : @"icon_female-1";
    _sexIV.image = KGetImage(imagename);
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    [super setIndexPath:indexPath];
    
    if (indexPath.row < 3)
    {
        NSArray *nameArr = @[@"icon_NOONE",@"icon_NOTWO",@"icon_NOTHREE"];
        NSString *imagename = [nameArr stringAtIndex:indexPath.row];
        _rankIV.image = KGetImage(imagename);
        _rankIV.hidden = NO;
        
        NSArray *nameArr2 = @[@"ffb401",@"c3c3c3",@"c69205"];
        NSString *imagename2 = [nameArr2 stringAtIndex:indexPath.row];
        _logoBackV.backgroundColor = [UIColor colorWithHexString:imagename2];
    }
    else{
        _rankIV.hidden = YES;
        _logoBackV.backgroundColor = UIColorHex(#9c88b9);
    }
}

@end
