//
//  GCStatus.m
//  GJNetWorking
//
//  Created by wangyutao on 15/11/17.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GCStatus.h"

@implementation GCStatus

//mj
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"errorCode":@"errorCode",
             @"message":@"msg",
             @"result":@"result"};
}
@end
