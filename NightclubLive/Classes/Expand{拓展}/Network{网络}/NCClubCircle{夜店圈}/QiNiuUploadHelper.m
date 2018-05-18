//
//  QiNiuUploadHelper.m
//  NightclubLive
//
//  Created by WanBo on 17/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//
#import "QiNiuUploadHelper.h"
static QiNiuUploadHelper *_sharedInstance ;

@implementation QiNiuUploadHelper

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[QiNiuUploadHelper alloc] init];
    });
    return _sharedInstance;
}

-(id)copyWithZone:(NSZone *)zone{
    return _sharedInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}
@end
