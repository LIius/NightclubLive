//
//  UIViewController+Category.h
//  YIDAI
//
//  Created by RDP on 2017/1/4.
//  Copyright © 2017年 RDP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefreshNormalHeader.h>
#import <MJRefresh/MJRefreshAutoNormalFooter.h>
#import "MJRefresh.h"


typedef enum{
    RefreshTypeLoad = 0,
    RefreshTypeLoadMore = 1,
}RefreshType;

typedef void (^refreshDataBlock)(RefreshType refreshType,NSInteger currentPage);

@interface UIViewController (Category)

//当前页数
@property (nonatomic, assign) NSInteger currentPage;
//页数
@property (nonatomic, assign) NSInteger pageCount;
//分类tableView（刷新控件添加到这个）
@property (nonatomic, weak) UITableView *refresh_tableView;
//刷新基本类
@property (nonatomic, weak) UIScrollView *refresh_view;
//标志位
@property (nonatomic, assign) NSInteger tag;
//刷新类型
@property (nonatomic, assign) RefreshType refreshType;
//传递的参数
@property (nonatomic, weak) id model;
//保存数据的数组
//@property (nonatomic, strong) NSMutableArray *dataSources;
//有下拉刷新
@property (nonatomic, assign) BOOL haveRefreshHead;
//有上加载更多
@property (nonatomic, assign) BOOL haveRefreshFoot;
/** 刷新调用的block */
@property (nonatomic, copy) refreshDataBlock refreshBlock;
//从SB加载view (默认加载 控制器名字(去掉view or table controller) + storyboard)
+ (instancetype)initFromSB;
/** 从SB记载controller  */
+ (instancetype)initSBWithSBName:(NSString *)sbName;
//加载数据
- (void)loadData;
//记载更多数据
- (void)loadMoreData;
//从服务器获取数据
- (void)requestDataFromServer;
//自动请求调用的完成函数
- (void)autoFinishSuccessWithResponseData:(id)responseData parseDic:(NSDictionary *)parseDic result:(NSInteger)result message:(NSString *)message;
@end
