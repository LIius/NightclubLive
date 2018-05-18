//
//  ObjectTableViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/3/8.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface ObjectTableViewController ()
/** 老长度 */
@property (nonatomic, assign) NSInteger oldlength;
@end

@implementation ObjectTableViewController

#pragma mark - 生命周期

+ (instancetype)initSBWithSBName:(NSString *)sbName{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbName bundle:nil];
    
    NSString *vcName = NSStringFromClass([self class]);
    
    return [storyboard instantiateViewControllerWithIdentifier:vcName];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource =  [NSMutableArray array];
    
    _isShowEmpty = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    if (_dataSource.count == 0){
        if (self.disableViewRefresh) {
            return;
        }
        
        [self requestBegin];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    CloseLoading;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Source

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return TABLE_HEAD_FOOT_SPACE;
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Setter

- (void)setIsHead:(BOOL)isHead{
    
    _isHead = isHead;
    
    if (isHead){
        
        @weakify(self);
        
        // 增加下拉刷新
        MJRefreshNormalHeader *head =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.refreshType = RefreshTypeLoad;
            self.pageNow =  1;
            self.oldlength   = self.dataSource.count;
            [self.tableView.mj_footer resetNoMoreData];
            
            [self refreshMethod];
            
            if (self.refreshBlock)
                self.refreshBlock(self.refreshType,self.pageNow);
        }];
    
        self.tableView.mj_header = head;
        
        if (self.refreshView){
            self.refreshView.mj_header = head;
        }
        
    }
    
}

- (void)setIsFoot:(BOOL)isFoot{
    
    _isFoot = isFoot;
    
    if (isFoot){
        
        @weakify(self);
        
        MJRefreshAutoNormalFooter *foot = [MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
            @strongify(self);
            self.refreshType = RefreshTypeLoadMore;
            self.pageNow    += 1;
            self.oldlength   = self.dataSource.count;
            [self refreshMethod];
            
            if (self.refreshBlock)
                self.refreshBlock(self.refreshType,self.pageNow);
            
        }];
        
        foot.automaticallyHidden = YES;
    
        self.tableView.mj_footer = foot;
        
        if (self.refreshView)
            self.refreshView.mj_footer = foot;
    }
    else
        self.tableView.mj_footer = nil;
    
}

- (void)setParses:(NSArray *)parses
{
    if (self.refreshType == RefreshTypeLoad)
    {
        [self.dataSource removeAllObjects];
    }
    
    [self.dataSource addObjectsFromArray:parses];

    [self requestEnd];
}

#pragma mark - Public Method

- (void)refreshMethod
{
    
}

- (void)requestBegin
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestEnd
{
    // 结束刷新
    [self.tableView endRefresh];
    [self.tableView reloadInMain];
    
    // 判断数据集合是否增长
    if (self.dataSource.count == self.oldlength)
    {
        if (self.refreshType == RefreshTypeLoad){// 数据为空
            
        }
        else{// 提示没有更多数据
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }

    _isShowEmpty = YES;
}

@end
