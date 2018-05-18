//
//  LiveRequest.m
//  NightclubLive
//
//  Created by WanBo on 17/2/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "LiveRequest.h"
#import "PaiPaiModel.h"

@implementation PaiPaiGetListRequest

- (NSString *)path{
    return @"paipai/getPaipaiList.do";
}

- (NSDictionary *)parameters{
    return self.param;
}

- (GJRequestMethod)method{
    return GJRequestPOST;
}

- (Class)modelClass{
    return [PaiPaiSuperModel class];
}

- (GJAPICachePolicy)cachePolicy {
    return GJNotAPICachePolicy;
}

- (NSTimeInterval)cacheValidTime {
    return 10 * 60;
}

@end

@implementation PaiPaiUserListRequest

- (NSString *)path{
    return @"paipai/getPersonalPaipai.do";
}

- (NSDictionary *)parameters{
    return self.param;
}

@end
@implementation PaiPaiPostVideoRequest

- (NSString *)path{
    return @"paipai/addPaipai.do";
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
