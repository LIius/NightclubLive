//
//  PackageListCell.m
//  NightclubLive
//
//  Created by RDP on 2017/6/29.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "PackageListCell.h"
#import "MineModelList.h"

@implementation PackageListCell

- (IBAction)seeDetailsClick:(id)sender {
    
    if (self.seeDetailsBlock)
        self.seeDetailsBlock(self.indexPath);
}

- (void)setModel:(BarPackageModel *)model{
    
    [super setModel:model];
    
    [_packageIV sd_setImageWithURL:model.imageURL placeholderImage:nil];
    _packageNameLabel.text = model.name;
    _packageContentLabel.text = model.shortIntr;
    _packNowPriceLabel.text = [NSString stringWithFormat:@"¥ %@",model.price];
    NSString *market =  [NSString stringWithFormat:@"原价¥%@",model.originalPrice];

    NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:market];
    [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,market.length)];

//    NSDictionary *styleDic = @{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)};
//    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc] initWithString:olePricesTR attributes:styleDic];

    _oldPriceLabel.attributedText = attributeMarket;
}

@end
