//
//  PayListRequest.h
//  NightclubLive
//
/*   支付Request
 *   零钱支付,支付宝支付,微信支付
 */
//  Created by RDP on 2017/6/1.
//  Copyright © 2017年 WanBo. All rights reserved.
//


#import "ObjectRequest.h"


/**
 *  支付基本接口
 */
@interface PayBaseRequest : ObjectRequest
/** 套餐名称 */
@property (nonatomic, copy) NSString *package;
/** 订单ID */
@property (nonatomic, copy) NSString *orderNO;
/** 支付金额 */
@property (nonatomic, copy) NSString *paid;
@end

/**
 *  支付宝下单接口
 */
@interface AliPayRequest : PayBaseRequest

@end

/**
 *  微信支付
 */
@interface WeiChatRequest : PayBaseRequest
@end

/**
 *  零钱支付
 */
@interface LCPayRequest : PayBaseRequest
@end


/**
 *  支付接口创建工厂
 */
@interface PayFactory : NSObject
/**
 *  创建支付接口
 *
 *     0 - 零钱
 *     1 - 微信
 *     2 - 支付宝
 *
 *  @param type 创建类型
 *
 *  @return 返回对于的接口类
 */
+ (PayBaseRequest *)createPayRequestWithType:(NSInteger)type;
@end
