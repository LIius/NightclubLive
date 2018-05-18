//
//  LocationMange.h
//  NightclubLive
//
//  定位信息管理类
//  1,定位权限。
//  2,获取当前定位信息
//  3,获取错误提示文本
//  Created by RDPCode on 2017/2/28.
//  Copyright © 2017年 RDPCode. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  定位完成调用的block
 *
 *  @param locations 参数集合
 */
typedef void (^LocationFinishBlock)(NSDictionary *locations);
/**
 *  定位错误提示的block
 *
 *  @param error 错误信息
 */
typedef void (^LocationErrorBlock)(NSString *error);
//定位信息Key

/** 定位经度 */
static NSString  *LocationLongitude = @"longitude";
/** 定位纬度 */
static NSString  *LocationLatitude  = @"latitude";
/** 定位城市 */
static NSString  *LocationCity      = @"city";
/** 定位的省份 */
static NSString  *LocationProvince  = @"province";
/** 定位的区县 */
static NSString  *LocationDistrict  = @"district";
/** 具体地址 */
static NSString  *LocationAddress   = @"address";
@interface LocationTool : NSObject
/**
 *  定位信息集合
 */
@property (nonatomic, strong) NSDictionary *locationDatas;
/**
 *  完成调用的block
 */
@property (nonatomic, copy) LocationFinishBlock finishBlock;
/**
 *  错误调用的block
 */
@property (nonatomic, copy) LocationErrorBlock errorBlock;
/**
 *  定义locaotionmanage对象
 *
 *  @return 对象
 */
+ (instancetype)location;
/** 单例子 */
+ (instancetype)shareTool;

/**
 *  开始定位
 */
- (void)startLocation;

/**
 *  开始定位
 *
 *  @param finishBlock 完成调用的block
 *  @param errorBlock  错误调用的block
 */
- (void)startLocationFinish:(LocationFinishBlock)finishBlock withErrorBlock:(LocationErrorBlock)errorBlock;
@end
