//
//  PaiPaiHomeCell.h
//  NightclubLive
//
//  Created by WanBo on 16/12/4.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PaiPaiModel;

@interface PaiPaiHomeLayout : UICollectionViewFlowLayout

@end

@interface PaiPaiHomeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLable;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

- (void)bindModel:(PaiPaiModel *)model;

@end




