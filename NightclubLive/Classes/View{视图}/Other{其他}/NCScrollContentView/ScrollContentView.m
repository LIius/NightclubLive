//
//  ScrollContentView.m
//  NightclubLive
//
//  Created by RDP on 2017/3/14.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ScrollContentView.h"

@interface ScrollContentView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation ScrollContentView


- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    if (!_collectionView){
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        
        collection.dataSource = self;
        collection.delegate   = self;
        
        collection.backgroundColor = [UIColor whiteColor];
        collection.scrollEnabled = YES;
        collection.scrollsToTop  = NO;
        collection.userInteractionEnabled = YES;
     //   collection.alwaysBounceVertical = YES;
        
        [self addSubview:collection];
        
        _collectionView = collection;
        
      //  _collectionView.backgroundColor = [UIColor blueColor];
        
    }
}

- (void)reloadData{
    
    [self.collectionView reloadDataInMain];
}

#pragma mark - Init

+ (instancetype)initXib{
    
    return (ScrollContentView *)[[[NSBundle mainBundle] loadNibNamed:@"ScrollContentView" owner:nil options:nil] firstObject];
}

- (void)registerCell:(Class)className resuseID:(NSString *)reuseID{
    
    [_collectionView registerClass:className forCellWithReuseIdentifier:reuseID];
}

#pragma mark - UICollection Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _ItemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return _itemBlock(indexPath,collectionView);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return _itemSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (_selectBlock)
        _selectBlock(indexPath);
}

@end
