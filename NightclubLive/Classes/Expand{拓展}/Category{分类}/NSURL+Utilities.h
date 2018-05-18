//
//  NSURL+Utilities.h
//  NightclubLive
//
//  Created by RDP on 2017/5/3.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Utilities)
/**
 *  string 批量 转换成url
 *
 *  @param urlStrings stirng
 *
 *  @return 结果
 */
+ (NSArray *)urlStringsToURLS:(NSArray *)urlStrings;
@end
