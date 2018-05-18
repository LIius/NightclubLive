//
//  ObjectViewController.h
//  NightclubLive
//
//  Created by RDP on 2017/2/27.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Category.h"


@interface ObjectViewController : UIViewController
/** 控制模型 */
@property (nonatomic, strong) id model;
/** 回调 */
@property (nonatomic, copy) CalkBackBlock calkBlock;
/** 数据集合 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 解析的数据 网络请求完毕赋值给这个参数会自动进行处理 */
@property (nonatomic, strong) NSArray *parses;
/** 头部 */
@property (nonatomic, assign) BOOL isHead;
/** 是否存在尾部 */
@property (nonatomic, assign) BOOL isFoot;
/** 刷新视图 */
@property (nonatomic, weak) UIScrollView *refreshView;
/** 刷新collect */
//@property (nonatomic, weak) UICollectionView *refreshCollectionView;

/** 当前页数 */
@property (nonatomic, assign) NSInteger pageNow;
/** 刷新类型 */
@property (nonatomic, assign) RefreshType refreshType;
@property (nonatomic, assign) BOOL isShowEmpty;

- (void)refreshMethod;
- (void)requestBegin;
- (void)requestEnd;

- (void)loadDataToView;

@end
