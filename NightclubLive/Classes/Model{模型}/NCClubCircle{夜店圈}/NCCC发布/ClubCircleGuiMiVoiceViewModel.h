//
//  ClubCircleGuiMiVoiceViewModel.h
//  NightclubLive
//
//  Created by WanBo on 17/1/5.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MRCTableViewModel.h"
#import "VoiceListModel.h"
#import "HeartsoundListModel.h"

@interface ClubCircleGuiMiVoiceViewModel : MRCTableViewModel

@property (nonatomic, strong) VoiceListModel *model;
@property (nonatomic, readonly) NSArray *datas;
@property (nonatomic, copy) NSString *file;
/** 当前页数 */
@property (nonatomic, assign) NSInteger pageNow;
/** 刷新类型 */
@property (nonatomic, assign) RefreshType refreshType;

//回复内容
/** 是否匿名 */
@property (nonatomic, assign) NSInteger isAnonymous;
/** 回复内容 */
@property (nonatomic, copy) NSString *content;
/** 回复语音长度 */
@property (nonatomic, assign) NSTimeInterval duration;
/** 语音文件路径 */
@property (nonatomic, copy) NSString *voicelen;
/** 回复内容(1-文字 2-语音) */
@property (nonatomic, assign) NSInteger messageType;
@property (nonatomic, strong) NSNumber *isNiming;
/** 回复类型 */
@property (nonatomic, assign) NSInteger replayType;
/** 主题的ID */
@property (nonatomic, copy) NSString *subjectSendID;


/** 操作的序号 */
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong, readonly) RACCommand *voiceCommintCommand;
@property (nonatomic, strong, readonly) RACCommand *likeReuqesCommand;
@property (nonatomic, strong) RACCommand *unlikeRequestCommand;
/** 获取主题 */
@property (nonatomic, strong) RACCommand *getListCommand;
/** 点赞command */
@property (nonatomic, strong) RACCommand *praiseCommand;

@property (nonatomic,copy)NSString *comsubjectID;
@property (nonatomic,copy)NSString *comtypeID;

@end
