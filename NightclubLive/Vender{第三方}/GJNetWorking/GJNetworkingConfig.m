//
//  GJNetworkingConfig.m
//  GJNetWorking
//
//  Created by wangyutao on 15/11/13.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GJNetworkingConfig.h"

static NSString *baseUrl;
static NSSet *acceptableContentTypes;
static BOOL allowInvalidCertificates = NO;
static BOOL validatesDomainName = NO;
static int maxConcurrentOperationCount = 4;
static Class<GJModelMakerDelegate> modelMaker;
static NSTimeInterval timeOutInterval = 60;

static _removesKeysWithNullValues = NO;

@implementation GJNetworkingConfig

- (void)abc {
    
}

+ (void)setDefaultBaseUrl:(NSString *)base
   acceptableContentTypes:(NSSet *)contentTypes
 allowInvalidCertificates:(BOOL)allowInvalidCer
      validatesDomainName:(BOOL)validDomain
        maxOperationCount:(int)operationCount
          timeOutInterval:(NSTimeInterval)timeOut
               modelMaker:(Class<GJModelMakerDelegate>)maker{
    
    baseUrl = base ? [base copy] : nil;
    acceptableContentTypes = contentTypes ? contentTypes : nil;
    allowInvalidCertificates = allowInvalidCer;
    validatesDomainName = validDomain;
    maxConcurrentOperationCount = operationCount ? operationCount : 4;
    if (maker) {
        modelMaker = maker;
    }
    timeOutInterval = timeOut ? timeOut : 60;
}

+ (NSString *)defaultBaseUrl{
    return baseUrl;
}

+ (NSSet *)acceptableContentTypes{
    return acceptableContentTypes;
}

+ (BOOL)allowInvalidCertificates{
    return allowInvalidCertificates;
}

+ (BOOL)validatesDomainName{
    return validatesDomainName;
}

+ (int)maxConcurrentOperationCount{
    return maxConcurrentOperationCount;
}

+ (Class<GJModelMakerDelegate>)modelMaker{
    return modelMaker;
}

+ (NSTimeInterval)timeOutInterval{
    return timeOutInterval;
}

+ (void)setRemovesKeysWithNullValues:(BOOL)remove {
    _removesKeysWithNullValues = remove;
}

+ (BOOL)removesKeysWithNullValues {
    return _removesKeysWithNullValues;
}

@end


static NSString *gj_cacheDirectory = @"GJAPICacheDirectory";

@implementation GJNetworkingConfig (GJAPICache)

+ (void)setCacheDirectory:(NSString *)dir {
    gj_cacheDirectory = dir;
}

+ (NSString *)getCacheDirectory {
    return gj_cacheDirectory;
}

@end
