//
//  OuYuRequest.h
//  NightclubLive
//
//  偶遇请求
//  Created by RDP on 2017/3/7.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GJModelRequest.h"

/**
 *  获取偶遇列表
 */
@interface OuYuListRequet : GJModelRequest
@property (nonatomic, assign) NSInteger pageNow;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *job;
@property (nonatomic, copy) NSString *city;


@end

@interface OuYuLiveRequet : GJModelRequest
/** 喜欢的人的ID */
@property (nonatomic, copy) NSString *toUserID;

@end

@interface OuYuIsLiveRequet : OuYuLiveRequet

@end
