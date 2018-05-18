//
//  NSDictionary+NCDict.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NSDictionary+NCDict.h"

@implementation NSDictionary (NCDict)

@dynamic JSONString;

#pragma mark - Getter

- (NSDictionary *)dictionaryForKey:(NSString *)key {
    if ([self.allKeys containsObject:key]) {
        id value = [self objectForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            return (NSDictionary *)value;
        }
    }
    return @{};
}

- (NSArray *)arrayForKey:(NSString *)key {
    if ([self.allKeys containsObject:key]) {
        id value = [self objectForKey:key];
        if ([value isKindOfClass:[NSArray class]]) {
            return (NSArray *)value;
        }
    }
    return @[];
}

- (NSString *)stringForKey:(NSString *)key {
    if ([self.allKeys containsObject:key]) {
        id value = [self objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            return (NSString *)value;
        }
        if ([value isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)value stringValue];
        }
    }
    return @"";
}

- (BOOL)boolForKey:(NSString *)key {
    if ([self.allKeys containsObject:key]) {
        id value = [self objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            if ([(NSString *)value integerValue] == 0) {
                return NO;
            }
            return YES;
        }
        if ([value isKindOfClass:[NSNumber class]]) {
            if ([(NSNumber *)value integerValue] == 0) {
                return NO;
            }
            return YES;
        }
    }
    return NO;
}

- (NSInteger)intForKey:(NSString *)key {
    if ([self.allKeys containsObject:key]) {
        id value = [self objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            return [(NSString *)value integerValue];
        }
        if ([value isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)value integerValue];
        }
    }
    return 0;
}

- (double)doubleForKey:(NSString *)key {
    if ([self.allKeys containsObject:key]) {
        id value = [self objectForKey:key];
        if ([value isKindOfClass:[NSString class]]) {
            return [(NSString *)value doubleValue];
        }
        if ([value isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)value doubleValue];
        }
    }
    return 0.00;
}


- (NSString *)JSONString{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
    
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
