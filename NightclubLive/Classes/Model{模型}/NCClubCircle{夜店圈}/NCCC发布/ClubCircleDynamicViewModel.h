//
//  ClubCircleDynamicViewModel.h
//  NightclubLive
//
//  Created by WanBo on 17/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MRCTableViewModel.h"

@interface ClubCircleDynamicViewModel : MRCTableViewModel

@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, copy) NSString *typeId;
/**
 *  操作的序号
 */
@property (nonatomic, weak) NSIndexPath *indexPath;
/** 刷新类型 */
@property (nonatomic, assign) RefreshType refreshType;
/** 经度 */
@property (nonatomic, strong) NSNumber *latitude;
/** 维度 */
@property (nonatomic, strong) NSNumber *longitude;
/** 是否提交了定位 */
@property (nonatomic, assign) BOOL onLocation;
@property (nonatomic, copy, readonly) NSArray *datas;
@property (nonatomic, strong, readonly) RACCommand *likeReuqesCommand;
@property (nonatomic, strong, readonly) RACCommand *unlikeReuqesCommand;

@property (nonatomic, strong) RACCommand *getListCommand;
@end
