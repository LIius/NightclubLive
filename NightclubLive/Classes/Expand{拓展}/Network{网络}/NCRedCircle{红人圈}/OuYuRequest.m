//
//  OuYuRequest.m
//  NightclubLive
//
//  Created by RDP on 2017/3/7.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "OuYuRequest.h"

@implementation OuYuListRequet

-  (NSString *)path{
    
    return @"encounter/getRequireEncounterList.do";
}

- (NSDictionary *)parameters{

    UserInfo *user = [UserInfo shareUser];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.pageNow) {
        [params setValue:@(self.pageNow) forKey:@"pageNow"];
    }
    if (user.location.lclatitude) {
        [params setValue:user.location.lclatitude forKey:@"latitude"];
    }
    if (user.location.lclongitude) {
        [params setValue:user.location.lclongitude forKey:@"longitude"];
    }
    
    //NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"pageNow":@(self.pageNow),@"latitude":user.location.lclatitude,@"longitude":user.location.lclongitude}];
    
    if (self.sex)
        [params setObject:[self.sex isEqualToString:@"男"] ? @(1) : @(0) forKey:@"sex"];
    
    if (self.job)
        [params setObject:self.job forKey:@"occupation"];
    
    if (self.city)
        [params setObject:self.city forKey:@"city"];
    
    return params.mutableCopy;
}

@end

@implementation OuYuLiveRequet

- (NSString *)path{
    
    return @"encounter/addEncounter.do";
}

- (NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([UserInfo shareUser].userID.length >0) {
        [params setValue:[UserInfo shareUser].userID forKey:@"fromUserId"];
    }
    if (self.toUserID.length > 0) {
        [params setValue:self.toUserID forKey:@"toUserId"];
    }
    
    return params.mutableCopy;
    //return @{@"fromUserId":[UserInfo shareUser].userID,@"toUserId":self.toUserID};
}

@end

@implementation OuYuIsLiveRequet : OuYuLiveRequet


- (NSString *)path{
    
    return @"encounter/checkIfLikeEach.do";
}

@end
