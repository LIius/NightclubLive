//
//  NSArray+NCArray.h
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NCArray)

- (UIImageView *)imageViewAtIndex:(NSUInteger)index;

- (UIImage *)imageAtIndex:(NSUInteger)index;

/**
 从数组中取出一个整数型数字
 
 @param index 序列号
 @return 序列号在数组范围时返回实际的值，不存在时返回0
 */
- (NSInteger)intAtIndex:(NSUInteger)index;

/**
 从数组中取出一个双精度型数字
 
 @param index 序列号
 @return 序列号在数组范围时返回实际的值，不存在时返回0.00
 */
- (double)doubleAtIndex:(NSUInteger)index;

/**
 从数组中取出一个字典
 
 @param index 序列号
 @return 序列号在数组范围时返回实际的值，不存在时返回@{}
 */
- (NSDictionary *)dictionaryAtIndex:(NSUInteger)index;

/**
 从数组中取出一个数组
 
 @param index 序列号
 @return 序列号在数组范围时返回实际的值，不存在时返回@[]
 */
- (NSDictionary *)arrayAtIndex:(NSUInteger)index;

/**
 从数组中取出一个字符串
 
 @param index 序列号
 @return 序列号在数组范围时返回实际的值，不存在时返回@""
 */
- (NSString *)stringAtIndex:(NSUInteger)index;

@end
