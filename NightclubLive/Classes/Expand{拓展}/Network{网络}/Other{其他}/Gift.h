//
//  Gift.h
//  NightclubLive
//
//  礼物部分
//  Created by RDP on 2017/3/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectRequest.h"


/**
 *  获取转盘地址
 */
@interface GetWheelLeafRequest : ObjectRequest

@end


/**
 *  获取奖品列表
 */
@interface GetWheelListRequest : ObjectRequest

@end

/**
 *  获取抽奖结果
 */
@interface GetResultRequest : ObjectRequest

@end


/**
 *  送出礼物
 */
@interface SendGiftRequest : ObjectRequest
/** 接受者ID */
@property (nonatomic, copy) NSString *receiverID;
/** 送礼物者ID */
@property (nonatomic, copy) NSString *giftID;
/** 送礼类型 送礼的1动态，2心声，3活动，4拍拍     5.大转盘抽奖,6聊天送礼  */
@property (nonatomic, assign) NSInteger giftType;
/** 项目ID 聊天送礼这个ID为0 */
@property (nonatomic, copy) NSString *projectID;
/** 接受者手机号码（等gifttype == 6 时候填） */
@property (nonatomic, copy) NSString *receiverPhone;
/** 手机号码 */
@property (nonatomic, copy) NSString *phoneNum;
/** 礼物数量 */
@property (nonatomic, strong) NSNumber *giftCount;
@end
