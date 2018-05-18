//
//  MineRequest.h
//  NightclubLive
//
//  Created by RDP on 2017/4/18.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectRequest.h"

@interface UpdateUserInfoRequest : ObjectRequest
/** 头像 */
@property (nonatomic, copy) NSString *headURL;
/** 用户姓名 */
@property (nonatomic, copy) NSString *name;
/** 用户所在地 */
@property (nonatomic, copy) NSString *city;
/** 出生日期 */
@property (nonatomic, strong) NSDate *birthday;
/** 职业 */
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *constellation;
@property (nonatomic, assign) NSInteger emotion;
/** 收入 */
@property (nonatomic, copy) NSString *income;
/** 个性签名 */
@property (nonatomic, copy) NSString *sign;
/** 性别 */
@property (nonatomic, assign) NSInteger sex;
@end

/**
 *  获取我的动态
 */
@interface MyDynamicListRequest : ObjectRequest

@end

@interface PhotoAlbumListRequest : ObjectRequest

@end


/**
 *  获取我的账号信息
 */
@interface MyAccountRequest : ObjectRequest

@end


/**
 *  删除相册
 */
@interface DeletePhotoRequest : ObjectRequest
/** 相册ID */
@property (nonatomic, copy) NSString *photoID;
/** 相片集合 */
@property (nonatomic, strong) NSArray *imgs;
@end


/**
 *  获取粉丝关注列表
 */
@interface FenGZRequest : ObjectRequest
@property (nonatomic, assign) NSInteger pageNow;
@end

/**
 *  添加关注
 */
@interface AddGZRequest : ObjectRequest
@end


/**
 *  我的奖品列表
 */
@interface MyPrizeListRequest : ObjectRequest

@end

/**
 *  获取我的下线列表
 */
@interface MyNextListRequest : ObjectRequest

@end

/**
 *  领取奖品接口
 */
@interface GetPrizeReqeust : ObjectRequest

@end

/**
 *  获取我的礼物列表
 */
@interface GetMyGiftListRequest : ObjectRequest
/** 当前页数 */
@property (nonatomic, strong) NSNumber *pageNow;
@end

/**
 *  提现接口
 */
@interface WithdrawRequest : ObjectRequest
/** 提现账号 */
@property (nonatomic, copy) NSString *account;
/** 提现名字 */
@property (nonatomic, copy) NSString *name;
/** 提现金额 */
@property (nonatomic, copy) NSString *money;
/** 提现类型 */
@property (nonatomic, assign) NSInteger type;
@end


@interface GetBarListRequest : ObjectRequest
/** 分页 */
@property (nonatomic, assign) NSInteger pageNow;
/** 搜索词 */
@property (nonatomic, copy) NSString *searchValue;
@end

/**
 *  绑定酒吧
 */
@interface BindBarRequest : ObjectRequest

@end


/**
 *  获取绑定的酒吧列表 可以获取别人的也可以获取自己的
 */
@interface GetMyBarListRequest : ObjectRequest

@end

/**
 *  提示商家通过绑定
 */
@interface AlertBindRequest : ObjectRequest

@end

/**
 *  获取订单列表
 */
@interface OrderListRequest : ObjectRequest

@end

/**
 *  解绑酒吧
 */
@interface UnBindBarRequest : ObjectRequest

@end

/**
 * 兑换夜比特
 */
@interface ConvertNVRequest : ObjectRequest
/** 兑换的量 */
@property (nonatomic, assign) double nc;

@end


/**
 *  获取酒吧套餐
 */
@interface BarPackageRequest : ObjectRequest
/** 页数 */
@property (nonatomic, assign) NSInteger page;
/** 酒吧ID */
@property (nonatomic, copy) NSString *barID;

@end

/**
 *  约台下单
 */
@interface DownOrderRequest : ObjectRequest

@end

/**
 *  订单详情
 */
@interface OrderDetailsRequest : ObjectRequest

@end

/**
 *  收入列表
 */
@interface IncomeListRequest : ObjectRequest

@end

/**
 *  我的支出
 */
@interface ExpenditureListRequest : ObjectRequest

@end

/**
 *  充值记录
 */
@interface RechargeLogListRequest : ObjectRequest

@end

/**
 *  个人贡献榜
 */
@interface ContributionListRequest : ObjectRequest

@end


/**
 *  个人排行榜
 */
@interface PersonRankListRequest : ObjectRequest

@end

@interface MyVoiceListRequest : ObjectRequest
@property (nonatomic, assign) NSInteger  pageNow;
@end
