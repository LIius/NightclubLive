//
//  NCEmpty.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NCEmpty.h"

@implementation NCEmpty

+ (void)showOrHideOn:(UIScrollView *)scrollView  customeView:(UIView *)customeView
{
    NSInteger count = [self getViewItemCount:scrollView];
    
    if (count > 0 )
    {
        [self hideEmptyView:customeView];
    }
    else{
        [self showEmptyViewOnView:scrollView customeView:customeView];
    }
}

+ (void)showEmptyViewOnView:(UIScrollView *)scrollView customeView:(UIView *)customeView
{
    customeView.frame = [self getEmtpyViewRectWithScrollView:scrollView];
    [scrollView addSubview:customeView];
    [scrollView bringSubviewToFront:customeView];
}

+ (void)hideEmptyView:(UIView *)customeView
{
    [customeView removeFromSuperview];
}

+ (NSInteger)getViewItemCount:(UIScrollView *)scrollView
{
    Class class = [scrollView class];
    
    NSInteger itemCount = 0;
    
    if ([class isSubclassOfClass:[UITableView class]]){
        
        UITableView *tableView = (UITableView *)scrollView;
        
        for (NSInteger section = 0 ; section < tableView.numberOfSections ; section ++ ){
            
            itemCount += [tableView numberOfRowsInSection:section];
        }
    }
    
    if ([class isSubclassOfClass:[UICollectionView class]]){
        
        UICollectionView *collection = (UICollectionView *)scrollView;
        for (NSInteger section = 0 ; section < collection.numberOfSections ; section ++){
            itemCount += [collection numberOfItemsInSection:section];
        }
    }
    
    return itemCount;
}

+ (CGRect)getEmtpyViewRectWithScrollView:(UIScrollView *)scrollView
{
    CGFloat x = 0.0,y = 0.0,width = 0.0,height = 0.0;
    
    width = scrollView.width;
    height = scrollView.height;
    
    // 如果是tableview,需要计算头部高度
    if ([scrollView isKindOfClass:[UITableView class]])
    {
        UITableView *tableView = (UITableView *)scrollView;
        UIView *headView = tableView.tableHeaderView;
        
        x = tableView.x + x;
        y = headView.height + y;
        height = height - headView.height;
    }
    
    return CGRectMake(x, y, width, height);
}

@end
