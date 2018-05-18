//
//  ObjectViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/2/27.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectViewController.h"
#import <MJRefresh/MJRefreshNormalHeader.h>
#import <MJRefresh/MJRefreshAutoNormalFooter.h>


@interface ObjectViewController ()
@property (nonatomic, assign) NSInteger oldlength;
@end

@implementation ObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadDataToView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
  
    if (_dataSource.count == 0)
        [self requestBegin];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    CloseLoading;
    
}


#pragma mark - Setter

- (NSMutableArray *)dataSource{
    
    if (!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setIsHead:(BOOL)isHead{
    
    _isHead = isHead;
    
    if (isHead){
        
        @weakify(self);
        
        //增加下拉刷新
        MJRefreshNormalHeader *head =  [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            @strongify(self);
            self.refreshType = RefreshTypeLoad;
            self.pageNow =  1;
            self.oldlength   = self.dataSource.count;
            [self.refreshView.mj_footer resetNoMoreData];
            
            [self refreshMethod];
            
            if (self.refreshBlock)
                self.refreshBlock(self.refreshType,self.pageNow);
        }];
        
        self.refreshView.mj_header = head;
        
        if (self.refreshView)
            self.refreshView.mj_header = head;
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
        
        self.refreshView.mj_footer = foot;
        
        if (self.refreshView)
            self.refreshView.mj_footer = foot;
    }
    else
        self.refreshView.mj_footer = nil;
    
}

- (void)setRefreshView:(UITableView *)refreshView{
    
    _refreshView  = refreshView;
    
}


- (void)setParses:(NSArray *)parses{
    
    if (self.refreshType == RefreshTypeLoad){
        
        [self.dataSource removeAllObjects];
    }
    
    [self.dataSource addObjectsFromArray:parses];
    
    [self requestEnd];
}


#pragma mark - Public Method

- (void)refreshMethod{
}

- (void)requestBegin{
    
    [self.refreshView.mj_header beginRefreshing];
}

- (void)requestEnd{
    
    //结束刷新
    
    [self.refreshView.mj_header endRefreshing];
    [self.refreshView.mj_footer endRefreshing];
    
    if ([self.refreshView isKindOfClass:[UITableView class]]){
        UITableView *tableView = (UITableView *)self.refreshView;
        [tableView reloadInMain];
    }
    else{
        UICollectionView *collectionView = (UICollectionView *)self.refreshView;
        [collectionView reloadDataInMain];
    }
    

    
    // 判断数据集合是否增长
    if (self.dataSource.count == self.oldlength)
    {
        if (self.refreshType == RefreshTypeLoad){
            //数据为空
            
        }
        else{//提示没有更多数据
            [self.refreshView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    
}


- (void)loadDataToView{
    
}

@end
