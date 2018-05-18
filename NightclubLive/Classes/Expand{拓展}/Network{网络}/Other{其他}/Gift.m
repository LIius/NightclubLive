//
//  Gift.m
//  NightclubLive
//
//  Created by RDP on 2017/3/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "Gift.h"

@implementation GetWheelLeafRequest

- (NSString *)path{
    
    return @"wheel/img.do";
}

- (GJRequestMethod)method{
    
    return GJRequestGET;
}

@end

@implementation GetWheelListRequest

- (NSString *)path{
    
    return @"wheel/getList.do";
}

- (GJRequestMethod)method{
    
    return GJRequestGET;
}

@end

@implementation GetResultRequest

- (NSString *)path{
    
    return @"wheel/draw.do";
}

- (GJRequestMethod)method{
    
    return GJRequestPOST;
}

@end

@implementation SendGiftRequest

-(NSString *)path{
    return @"gift/addGift.do";
}

- (NSDictionary *)param{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (CurrentUser.userID.length >0) {
        [param setValue:CurrentUser.userID forKey:@"giver_id"];
    }
    
    if (_receiverID) {
        [param setValue:_receiverID forKey:@"receiver_id"];
    }
    if (_giftID) {
        [param setValue:_giftID forKey:@"gift_id"];
    }
    if (_giftType) {
        [param setValue:@(_giftType) forKey:@"gift_type"];
    }
    if (_giftCount) {
        [param setValue:_giftCount forKey:@"gift_count"];
    }
    if (_projectID) {
        [param setValue:_projectID forKey:@"project_id"];
    }
    
    [param setValue:@"gift" forKey:@"describe_content"];
    
    if (_giftType == 6){
        [param setValue:@(0) forKey:@"project_id"];
        if (_phoneNum) {
            [param setValue:_phoneNum forKey:@"receiver_mobile"];
        }
        
    }
    
    return param.mutableCopy;
    
}

@end
