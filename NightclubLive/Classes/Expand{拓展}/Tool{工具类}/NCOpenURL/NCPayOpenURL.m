//
//  NCPayOpenURL.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/10/9.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NCPayOpenURL.h"
#import <AlipaySDK/AlipaySDK.h>

@implementation NCPayOpenURL

+ (void)payResult:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp*response=(PayResp*)resp;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WEICHATREBACK object:@(response.errCode)];
    }
}

+ (void)showAlipayWithURL:(NSURL *)url
{
    //支付宝支付
    if ([url.host isEqualToString:@"safepay"])
    {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic)
        {
            NSLog(@"result = %@",resultDic);
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ALIPAYREBACK object:resultDic userInfo:nil];
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic)
        {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0)
            {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr)
                {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="])
                    {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
  
        }];
        
    }
}

@end
