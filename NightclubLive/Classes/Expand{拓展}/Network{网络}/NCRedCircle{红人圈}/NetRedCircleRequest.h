//
//  NetRedCircleRequest.h
//  NightclubLive
//
//  Created by WanBo on 17/1/14.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GJModelRequest.h"
#import "ObjectRequest.h"

@interface NetRedCircleRequest : GJModelRequest

@end

@interface NetRedBannnerCircleRequest : ObjectRequest

@end


@interface GetListRequest : GJModelRequest

@end

@interface ActivityListRequest : GJModelRequest

@end



@interface RankListObjectRequest : ObjectRequest

@end
/**
 *  魅力排行榜
 */
@interface CharmRankListRequest : RankListObjectRequest

@end


/**
 *  富豪榜
 */
@interface TheRichRankListRequest :RankListObjectRequest

@end

/**
 *  获取酒吧列表
 */
@interface BarListRequest :ObjectRequest
/** 页数 */
@property (nonatomic, assign) NSInteger pageNow;
/** 是否为推荐酒吧 */
@property (nonatomic, assign) NSInteger ishot;
/** 模糊查询关键词 */
@property (nonatomic, copy) NSString *searchKey;
/** 酒吧类型 */
@property (nonatomic, copy) NSString *bartype;

@end


/**
 *  获取酒吧详情
 */
@interface BarDetailsRequest : ObjectRequest
@end


@interface BarPersonRankListRequest : ObjectRequest

@end
/**
 *  获取魅力达人
 */
@interface BarCharamRankRequest :BarPersonRankListRequest

@end

/**
 *  获取泡吧达人
 */
@interface BarExpertRankRequest : BarPersonRankListRequest

@end

/**
 *  获取酒吧全部活动
 */
@interface BarActivityRequest : ObjectRequest

@end


/**
 *  活动全面夜店魅力总排名
 */
@interface AcitvityCharamListRequest : ObjectRequest

@end

/**
 *  活动全局土豪值总排名
 */
@interface AcitvityTheRichListRequest : ObjectRequest

@end
