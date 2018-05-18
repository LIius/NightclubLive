//
//  LocationMange.m
//  NightclubLive
//
//  Created by RDP on 2017/2/28.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "LocationTool.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationTool()<CLLocationManagerDelegate>{
    
    CLLocationManager *_manager;
    NSMutableDictionary *_locatons;
}

@end

@implementation LocationTool

#pragma mark - Init

+ (instancetype)shareTool{
    
    static LocationTool *shareTool;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        shareTool = [[LocationTool alloc] init];
    });
    
    return shareTool;
}

- (instancetype)init{
    
    if (self = [super init]){
        
        _locatons = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (instancetype)location{
    
    return [[[self class] alloc] init];
}

#pragma mark - Private Method

- (void)locatonServerEnable{
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        
        
        //定位信息可用init定位类
        CLLocationManager *manager = [[CLLocationManager alloc] init];
        manager.delegate = self;
        _manager = manager;

        
        if (IOS8) {
            //使用应用程序期间允许访问位置数据
            [_manager requestWhenInUseAuthorization];
        }
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        NSString *error = @"app没有获得定位权限，请在设置-隐私中开启";
        
        if (_errorBlock){
            
            _errorBlock(error);
        }
        
    }

}

#pragma mark - Public Method

- (void)startLocation{
    
    //获取权限
    [self locatonServerEnable];
    
    //开始定位
    if (_manager)
        [_manager startUpdatingLocation];
}

- (void)startLocationFinish:(LocationFinishBlock)finishBlock withErrorBlock:(LocationErrorBlock)errorBlock{
    
    _finishBlock = finishBlock;
    _errorBlock  = errorBlock;
    
    [self startLocation];
}

#pragma mark - Getter

- (NSDictionary *)locationDatas{
    
    return [_locatons copy];
}

#pragma mark - LocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    CLLocation *location = locations.firstObject;
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *placemark = placemarks.lastObject;
        
        NSString *city = placemark.locality;
        NSString *province = placemark.administrativeArea;
        NSString *district = @"";
        NSString *address  = placemark.name;
        CGFloat longitude = location.coordinate.longitude;
        CGFloat latitude  =  location.coordinate.latitude;
        
        
        [_locatons setValue:city forKey:LocationCity];
        [_locatons setValue:@(longitude) forKey:LocationLongitude];
        [_locatons setValue:@(latitude) forKey:LocationLatitude];
        [_locatons setValue:province forKey:LocationProvince];
        [_locatons setValue:district forKey:LocationDistrict];
        [_locatons setValue:address forKey:LocationAddress];
        
        
        if (_finishBlock)
            _finishBlock([_locatons copy]);
    }];
    
    //停止定位
    [manager stopUpdatingLocation];
    
}



@end
