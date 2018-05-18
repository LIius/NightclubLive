//
//  MineViewModel.m
//  NightclubLive
//
//  Created by RDP on 2017/2/27.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MineViewModel.h"
#import <CoreLocation/CoreLocation.h>

@interface MineViewModel()<CLLocationManagerDelegate>
/** 定位信息 */
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation MineViewModel


#pragma mark - Getter

- (RACCommand *)locationCommand{
    
    if (!_locationCommand){
        
        _locationCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            CLLocationManager *locatonManger = [[CLLocationManager alloc] init];
            locatonManger.delegate = self;
            
            _locationManager = locatonManger;
            
            return _locationFinishSignal;
        }];
    }
                            
    return  _locationCommand;
}

- (RACSignal *)locationFinishSignal{
    
    if (!_locationFinishSignal){
        
        _locationFinishSignal = [[RACSignal combineLatest:@[RACObserve(self, location)] reduce:^(NSString *location){
            
            if (location.length >= 1)
                return location;
            
            return @"";
            
        }] distinctUntilChanged];
    }
    return _locationFinishSignal;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    //获取最后一个定位信息
    CLLocation *location = locations.lastObject;
    
    _latitude = location.coordinate.latitude;
    _longitude = location.coordinate.longitude;
    
    //反地理编码得出地址
    CLGeocoder *gencode = [[CLGeocoder alloc] init];
    [gencode reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark *currentPlacemarks = placemarks.lastObject;
        
        NSString *city = currentPlacemarks.locality;
        
        _location = city;
    }];

}

#pragma mark - Private Method

- (void)locaotionServerEnable{
    
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        
        
    }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
    }
}
@end
