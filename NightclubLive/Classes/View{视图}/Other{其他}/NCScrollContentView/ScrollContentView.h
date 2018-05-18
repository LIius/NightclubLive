//
//  ScrollContentView.h
//  NightclubLive
//
//  Created by RDP on 2017/3/14.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UICollectionViewCell * (^itemForIndexBlock)(NSIndexPath *indexPath,UICollectionView *collectionView);
typedef void (^SelectItemForIndexBlock)(NSIndexPath *indexPath);
@interface ScrollContentView : UIView
/** 每一个Item大小 */
@property (nonatomic, assign) CGSize itemSize;
/** Item 数量 */
@property (nonatomic, assign) NSInteger ItemCount;
@property (nonatomic, copy) itemForIndexBlock itemBlock;
@property (nonatomic, copy) SelectItemForIndexBlock selectBlock;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;



+ (instancetype)initXib;
- (void)viewinit;
- (void)registerCell:(Class)className resuseID:(NSString *)reuseID;
- (void)reloadData;
@end
