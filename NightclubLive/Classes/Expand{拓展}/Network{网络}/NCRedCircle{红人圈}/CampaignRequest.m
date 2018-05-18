//
//  Campaign.m
//  NightclubLive
//
//  Created by RDP on 2017/3/8.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "CampaignRequest.h"

@implementation CampaignListRequest

- (NSString *)path{
    
    return @"campaign/getList.do";
}

@end


@implementation MyCampaignListRequest
- (NSString *)path{
    
    return @"campaignsub/getCampaignList.do";
}

@end

@implementation CampaignJoinRequest

- (NSString *)path{
    return @"campaignsub/addCampaignsub.do";
}

@end

@implementation CampaignJoinaListRequest

- (NSString *)path{
    
    return @"campaignsub/getList.do";
}


@end


@implementation CampaignJoinGiftListRequest


- (NSString *)path{
    
    return @"campaignsub/findProjectSupporter.do";
}

@end
