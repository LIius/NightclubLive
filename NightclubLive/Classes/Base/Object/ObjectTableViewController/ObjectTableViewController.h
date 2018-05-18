//
//  ObjectTableViewController.h
//  NightclubLive
//
//  Created by RDP on 2017/3/8.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+Category.h"
/** 刷新调用的block */
typedef void (^RefreshBlock)(RefreshType type,NSInteger pageNow);

@interface ObjectTableViewController : UITableViewController
/** 数据集合 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 解析的数据 网络请求完毕赋值给这个参数会自动进行处理 */
@property (nonatomic, strong) NSArray *parses;
/** 头部 */
@property (nonatomic, assign) BOOL isHead;
/** 是否存在尾部 */
@property (nonatomic, assign) BOOL isFoot;
/** 是否显示空 */
@property (nonatomic, assign) BOOL isShowEmpty;
/** 是否自动获取数据(用户viewwill) */
@property (nonatomic, assign) BOOL isAutoGetData;
/** 刷新视图 */
@property (nonatomic, weak) UIScrollView *refreshView;
/** 当前页数 */
@property (nonatomic, assign) NSInteger pageNow;
/** 刷新类型 */
@property (nonatomic, assign) RefreshType refreshType;
@property (nonatomic, strong) id model;
@property (nonatomic, copy) CalkBackBlock calkBlock;
@property(nonatomic,assign)BOOL disableViewRefresh;

/**
 *  从storyboard 记载视图
 *
 *  @param sbName storyboard名字
 *
 *  @return 对象
 */
+ (instancetype)initSBWithSBName:(NSString *)sbName;

/** 刷新调用的函数 */
- (void)refreshMethod;

/** 开始进行网络请求 */
- (void)requestBegin;
/** 网络请求完毕(调用该函数会根据情况进行对于的设置) */
- (void)requestEnd;

@end
