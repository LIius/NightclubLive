//
//  VoiceCommentDetailViewModel.h
//  NightclubLive
//
//  Created by WanBo on 17/1/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MRCTableViewModel.h"
#import "HeartsoundListModel.h"
#import "VoiceCommentModel.h"

@interface VoiceCommentDetailViewModel : MRCTableViewModel

@property (nonatomic, strong) HeartsoundListModel *model;
@property (nonatomic, readonly) NSArray *datas;
@property (nonatomic, copy) NSString *file;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *themID;
@property (nonatomic,copy)NSString *touserID;
/** 回复类型 */
@property (nonatomic, assign) NSInteger replyType;



/** 当前页数 */
@property (nonatomic, assign) NSInteger pageNow;
/** 刷新类型 */
@property (nonatomic, assign) RefreshType refreshType;
@property (nonatomic, strong,readonly) RACCommand *voiceCommintCommand;
@property (nonatomic, strong, readonly) RACCommand *likeReuqesCommand;

/** 获取评论列表 */
@property (nonatomic, strong) RACCommand *getCommentListCommand;

@property (nonatomic,copy)NSString *comsubjectID;
@property (nonatomic,copy)NSString *comtypeID;

- (void)removeAtIndex:(NSInteger)index;

@end
