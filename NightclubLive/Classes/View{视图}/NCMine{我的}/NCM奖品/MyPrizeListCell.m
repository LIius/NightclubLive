//
//  MyPrizeListCell.m
//  NightclubLive
//
//  Created by RDP on 2017/4/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MyPrizeListCell.h"
#import "MineModelList.h"

#import "BlocksKit+UIKit.h"
@implementation MyPrizeListCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    @weakify(self);
    self.detailBtn.layer.cornerRadius = 11.5;
    self.detailBtn.layer.borderColor = self.detailBtn.titleLabel.textColor.CGColor;
    self.detailBtn.layer.borderWidth = 1;
    
    [_detailBtn bk_whenTapped:^{
        @strongify(self);
        if (self.seeBlock){
            self.seeBlock(self.indexPath);
        }
    }];
}

- (IBAction)getClick:(id)sender {
    
    _getBlock(self.indexPath);
}


- (void)setModel:(PrizeListModel *)model{
    
    [super setModel:model];
    
    [_logoIV sd_setImageWithURL:[model.prizeImgs firstObject] placeholderImage:[UIImage picturePlaceholder]];
    
    
    _campaignNameLabel.text = [NSString stringWithFormat:@"恭喜您获得%@%@",model.campaign_title,model.ranking];
    _prizeNameLabel.text = model.prize_name;
    
    _stateLabel.text = [NSString stringFromeArray:@[@"未领取",@"已领取",@"已过期"] index:model.status];
    [_getBtn setTitle:[NSString stringFromeArray:@[@"我要领取",@"已领取",@"已过期"] index:model.status] forState:UIControlStateNormal];
    if (model.status > 0){
        _getBtn.backgroundColor = [UIColor whiteColor];
        [_getBtn setBorderColor:RGBCOLOR(168, 168, 168) borderWidth:1];
        [_getBtn setTitleColor:RGBCOLOR(168, 168, 168) forState:UIControlStateNormal];
    }
    else{
        _getBtn.backgroundColor = APPDefaultColor;
        [_getBtn setBorderColor:RGBCOLOR(168, 168, 168) borderWidth:0];
    }

}

@end
