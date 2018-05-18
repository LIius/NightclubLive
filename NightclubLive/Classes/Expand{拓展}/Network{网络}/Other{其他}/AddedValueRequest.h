//
//  AddedValueRequest.h
//  NightclubLive
//
//  Created by RDP on 2017/4/13.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectRequest.h"


/**
 *  获取购买套餐
 */
@interface GetPackageListRequest : ObjectRequest

@end


/**
 *  验证支付凭证
 */
@interface VerifyReceiptRequest : ObjectRequest
/** 是否是沙盒模式 */
@property (nonatomic, assign) NSInteger isSandBox;
/** 凭证 */
@property (nonatomic, strong) NSData   *receiptData;
/** 产品ID */
@property (nonatomic, strong) NSString *productID;
@end
