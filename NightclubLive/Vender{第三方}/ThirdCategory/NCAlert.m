//
//  NCAlert.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/1.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NCAlert.h"
#import <MMPopupView/MMSheetView.h>
#import "NCSheetView.h"

@implementation NCAlert

+ (void)showActionSheetWithDataSource:(NSArray *)dataSource  title:(NSString *)title blockHandel:(NCAlertHandler)blockhandel hideBlock:(NCAlertHideBlock)hideBlock
{
    
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
    MMPopupItemHandler block = ^(NSInteger index){
        if (blockhandel) {
            blockhandel(index);
        }
        
        NSLog(@"clickd %@ button",@(index));
        
    };
    
    MMPopupCompletionBlock completeBlock = ^(MMPopupView *popupView, BOOL finished){
        NSLog(@"show animation complete");
    };
    
    MMPopupCompletionBlock hidecompleteBlock = ^(MMPopupView *popupView, BOOL finished){
        NSLog(@"hide animation complete");
        if (hideBlock) {
             hideBlock();
        }
       
    };
    
    NSMutableArray *items = @[].mutableCopy;
    
    for (int i = 0; i <dataSource.count; i ++)
    {
        NSString *str = [NSString stringWithFormat:@"%@",dataSource[i]] ;
        MMPopupItem *item = MMItemMake(str, MMItemTypeNormal, block);
        [items addObject:item];
    }
    
    NCSheetView *sheetView = [[NCSheetView alloc] initWithTitle:title
                                                          items:items];
    
    sheetView.attachedView.mm_dimBackgroundBlurEnabled = NO;
    
    sheetView.hideCompletionBlock = hidecompleteBlock;
    
    [sheetView showWithBlock:completeBlock];
}

+ (void)showActionSheetWithDataSource:(NSArray *)dataSource blockHandel:(NCAlertHandler)blockhandel hideBlock:(NCAlertHideBlock)hideBlock
{
    [self showActionSheetWithDataSource:dataSource title:nil blockHandel:blockhandel hideBlock:hideBlock];
    
}

+ (void)showActionSheetWithDataSource:(NSArray *)dataSource  title:(NSString *)title blockHandel:(NCAlertHandler)blockhandel
{
    [self showActionSheetWithDataSource:dataSource title:title blockHandel:blockhandel hideBlock:nil];
}

+ (void)showActionSheetWithDataSource:(NSArray *)dataSource blockHandel:(NCAlertHandler)blockhandel
{
    [self showActionSheetWithDataSource:dataSource title:nil blockHandel:blockhandel];
}

@end
