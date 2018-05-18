//
//  PayListRequest.m
//  NightclubLive
//
//  Created by RDP on 2017/6/1.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "PayListRequest.h"
#import "MineModelList.h"


@implementation PayBaseRequest

- (NSDictionary *)parameters{
    
    // paramDic
    NSMutableDictionary *paramDic = [NSMutableDictionary new];
    NSString *strUserID = RSAEncryptString(CurrentUser.userID);
    if (strUserID) {
        [paramDic setValue:strUserID forKey:@"userId"];
    }
    
    NSString *strPhone = RSAEncryptString(CurrentUser.lgPhone);
    if (strPhone) {
        [paramDic setValue:strPhone forKey:@"phoneNum"];
    }
    
    
    // paramDic2
    NSMutableDictionary *paramDic2 = [NSMutableDictionary new];
    if (_package) {
        [paramDic2 setValue:_package forKey:@"name"];
    }
    if (_orderNO) {
        [paramDic2 setValue:_orderNO forKey:@"orderNo"];
    }
    if (_paid) {
        [paramDic2 setValue:_paid forKey:@"paid"];
    }
    if (paramDic2) {
        [paramDic setValue:paramDic2 forKey:@"orderInfo"];
        //[paramDic setValue:@{@"name":_package,@"orderNo":_orderNO,@"paid":_paid} forKey:@"orderInfo"];
    }
    
    
    // paramDic3
    NSString *jsonStr = RSAEncryptString(paramDic.JSONString);
    NSMutableDictionary *paramDic3 = [NSMutableDictionary new];
    if (jsonStr) {
        [paramDic3 setValue:jsonStr forKey:@"jsonStr"];
    }
    
    return paramDic3.mutableCopy;
}

@end


@implementation AliPayRequest

- (NSString *)path{
    
    return @"ad_pay/xiao_place_order.do";
}

@end


@implementation WeiChatRequest

- (NSString *)path{
    
    return @"weixin/xiao_place_order_w.do";
}

@end

@implementation LCPayRequest

- (NSString *)path{
    
    return @"pin/pay_order.do";
}

@end

@implementation PayFactory

+ (PayBaseRequest *)createPayRequestWithType:(NSInteger)type{
    
    if (type == 0)
        return [LCPayRequest new];
    else if (type == 1)
        return [WeiChatRequest new];
    else
        return [AliPayRequest new];
}

@end
