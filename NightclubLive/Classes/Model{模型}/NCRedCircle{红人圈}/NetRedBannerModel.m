//
//  NetRedBannerModel.m
//  NightclubLive
//
//  Created by WanBo on 17/1/14.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NetRedBannerModel.h"

@implementation NetRedBannerModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

@end


@implementation NetRedBannerSuperModel

+ (NSDictionary *)objectClassInArray{
    
    return @{@"result" : [NetRedBannerModel class]};
    
}


@end

@implementation ActivityListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

@end


@implementation ActivityListSuperModel

+ (NSDictionary *)objectClassInArray{
    
    return @{@"result" : [ActivityListModel class]};
    
}
@end


@implementation ListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

@end


@implementation ListSuperModel

+ (NSDictionary *)objectClassInArray{
    
    return @{@"result" : [ListModel class]};
    
}
@end
