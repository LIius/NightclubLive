//
//  Object.h
//  YIDAI
//
/** 
    Model 父类(基于YYModel + YTKNetwork)
  @Desc 
    全部的Model 类基础于他便会得到相应的功能(见下功能介绍)
  @func 
    1,JSON -> Model。
    2,Model -> JSON。
    3,进行网络请求。
    3,网络解析。
 */
//  Created by RDP on 2016/12/23.
//  Copyright © 2016年 RDP. All rights reserved.
//


@interface ModelObject : NSObject
/** JSON String */
@property (nonatomic, copy,readonly) NSString *jsonString;
/** JSON Data */
@property (nonatomic, strong,readonly) NSData *jsonData;
//标志位
@property (nonatomic, assign) NSInteger tag;
/** 数据库主键 */
@property (nonatomic, copy) NSString *RealmID;

#pragma mark - YYModel;
/**
 *  JSON <-> 映射的字典 {"Modelkey":"JSONKey"}
 *
 *  @return 映射的字典
 */
+ (NSDictionary *)modelCustomPropertyMapper;
/**
 *  Model 中集合保存的是自定义类那么就需要实现这个方法 {"array":"class"}
 *
 *  @return 映射的字典
 */
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass;

/**
 *  黑名单
 *
 *  @return black list
 */
+ (NSArray *)modelPropertyBlacklist;
/**
 *  白名单
 *
 *  @return white list
 */
+ (NSArray *)modelPropertyWhitelist;
#pragma mark - Init Method

/**
 从字典定义对象
 @param dic 字典数据源

 @return 对象
 */
- (instancetype)initWithDic:(NSDictionary *)dic;
/**
 从字典定义对象（类方法,基于initWithDic进行封装）
 @param dic 字典数据源
 
 @return 对象
 */
+ (instancetype)objectWithDic:(NSDictionary *)dic;

/**
 定义对象
 
 @return 对象
 */
+ (instancetype)object;

/**
 批量定义对象

 @param ds dic数据源

 @return 对象
 */
+ (NSArray *)arrayObjectWithDS:(NSArray <NSDictionary *> *)ds;


#pragma mark - Convert Method

/**
 类转JSON String

 @return JSON String
 */
- (NSString *)toJSONString;


/**
 类转JSON Data

 @return JSONData   
 */
- (NSData *)toJSONData;
@end
