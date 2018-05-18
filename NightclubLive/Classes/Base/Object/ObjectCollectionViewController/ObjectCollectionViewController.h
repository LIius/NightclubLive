//
//  ObjectCollectionViewController.h
//  NightclubLive
//
//  Created by RDP on 2017/4/13.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObjectCollectionViewController : UICollectionViewController
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, assign) BOOL isHead;
@property (nonatomic, assign) BOOL isFoot;
/** 解析的数据 网络请求完毕赋值给这个参数会自动进行处理 */
@property (nonatomic, strong) NSArray *parses;
/** 当前页数 */
@property (nonatomic, assign) NSInteger pageNow;
/** 刷新类型 */
@property (nonatomic, assign) RefreshType refreshType;
@property (nonatomic, strong) id model;
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

//-----------------
/**
 *  记载数据到界面viewload时候会调用
 */
- (void)loadDataToView;


@end
