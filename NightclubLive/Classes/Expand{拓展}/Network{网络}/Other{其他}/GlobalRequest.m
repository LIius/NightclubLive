//
//  GlobalRequest.m
//  NightclubLive
//
//  Created by RDP on 2017/3/10.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GlobalRequest.h"

@implementation JobRequest


- (NSString *)path{
    
    return @"professionName/getList.do";
}

- (GJRequestMethod)method{
    
    return GJRequestGET;
}

- (GJAPICachePolicy)cachePolicy{
    
    return GJUseAPICacheWhenFailedPolicy;
}

@end

@implementation GetJobRequest

- (NSString *)path{
    
    return @"profession/getList.do";
}

@end

@implementation CarRequest

- (NSString *)path{
    
    return @"car_brand/getList.do";
}

- (GJAPICachePolicy)cachePolicy{
    
    return GJUseAPICacheWhenFailedPolicy;
}

- (GJRequestMethod)method{
    
    return GJRequestPOST;
}

@end

@implementation GetCarRequest

- (NSString *)path{
    
    return @"vehicleAuth/getVehicleList.do";
}

@end


@implementation VideoReuqest

- (NSString *)path{
    
    return @"videoAuth/add.do";
}



@end

@implementation GetVideoRequest

- (NSString *)path{
    
    return @"videoAuth/getList.do";
}

@end


@implementation AuthPushCarRequest

- (NSString *)path{
    
    return @"vehicleAuth/addVehicleAuth.do";
}

@end


@implementation GiftListRequest

- (GJRequestMethod)method{
    
    return GJRequestGET;
}

- (NSString *)path{
    
    return @"gift_package/getList.do";
}

@end

@implementation GetOtherPersonRequest

- (NSString *)path{
    
    return @"user/findOtherDetails.do";
}

@end

@implementation BindMiniProgramRequest

-(NSString *)path{
    return @"memberApply/app_bound.do";
}

- (NSDictionary *)param{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (CurrentUser.userID.length >0) {
        [params setValue:CurrentUser.userID forKey:@"userId"];
    }
    if (CurrentUser.user.phone_num.length > 0) {
        [params setValue:CurrentUser.user.phone_num forKey:@"phoneNum"];
    }
    
    return params.mutableCopy;
    //return @{@"userId":CurrentUser.userID,@"phoneNum":CurrentUser.user.phone_num};
}
@end

@implementation GetYWBTokenReqeuest

-(NSString *)path{
    return @"memberApply/getToken.do";
}

- (NSDictionary *)param{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (CurrentUser.userID.length >0) {
        [params setValue:CurrentUser.userID forKey:@"userId"];
    }
    if (CurrentUser.user.phone_num.length > 0) {
        [params setValue:CurrentUser.user.phone_num forKey:@"phoneNum"];
    }
    
    return params.mutableCopy;
     //return @{@"userId":CurrentUser.userID,@"phoneNum":CurrentUser.user.phone_num};
}

@end


@implementation SuggestRequest

- (NSString *)path{
    return @"evaluate/add.do";
}


- (NSDictionary *)param{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.model) {
        [params setValue:self.model forKey:@"evaluate"];
    }
    if (CurrentUser.userID.length > 0) {
        [params setValue:CurrentUser.userID forKey:@"user_id"];
    }
    
    return params.mutableCopy;
    
    //return @{@"evaluate":self.model,@"user_id":CurrentUser.userID};
}

@end


@implementation CheckCodeRequest

- (NSString *)path{
    
    return @"user/checkCode.do";
}

- (NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.model) {
        [params setValue:self.model forKey:@"code"];
    }
    return params.mutableCopy;
    //return @{@"code":self.model};
}

@end


@implementation DeleteCommentRequest

- (NSString *)path{
    return @"commentary/deleteCommentary.do";
}

- (NSDictionary *)parameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.model) {
        [params setValue:self.model forKey:@"id"];
    }
    if (self.subectId) {
        [params setValue:self.subectId forKey:@"subjectId"];//
    }
    if (self.type) {
        [params setValue:@(self.type) forKey:@"typeId"];//
    }
    
    return params.mutableCopy;
    
    //return @{@"id":self.model,@"subjectId":self.subectId,@"typeId":@(self.type)};
}


@end


