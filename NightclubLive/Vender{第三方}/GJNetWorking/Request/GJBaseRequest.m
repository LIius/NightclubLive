//
//  GJBaseRequest.m
//  GJNetWorking
//
//  Created by wangyutao on 15/11/13.
//  Copyright © 2015年 wangyutao. All rights reserved.
//

#import "GJBaseRequest.h"
#import "GJHTTPManager.h"

@interface GJBaseRequest ()

@property (nonatomic, readwrite, assign) GJRequestState state;
@property (nonatomic, copy, readwrite) GJCompletedBlock completedBlock;
@property (nonatomic, copy, readwrite) GJRequestFinishedBlock successBlock;
@property (nonatomic, copy, readwrite) GJRequestFinishedBlock failedBlock;
@property (nonatomic, readwrite, strong) id status;
@property (nonatomic, readwrite, strong) NSError *error;
@property (nonatomic, readwrite, strong) id responseObject;
@property (nonatomic, readwrite, strong) id responseJson;

@end

@implementation GJBaseRequest

- (void)start {
    self.state = GJRequestStateExcuting;
    [[GJHTTPManager sharedManager] startRequest:self];
}

- (void)startWithSuccessBlock:(GJRequestFinishedBlock)success
                  failedBlock:(GJRequestFinishedBlock)failed {
    self.successBlock = success;
    self.failedBlock = failed;
    [self start];
}

- (void)startWithCompletedBlock:(GJCompletedBlock)completedBlock {
    self.completedBlock = completedBlock;
    [self start];
}

- (void)cancel {
    if ([[GJHTTPManager sharedManager] cancelRequest:self]) {
        self.state = GJRequestStateCanceled;
    }
}

- (void)retry {
    _currentRetryTimes ++;
    [self start];
}

- (NSUInteger)retryTimes {
    return 0;
}

#pragma mark- public response method
- (BOOL)isRequestSuccessed {
    return !self.error;
}

- (BOOL)isCanceled {
    if (self.task.state == NSURLSessionTaskStateCanceling || self.error.code == -999) return YES;
    return NO;
}

- (BOOL)isNetworking{
    return self.state == GJRequestStateExcuting;
}

- (void)requestTerminate {
    
    if (!self.isCanceled) {
        self.state = GJRequestStateFinished;
    }
    
    [self requestCompleted];
    
    BOOL success = !self.error;
    
    id responseObject = self.responseObject;

    //call back
    if (success && self.successBlock) {
        self.successBlock(responseObject, self.status, nil);
    }
    
    if (!success && self.failedBlock) {
        self.failedBlock(responseObject, nil, self.error);
    }
    
    !self.completedBlock ? : self.completedBlock(self);
    
    self.successBlock = nil;
    self.failedBlock = nil;
    self.completedBlock = nil;
}

- (void)requestCompleted {}

#pragma mark- request config
//default method is 'GET'
- (GJRequestMethod)method {
    return GJRequestGET;
}

- (NSString *)baseUrl {
    return @"";
}

- (NSString *)path {
    return @"";
}

// 在GJHTTPManager里面使用这个header
- (NSDictionary *)httpHeader{
    return nil;
}

- (NSDictionary *)parameters {
    return nil;
}

- (NSTimeInterval)timeOutInterval {
    return 30;
}

- (GJResponseType)responseType {
    return GJResponseTypeDefault;
}

@end
