//
//  ClubCircleRequest.h
//  NightclubLive
//
//  Created by WanBo on 17/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GJModelRequest.h"
#import "CommentRequest.h"
#import "CommentRequest.h"
#import "ObjectRequest.h"

@interface ClubCircleGetListRequest : ObjectRequest

@end

@interface GetQNAuthTokenRequest : GJModelRequest

@end

@interface ReleaseDynamicRequest : ObjectRequest

@end

@interface DeleteDynamicRequest : ObjectRequest

@end

@interface HeartSoundSubjectRequest : GJModelRequest

@end

@interface CommentVoiceListRequest : GJModelRequest

@end

@interface HeartsoundRequest : ObjectRequest
@end

@interface AddHeartSoundRequest : GJModelRequest

@end

@interface PraiseRequest : ObjectRequest

@end

/**
 *  获取酒吧台号  
 */
@interface BarTableNoRequest : ObjectRequest

@end

/**
 *  获取酒吧套餐详情
 */
@interface BarPackageDetailsRequest : ObjectRequest

@end

/**
 *  删除自己心声
 */
@interface DeleteMyHearRequest : ObjectRequest

@end
