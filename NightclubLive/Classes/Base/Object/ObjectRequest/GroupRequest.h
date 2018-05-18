//
//  GroupRequest.h
//  NightclubLive
//
// 请求组
//  Created by RDP on 2017/3/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GJBaseRequest.h"

@class ObjectRequest;

typedef void (^GroupReuqestFinishBloclk)(NSArray *reuests);
@interface GroupRequest : GJBaseRequest
/** 请求队列 */
@property (nonatomic, strong,readonly) NSArray *requests;
/**
 *  增加请求
 *
 *  @param request 请求
 */
- (void)addRequests:(ObjectRequest *)request;
- (void)startRequestWithFinishBlock:(GroupReuqestFinishBloclk)finishBlock;
@end
