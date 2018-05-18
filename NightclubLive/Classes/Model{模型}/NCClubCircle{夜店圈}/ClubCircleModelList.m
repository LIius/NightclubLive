//
//  ClubCircleModelList.m
//  NightclubLive
//
//  Created by RDP on 2017/7/13.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ClubCircleModelList.h"

@implementation BarTableNoModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

- (void)setTableNoEnd:(NSInteger)tableNoEnd{
    
    _tableNoEnd = tableNoEnd;
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = _tableNoStart ; i <= tableNoEnd ; i ++){
        NSString *title = [NSString stringWithFormat:@"%@%ld",_tableType,i];
        [array addObject:title];
    }
    
    _seats = [array copy];
}

@end

@implementation BarTableNoNoCanModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end

@implementation PackageDetailsListModel



@end
