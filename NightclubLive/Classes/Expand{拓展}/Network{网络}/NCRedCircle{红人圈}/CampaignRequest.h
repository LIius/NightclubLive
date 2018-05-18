//
//  Campaign.h
//  NightclubLive
//
//  竞选部分网络请求
//  Created by RDP on 2017/3/8.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectRequest.h"

//获取全部竞选列表
@interface CampaignListRequest : ObjectRequest

@end

/**
 *  发布竞选活动作品
 */
@interface CampaignJoinRequest: ObjectRequest
@end

/**
 *  获取活动参数作品
 */
@interface CampaignJoinaListRequest : ObjectRequest

@end

/**
 *  获取我的竞选列表
 */
@interface MyCampaignListRequest : ObjectRequest

@end


/**
 *  获取参赛礼物贡献榜
 */
@interface CampaignJoinGiftListRequest : ObjectRequest

@end
