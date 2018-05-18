//
//  UICollectionView+NCCollectionView.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "UICollectionView+NCCollectionView.h"

@implementation UICollectionView (NCCollectionView)

- (void)runEventIntMain:(void (^)())eventBlock{
    
    NSThread *currentThread =  [NSThread currentThread];
    
    if ([currentThread isMainThread]){
        
        eventBlock();
        
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        eventBlock();
        
    });
}

#pragma mark - relodata tableview

- (void)reloadDataInMain{
    
    [self runEventIntMain:^{
        
        [self reloadData];
        [self.mj_footer endRefreshing];
        [self.mj_header endRefreshing];;
        
    }];
    
}

- (void)endRefresh{
    
    [self runEventIntMain:^{
        [self.mj_footer endRefreshing];
        [self.mj_header endRefreshing];;
    }];
}

@end
