//
//  HeartsoundListModel.m
//  NightclubLive
//
//  Created by WanBo on 17/1/9.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "HeartsoundListModel.h"

@implementation HeartsoundVehicle
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"
             };
}
@end

@implementation HeartsoundUser
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",@"typeID":@"typeid"
             };
}
@end

@implementation HeartsoundListModel
//+ (NSDictionary *)mj_replacedKeyFromPropertyName
//{
//    return @{@"ID" : @"id"
//             };
//}

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID" : @"id"};
}


@end


@implementation HeartsoundListSuperModel

+ (NSDictionary *)objectClassInArray{
    return @{@"result" : [HeartsoundListModel class]};
}
@end
