//
//  ObjectCollectionViewCell.h
//  NightclubLive
//
//  Created by RDP on 2017/3/1.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObjectCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) id model;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) CalkBackBlock calkBlock;

+ (instancetype)dequeueReusableCellWithCollection:(UICollectionView *)collection withIndex:(NSIndexPath*)indexPath;
@end
