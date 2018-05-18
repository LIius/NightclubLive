//
//  PaiPaiDetailsViewModel.h
//  NightclubLive
//
//  Created by RDP on 2017/3/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MRCTableViewModel.h"
#import "UIViewController+Category.h"
@class PaiPaiModel;

@interface PaiPaiDetailsViewModel : MRCTableViewModel
/** 数据集合 */
@property (nonatomic, copy) NSArray *datas;
/** 当前页数 */
@property (nonatomic, assign) NSInteger pageNow;
@property (nonatomic, weak) PaiPaiModel *model;
@property (nonatomic, assign) RefreshType refreshType;
/** 回复的内容 */
@property (nonatomic, copy) NSString *message;
/** 回复类型 */
@property (nonatomic, assign) NSInteger replayType;

/** 赞类型 */
@property (nonatomic, assign) NSInteger praiseType;
/** 分类类型 1-动态 2-心声 3-活动 4-拍拍 */
@property (nonatomic, assign) NSInteger subjectTypeId;
/** 点赞类型 1-主题 2-评论*/
@property (nonatomic, assign) NSInteger type;
/** 点赞主题ID */
@property (nonatomic, assign) NSString *subjectId;
/** 回复对象 */
@property (nonatomic, copy) NSString *toUser;

/** 评论 */
@property (nonatomic, strong) RACCommand *commentCommand;
/** 分享 */
@property (nonatomic, strong) RACCommand *shareCommand;
/** 获取回复列表 */
@property (nonatomic, strong) RACCommand *getCommentListCommand;
/** 点赞 */
@property (nonatomic, strong) RACCommand *praiseCommand;
/** 回复点赞 */
@property (nonatomic, strong) RACCommand *cpCommand;
/** cell 高度 */
@property (nonatomic, strong) NSMutableArray *cellHeights;

- (void)removeObjectAtIndex:(NSInteger)index;
@end
