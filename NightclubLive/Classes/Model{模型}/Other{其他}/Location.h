//
//  Location.h
//  NightclubLive
//
//  定位
//  Created by RDP on 2017/3/29.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ModelObject.h"

@interface Location : ModelObject
/** 纬度 */
@property (nonatomic, strong) NSNumber *lclatitude;
/** 经度 */
@property (nonatomic, strong) NSNumber *lclongitude;
/** 省份 */
@property (nonatomic, copy) NSString *lcprovince;
/** 城市 */
@property (nonatomic, copy) NSString *lccity;
/** 县区别 */
@property (nonatomic, copy) NSString *district;
/** 详细地区 */
@property (nonatomic, copy) NSString *lcaddress;
/** 是否保存定位信息 */
@property (nonatomic, assign) BOOL isLocation;

/**
 *  对于定位对象并且获取定位信息
 *
 *  @return 对象
 */
+ (instancetype)location;
/**
 *  定位
 */
- (void)startLocation;
@end
