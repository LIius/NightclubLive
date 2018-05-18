//
//  NSArray+NCArray.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NSArray+NCArray.h"

@implementation NSArray (NCArray)

- (NSInteger)intAtIndex:(NSUInteger)index {
    if ([self count] > index) {
        id value = [self objectAtIndex:index];
        if ([value isKindOfClass:[NSString class]]) {
            return [(NSString *)value integerValue];
        }
        if ([value isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)value integerValue];
        }
    }
    return 0;
}

- (double)doubleAtIndex:(NSUInteger)index {
    if ([self count] > index) {
        id value = [self objectAtIndex:index];
        if ([value isKindOfClass:[NSString class]]) {
            return [(NSString *)value doubleValue];
        }
        if ([value isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)value doubleValue];
        }
    }
    return 0.00;
}

- (NSDictionary *)dictionaryAtIndex:(NSUInteger)index {
    if ([self count] > index) {
        id value = [self objectAtIndex:index];
        if ([value isKindOfClass:[NSDictionary class]]) {
            return (NSDictionary *)value;
        }
    }
    return @{};
}

- (NSArray *)arrayAtIndex:(NSUInteger)index {
    if ([self count] > index) {
        id value = [self objectAtIndex:index];
        if ([value isKindOfClass:[NSArray class]]) {
            return (NSArray *)value;
        }
    }
    return @[];
}

- (NSString *)stringAtIndex:(NSUInteger)index {
    if ([self count] > index) {
        id value = [self objectAtIndex:index];
        if ([value isKindOfClass:[NSString class]]) {
            return (NSString *)value;
        }
        if ([value isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)value stringValue];
        }
    }
    return @"";
}

- (UIImage *)imageAtIndex:(NSUInteger)index
{
    if ([self count] > index)
    {
        id value = [self objectAtIndex:index];
        
        if ([value isKindOfClass:[UIImage class]])
        {
            return (UIImage *)value;
        }
        
    }
    return nil;
}

- (UIImageView *)imageViewAtIndex:(NSUInteger)index
{
    if ([self count] > index)
    {
        id value = [self objectAtIndex:index];
        
        if ([value isKindOfClass:[UIImageView class]])
        {
            return (UIImageView *)value;
        }
        
    }
    
    return [UIImageView new];
}

@end
