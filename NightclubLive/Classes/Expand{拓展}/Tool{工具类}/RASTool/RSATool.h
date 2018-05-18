//
//  RSATool.h
//  NightclubLive
//
//  Created by RDP on 2017/4/14.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSATool : NSObject

/**
 *  加密字符串
 *
 *  @param string 被加密的字符串
 *
 *  @return 加密后的字符串
 */
+ (id)rsaEncryptString:(NSString *)string;
/**
 *  解密字符串
 *
 *  @param string 被解密的字符串
 *
 *  @return 解密后的字符串
 */
+ (id)rsaDecryptString:(NSString *)string;
@end
