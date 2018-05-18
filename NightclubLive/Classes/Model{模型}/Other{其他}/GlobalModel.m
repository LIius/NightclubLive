//
//  GlobalModel.m
//  NightclubLive
//
//  Created by RDP on 2017/3/10.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GlobalModel.h"


@implementation JobModel

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"};
}

@end


@implementation CarModel

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"};
}

@end

@implementation AddedValuePackageModel

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id",@"packageName":@"menu_name",@"nightBitValue":@"night_bit_value",@"rmbValue":@"rmb_value"};
}

@end

@implementation GiftModel

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"};
}


@end
