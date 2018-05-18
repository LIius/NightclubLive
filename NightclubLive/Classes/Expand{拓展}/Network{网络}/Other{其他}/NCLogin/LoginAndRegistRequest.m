//
//  LoginAndRegistRequest.m
//  NightclubLive
//
//  Created by WanBo on 16/12/26.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "LoginAndRegistRequest.h"

@implementation GetCodeRequest

- (NSString *)path{
    return @"user/verifyCode.do";
}

- (NSDictionary *)parameters{
    return self.param;
}

- (GJRequestMethod)method{
    return GJRequestPOST;
}

- (Class)modelClass{
    return nil;
}

- (GJAPICachePolicy)cachePolicy {
    return GJNotAPICachePolicy;
}

- (NSTimeInterval)cacheValidTime {
    return 10 * 60;
}

@end

@implementation RegisterRequest

- (NSString *)path{
    return @"user/userRegister.do";
}

- (NSDictionary *)parameters{
    return self.param;
}

- (GJRequestMethod)method{
    return GJRequestPOST;
}

- (Class)modelClass{
    return nil;
}

- (GJAPICachePolicy)cachePolicy {
    return GJNotAPICachePolicy;
}

- (NSTimeInterval)cacheValidTime {
    return 10 * 60;
}

@end

@implementation LoginRequest

- (NSString *)path{
    return @"user/userLogin.do";
}

- (NSDictionary *)parameters{
    return self.param;
}

- (GJRequestMethod)method{
    return GJRequestPOST;
}

- (Class)modelClass{
    return nil;
}

- (GJAPICachePolicy)cachePolicy {
    return GJNotAPICachePolicy;
}

- (NSTimeInterval)cacheValidTime {
    return 10 * 60;
}

@end
@implementation UserResetRequest

- (NSString *)path{
    return @"user/userReset.do";
}

- (NSDictionary *)parameters{
    return self.param;
}

- (GJRequestMethod)method{
    return GJRequestPOST;
}

- (Class)modelClass{
    return nil;
}

- (GJAPICachePolicy)cachePolicy {
    return GJNotAPICachePolicy;
}

- (NSTimeInterval)cacheValidTime {
    return 10 * 60;
}

@end

@implementation FolkLoginRequest

- (NSString *)path{
    
    return @"party_login/add_third_user.do";
}

- (NSDictionary *)parameters{
    return self.param;
}

- (Class)modelClass{
    return nil;
}

- (GJAPICachePolicy)cachePolicy {
    return GJNotAPICachePolicy;
}

- (NSTimeInterval)cacheValidTime {
    return 10 * 60;
}

- (GJRequestMethod)method{
    
    return GJRequestPOST;
}


@end

