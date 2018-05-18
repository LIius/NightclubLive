//
//  UITableView+NCTableView.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "UITableView+NCTableView.h"
#import <MJRefresh/MJRefresh.h>

@implementation UITableView (NCTableView)

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

- (void)reloadInMain
{
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
- (void)insertRowsInMainAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    
    [self runEventIntMain:^{

        [self insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
    }];
}

- (void)deleteRowsInMainAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation{
    
    [self runEventIntMain:^{

        [self beginUpdates];
        [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
        [self endUpdates];
    }];
    
}

- (void)setBackgroundImage:(UIImage *)backImage{
    
    UIImageView *loginBackImageView = [[UIImageView alloc] initWithImage:KGetImage(@"background")];
    loginBackImageView.frame = self.bounds;
    self.backgroundView = loginBackImageView;
}

@end
