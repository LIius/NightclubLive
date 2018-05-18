//
//  ObjectCollectionViewCell.m
//  NightclubLive
//
//  Created by RDP on 2017/3/1.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectCollectionViewCell.h"

@implementation ObjectCollectionViewCell

+ (instancetype)dequeueReusableCellWithCollection:(UICollectionView *)collection withIndex:(NSIndexPath *)indexPath{
    
    return nil;
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]){
        return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return self;
}
- (void)setModel:(id)model{
    
    if (model == _model)
        return;
}
@end
