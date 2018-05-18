//
//  VoiceCommentDetailVC.h
//  NightclubLive
//
//  Created by WanBo on 16/12/30.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewController.h"
#import "ObjectViewController.h"

@interface VoiceCommentDetailSuperVC : BaseViewController

@end


@interface VoiceCommentDetailVC : BaseTableViewController

@property (nonatomic, copy) VoidBlock_id replayCallback;
@property (nonatomic, copy) VoidBlock_id themCommentCallback;

/** 重新从服务器加载数据 */
- (void)reloadDataFromServer;
/**
 *  重新加载数据到界面
 */
- (void)reloadDataToView;

@end
