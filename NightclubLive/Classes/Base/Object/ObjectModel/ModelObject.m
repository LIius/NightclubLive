//
//  Object.m
//  YIDAI
//
//  Created by RDP on 2016/12/23.
//  Copyright © 2016年 RDP. All rights reserved.
//

#import "ModelObject.h"
#import <YYModel/YYModel.h>
#import <objc/runtime.h>

@interface ModelObject()<YYModel>

@end

@implementation ModelObject

@dynamic tag;

#pragma mark - Init Method

- (instancetype)initWithDic:(NSDictionary *)dic{
    
    return [[self class] yy_modelWithDictionary:dic];
}

+ (instancetype)objectWithDic:(NSDictionary *)dic{
    
    return [[[self class] alloc] initWithDic:dic];
}

+ (instancetype)object{
    
    return [[[self class] alloc] init];
}

+ (NSArray *)arrayObjectWithDS:(NSArray<NSDictionary *> *)ds
{
    return [[NSArray yy_modelArrayWithClass:[self class] json:ds] copy];
}

#pragma mark - Getter

- (NSString *)jsonString{
    
    return [self toJSONString];
}

- (NSData *)jsonData{
    
    return [self toJSONData];
}

#pragma mark - Convert Method

- (NSString *)toJSONString{
    
    return [self yy_modelToJSONString];
}

- (NSData *)toJSONData{
    
    return [self yy_modelToJSONData];
}

#pragma mark - YYModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return nil;
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    
    return nil;
}

+ (NSArray *)modelPropertyBlacklist{
    
    return nil;
}

+ (NSArray *)modelPropertyWhitelist{
    
    return nil;
}

#pragma mark - Realm

+ (NSString *)primaryKey{
    
    return @"RealmID";
}

+ (NSArray<NSString *> *)ignoredProperties{
    
    return @[@"jsonString",@"jsonData",@"tag"];
}

#pragma mark - Getter

- (NSString *)RealmID{
    
    if (!_RealmID){
        
        NSDateFormatter *dft = [[NSDateFormatter alloc] init];
        [dft setDateFormat:@"yyyyMMddhhmmss"];
        _RealmID = [dft stringFromDate:[NSDate date]];
    }
    return _RealmID;
}

@end
