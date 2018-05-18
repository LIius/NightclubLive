//
//  ObjectRequest.h
//  NightclubLive
//
//  网络请求基本类
//  Created by RDP on 2017/3/8.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GJAPICacheRequest.h"
#import "ResponseState.h"

@class ModelObject;


typedef void (^CompletedBlock)(ResponseState *state);

@interface ObjectRequest : GJAPICacheRequest
/** 参数 */
@property (nonatomic, strong) NSDictionary *param;
/** 标志符号 */
@property (nonatomic, assign) NSInteger tag;
/** 回到的信息 */
@property (nonatomic, strong) ResponseState *responseState;
/** 传输model */
@property (nonatomic, weak) id model;
/** responseData */
@property (nonatomic, strong)  id responseData;

/**
 *  类方法进行网络请求
 *
 *  @param completeBlock 回调
 */
+ (void)startRequestWithCompleted:(CompletedBlock)completeBlock;
/**
 *  进行网络请求
 *
 *  @param completeBlock 回调
 */
- (void)startRequestWithCompleted:(CompletedBlock)completeBlock;


@end
