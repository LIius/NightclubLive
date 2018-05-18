//
//  ClubCircleDynamicDetailVC.h
//  NightclubLive
//
//  Created by WanBo on 16/12/2.
//  Copyright © 2016年 WanBo. All rights reserved.
//  动态详情

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "BaseViewController.h"
#import "ObjectTableViewController.h"
#import "XLPhotoBrowser.h"

@interface ClubCircleDynamicDetailSuperVC :BaseViewController
@property (nonatomic, copy) CalkBackBlock deleteBlock;
@property (nonatomic, weak) NSIndexPath *indexPath;
@end


@interface ClubCircleDynamicDetailVC : ObjectTableViewController <XLPhotoBrowserDelegate, XLPhotoBrowserDatasource>
@property (nonatomic, copy) VoidBlock_id replayCallback;
@property (nonatomic, copy) VoidBlock_id themCommentCallback;

- (void)loadDataFromServer;
- (void)requestDataNotRefresh;
- (void)reloadTopcellData;
@end
