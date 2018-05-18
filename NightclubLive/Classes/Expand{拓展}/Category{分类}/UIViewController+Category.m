//
//  UIViewController+Category.m
//  YIDAI
//
//  Created by RDP on 2017/1/4.
//  Copyright © 2017年 RDP. All rights reserved.
//

#import "UIViewController+Category.h"

@implementation UIViewController (Category)
@dynamic haveRefreshFoot;
@dynamic haveRefreshHead;
@dynamic refresh_tableView;
@dynamic pageCount;

#pragma mark - Init Method

+ (instancetype)initFromSB{
    
//    NSString *sbName = NSStringFromClass([self class]);
//
//    if([[self class] isSubclassOfClass:[UITableViewController class]]){
//
//        sbName = [sbName stringByReplacingOccurrencesOfString:@"TableViewController" withString:@""];
//    }
//    else if([[self class] isSubclassOfClass:[UIViewController class]]){
//
//        sbName = [sbName stringByReplacingOccurrencesOfString:@"ViewController" withString:@""];
//    }
//
//    sbName = [sbName stringByAppendingString:@"Storyboard"];
//
//    return LOAD_VIEW_INIT(sbName);
    return nil;
}

+ (instancetype)initSBWithSBName:(NSString *)sbName{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbName bundle:nil];
    
    NSString *vcName = NSStringFromClass([self class]);
    
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:vcName];
    
    
    return vc;
    
}

#pragma mark - Refresh Method

- (void)loadData{
    
    NSLog(@"load");
}

- (void)loadMoreData{
    
    NSLog(@"loadMore");
}

- (void)requestDataFromServer{
    
    NSLog(@"request data");
}

- (void)loadDataFromServer{
    
    NSLog(@"request data");
}

- (void)autoFinishSuccessWithResponseData:(id)responseData parseDic:(NSDictionary *)parseDic result:(NSInteger)result message:(NSString *)message{
    
    NSLog(@"success request");
}
#pragma mark - Setter

- (void)setHaveRefreshFoot:(BOOL)haveRefreshFoot{
    
    kWeakSelf(self);
    
    if (haveRefreshFoot){
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            weakself.currentPage += 1;
            weakself.refreshType = RefreshTypeLoadMore; // 可以影响默认值codering
            [weakself loadMoreData];
            [weakself requestDataFromServer];
            
            if (weakself.refreshBlock)
                weakself.refreshBlock(RefreshTypeLoadMore,weakself.currentPage);
        }];
        
        footer.automaticallyHidden = YES;
        
        weakself.refresh_tableView.mj_footer = footer;
        
        if (weakself.refresh_view)
            weakself.refresh_view.mj_footer = footer;
    }
    else{
        
        weakself.refresh_tableView.mj_footer = nil;
        
        if (weakself.refresh_view)
            weakself.refresh_view.mj_footer = nil;
        
    }
}

- (void)setHaveRefreshHead:(BOOL)haveRefreshHead{
    
    kWeakSelf(self);
    
    if (haveRefreshHead){
        
        MJRefreshNormalHeader *head = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            weakself.currentPage = 1;
            weakself.refreshType = RefreshTypeLoad;
            [weakself loadData];
            [weakself.refresh_tableView.mj_footer resetNoMoreData];
            [weakself requestDataFromServer];
            
            if (weakself.refreshBlock)
                weakself.refreshBlock(RefreshTypeLoad,weakself.currentPage);
        }];
        
        self.refresh_tableView.mj_header  = head;
        
        if (weakself.refresh_view)
            weakself.refresh_view.mj_header = head;
    }
    else{
            weakself.refresh_tableView.mj_header = nil;
    }
    
}

static const char RefreshTableViewKey = '\0';
- (void)setRefresh_tableView:(UITableView *)refresh_tableView{
    
    objc_setAssociatedObject(self, &RefreshTableViewKey , refresh_tableView, OBJC_ASSOCIATION_ASSIGN);
}

static const char RefreshViewKey = '\0';
- (void)setRefresh_view:(UIView *)refresh_view{
    
    objc_setAssociatedObject(self, &RefreshViewKey, refresh_view, OBJC_ASSOCIATION_ASSIGN);
}

static const int CurrentPageKey = 1;
- (void)setCurrentPage:(NSInteger)currentPage{
    
    objc_setAssociatedObject(self, &CurrentPageKey, @(currentPage), OBJC_ASSOCIATION_ASSIGN);
}

//static const char DataSourcesKey = '\0';
//- (void)setDataSources:(NSMutableArray *)dataSources{
//
//    objc_setAssociatedObject(self, &dataSources, @(DataSourcesKey), OBJC_ASSOCIATION_ASSIGN);
//}

static const int TagKey = 0;
- (void)setTag:(NSInteger)tag{
    
    objc_setAssociatedObject(self, &TagKey, @(tag), OBJC_ASSOCIATION_ASSIGN);
}

static const int RefreshTypeKey = 1;
- (void)setRefreshType:(RefreshType)refreshType{
    
    objc_setAssociatedObject(self, &RefreshTypeKey, @(refreshType), OBJC_ASSOCIATION_ASSIGN);
}

static const char ModelKey = '\0';
- (void)setModel:(id)model{
    
    objc_setAssociatedObject(self, &ModelKey, model, OBJC_ASSOCIATION_ASSIGN);
    
}

static const char RefreshBlockKey = '\0';
- (void)setRefreshBlock:(refreshDataBlock)refreshBlock{
    
    objc_setAssociatedObject(self, &RefreshBlockKey, refreshBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Getter

- (UITableView *)refresh_tableView{
    
    return objc_getAssociatedObject(self, &RefreshTableViewKey);
}

- (UIScrollView *)refresh_view{
    
    return objc_getAssociatedObject(self, &RefreshViewKey);
}

- (NSInteger)currentPage{
    
    return [objc_getAssociatedObject(self, &CurrentPageKey) integerValue];
}

//- (NSMutableArray *)dataSources{
//
//    return objc_getAssociatedObject(self, &DataSourcesKey);
//}

- (NSInteger)tag{

    return [objc_getAssociatedObject(self, &TagKey) integerValue];
}

- (RefreshType)refreshType{
    
    return (RefreshType)[objc_getAssociatedObject(self, &RefreshTypeKey) integerValue];
}

- (id)model{
    
    return objc_getAssociatedObject(self, &ModelKey);
}

- (refreshDataBlock)refreshBlock{
    return objc_getAssociatedObject(self, &RefreshBlockKey);
}
@end

