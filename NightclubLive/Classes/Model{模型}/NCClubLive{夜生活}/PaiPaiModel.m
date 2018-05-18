//
//  PaiPaiModel.m
//  NightclubLive
//
//  Created by WanBo on 17/2/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "PaiPaiModel.h"


@implementation PaiPaiModel
+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID" : @"id"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    
    return @{@"user": [User class]};
}

- (void)setCreateTime:(NSDate *)createTime{
    
    _createTime = createTime;
    
    _timeGap = createTime.difftime;
}

@end

@implementation PaiPaiSuperModel
+ (NSDictionary *)objectClassInArray{
    return @{@"result" : [PaiPaiModel class]};
}

@end
