//
//  NCPayOpenURL.h
//  NightclubLive
//
//  Created by CodeRiding on 2017/10/9.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>
//微信SDK头文件
#import "WXApi.h"

@interface NCPayOpenURL : NSObject

+ (void)payResult:(BaseResp *)resp;

+ (void)showAlipayWithURL:(NSURL *)url;

@end
