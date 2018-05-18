

//
//  ObjectCollectionViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/13.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectCollectionViewController.h"
#import <MJRefresh/UIScrollView+MJRefresh.h>


@interface ObjectCollectionViewController ()
/** 老长度 */
@property (nonatomic, assign) NSInteger oldlength;

@end

@implementation ObjectCollectionViewController

+ (instancetype)initSBWithSBName:(NSString *)sbName{

    return [[UIStoryboard storyboardWithName:sbName bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (self.dataSources.count == 0)
        [self requestBegin];
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataToView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    CloseLoading;
}

#pragma mark - Getter

- (NSMutableArray *)dataSources{
    
    if (!_dataSources){
        
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}

#pragma mark - Setter


- (void)setIsHead:(BOOL)isHead{
    
    _isHead = isHead;
    
    if (isHead){
        
        @weakify(self);
        
        //增加下拉刷新
        MJRefreshNormalHeader *head =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.refreshType = RefreshTypeLoad;
            self.pageNow =  1;
            self.oldlength   = self.dataSources.count;
            [self.collectionView.mj_footer resetNoMoreData];
            
            [self refreshMethod];
            
            if (self.refreshBlock)
                self.refreshBlock(self.refreshType,self.pageNow);
        }];
        
        self.collectionView.mj_header = head;
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
            self.oldlength   = self.dataSources.count;
            [self refreshMethod];
            
            if (self.refreshBlock)
                self.refreshBlock(self.refreshType,self.pageNow);
            
        }];
        
        foot.automaticallyHidden = YES;
        
        self.collectionView.mj_footer = foot;
        
        self.collectionView.mj_footer = foot;
    }
    else
        self.collectionView.mj_footer = nil;
    
}

- (void)setParses:(NSArray *)parses{
    
    if (self.refreshType == RefreshTypeLoad){
        
        [self.dataSources removeAllObjects];
    }
    
    
    [self.dataSources addObjectsFromArray:parses];
    
    [self requestEnd];
}

#pragma mark - Public 

- (void)refreshMethod{
}

- (void)requestBegin{
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)requestEnd{
    
    //结束刷新
    
    [self.collectionView endRefresh];
    [self.collectionView reloadDataInMain];
    
    //判断数据集合是否增长
    if (self.dataSources.count == self.oldlength){
        
        if (self.refreshType == RefreshTypeLoad){//数据为空
        }
        else{//提示没有更多数据
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
}

- (void)loadDataToView{
    
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}



@end
