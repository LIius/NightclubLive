//
//  GlobalRequest.h
//  NightclubLive
//
//  全局网络请求
//  Created by RDP on 2017/3/10.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectRequest.h"

/**
 *  获取职业列表
 */
@interface JobRequest : ObjectRequest

@end

/**
 *  获取职业认证信息
 */
@interface GetJobRequest : ObjectRequest

@end

/**
 *  提交车辆认证
 */
@interface AuthPushCarRequest : ObjectRequest

@end

/**
 *  提交车辆认证
 */
@interface CarRequest : ObjectRequest

@end

/**
 *  获取车辆认证
 */
@interface GetCarRequest : ObjectRequest

@end


/**
 *  提交视频认证
 */
@interface VideoReuqest : ObjectRequest

@end

/**
 *  获取视频认证
 */
@interface GetVideoRequest : ObjectRequest

@end

/**
 *  获取礼物列表
 */
@interface GiftListRequest : ObjectRequest

@end


/**
 *  获取其他人资料的接口
 */
@interface GetOtherPersonRequest : ObjectRequest

/** 获取比人的ID */
@property (nonatomic, copy) NSString *otherUserID;
/** 获取别人的手机号码 */
@property (nonatomic, copy) NSString *otherPhoneNum;

@end


/**
 *  绑定微信小程序
 */
@interface BindMiniProgramRequest : ObjectRequest

@end

/**
 *  获取业务邦token
 */
@interface GetYWBTokenReqeuest : ObjectRequest

@end

/**
 *  意见反馈
 */
@interface SuggestRequest : ObjectRequest
@end


/**
 *  校验码校验   
 */
@interface CheckCodeRequest : ObjectRequest

@end

/**
 *  删除评论
 */
@interface DeleteCommentRequest : ObjectRequest
/** subejct */
@property (nonatomic, copy) NSString *subectId;
/** type */
@property (nonatomic, assign) NSInteger type;


@end

