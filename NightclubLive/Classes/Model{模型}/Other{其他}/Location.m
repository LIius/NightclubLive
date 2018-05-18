//
//  Location.m
//  NightclubLive
//
//  Created by RDP on 2017/3/29.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "Location.h"
#import "LocationTool.h"

@implementation Location

+ (instancetype)location{
    
    Location *l = [Location new];
    
    [l startLocation];
    
    return l;
}

- (void)startLocation{
    
    //获取定位信息(异步)
    [[LocationTool shareTool] startLocationFinish:^(NSDictionary *locations) {
        
        _lclongitude = locations[LocationLongitude];
        _lclatitude = locations[LocationLatitude];
        _lccity    = locations[LocationCity];
        _lcprovince  = locations[LocationProvince];
        _lcaddress   = locations[LocationAddress];
        _isLocation = YES;
    } withErrorBlock:^(NSString *error) {
    }];

}

- (NSNumber *)lclatitude{
    
    if (!_lclatitude)
        _lclatitude = @(0);

    return _lclatitude;
}

- (NSNumber *)lclongitude{
    
    if (!_lclongitude)
        _lclongitude = @(0);
    
    return _lclongitude;
}

- (NSString *)lcprovince{
    
    if (_lcprovince)
        return _lcprovince;
    
    return @"广东";
}

- (NSString *)lccity{
    
    if (_lccity)
        return _lccity;
    
    return @"中山";
}
@end
