//
//  NetRedCircleRequest.m
//  NightclubLive
//
//  Created by WanBo on 17/1/14.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NetRedCircleRequest.h"
#import "NetRedBannerModel.h"

@implementation NetRedCircleRequest

@end

@implementation NetRedBannnerCircleRequest

- (NSString *)path{
    return @"banner/getBannerList.do";
}

- (NSDictionary *)parameters{
    return self.param;
}

- (GJRequestMethod)method{
    return GJRequestGET;
}

- (Class)modelClass{
    return [NetRedBannerSuperModel class];
}

- (GJAPICachePolicy)cachePolicy {
    return GJNotAPICachePolicy;
}

- (NSTimeInterval)cacheValidTime {
    return 10 * 60;
}

@end

@implementation GetListRequest

- (NSString *)path{
    return @"online/getList.do";
}

- (NSDictionary *)parameters{
    return self.param;
}

- (GJRequestMethod)method{
    return GJRequestGET;
}

- (Class)modelClass{
    return [ListSuperModel class];
}

- (GJAPICachePolicy)cachePolicy {
    return GJNotAPICachePolicy;
}

- (NSTimeInterval)cacheValidTime {
    return 10 * 60;
}

@end


@implementation ActivityListRequest

- (NSString *)path{
    return @"activity/getList.do";
}

- (NSDictionary *)parameters{
    return self.param;
}

- (GJRequestMethod)method{
    return GJRequestGET;
}

- (Class)modelClass{
    return [ActivityListSuperModel class];
}

- (GJAPICachePolicy)cachePolicy {
    return GJNotAPICachePolicy;
}

- (NSTimeInterval)cacheValidTime {
    return 10 * 60;
}

@end


@interface RankListObjectRequest()
/** 对象 */
@property (nonatomic, strong) NSNumber  *model;

@end

@implementation RankListObjectRequest
@dynamic model;

- (NSDictionary *)parameters{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (CurrentUser.userID.length >0) {
        [params setValue:CurrentUser.userID forKey:@"userId"];
    }
    if (self.model) {
        [params setValue:self.model forKey:@"serach_period"];
    }
    
    return params.mutableCopy;
    //return @{@"userId":CurrentUser.userID,@"serach_period":self.model};
}

@end

@implementation CharmRankListRequest

- (NSString *)path{
    
    return @"ranking/charm_list.do";
}


@end

@implementation TheRichRankListRequest

- (NSString *)path{
    
    return @"ranking/daifug_list.do";
}

@end


@implementation BarListRequest

- (NSString *)path{
    
    return @"seller/list.do";
}

- (NSDictionary *)parameters{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (CurrentUser.userID.length >0) {
        [param setValue:CurrentUser.userID forKey:@"userId"];
    }
    
    if (CurrentUser.location.lclatitude && CurrentUser.location.lclongitude){
        [param setValue:CurrentUser.location.lclatitude forKey:@"lat"];
        [param setValue:CurrentUser.location.lclongitude forKey:@"lng"];
    }
    
    
    if (self.ishot){
        [param setValue:@"yes" forKey:@"is_hot"];
    }
    
    if (_searchKey){
        [param setValue:_searchKey forKey:@"like_msg"];
    }
    
    if (_bartype.length > 0){
        [param setValue:_bartype forKey:@"bar_type"];
    }
    
    if (_pageNow) {
        [param setValue:@(_pageNow) forKey:@"pageNow"];
    }
    

    
    return param.mutableCopy;
}

@end


@implementation BarDetailsRequest

- (NSString *)path{
    
    return @"seller/seller_details.do";
}

- (NSDictionary *)parameters{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (CurrentUser.userID.length >0) {
        [params setValue:CurrentUser.userID forKey:@"userId"];
    }
    if (self.model) {
        [params setValue:self.model forKey:@"sellerId"];
    }
    
    return params.mutableCopy;
    //return @{@"userId":CurrentUser.userID,@"sellerId":self.model};
}

@end

@implementation BarPersonRankListRequest

- (NSDictionary *)parameters{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (CurrentUser.userID.length >0) {
        [params setValue:CurrentUser.userID forKey:@"userId"];
    }
    if (self.model) {
        [params setValue:self.model forKey:@"sellerId"];
    }
    
    if (self.tag) {
        [params setValue:@(self.tag) forKey:@"pageNow"];
    }
    
    return params.mutableCopy;
    //return @{@"userId":CurrentUser.userID,@"sellerId":self.model,@"pageNow":@(self.tag)};
}

@end

@implementation BarCharamRankRequest

- (NSString *)path{
    
    return @"seller/charm_tarento.do";
}

@end

@implementation BarExpertRankRequest

- (NSString *)path{
    
    return @"seller/club_tarento.do";
}

@end


@implementation BarActivityRequest

- (NSString *)path{
    return @"seller/party.do";
}

- (NSDictionary *)parameters{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (CurrentUser.userID.length >0) {
        [params setValue:CurrentUser.userID forKey:@"userId"];
    }
    if (self.model) {
        [params setValue:self.model forKey:@"sellerId"];
    }
    
    if (self.tag) {
        [params setValue:@(self.tag) forKey:@"pageNow"];
    }
    
    return params.mutableCopy;
    //return @{@"userId":CurrentUser.userID,@"sellerId":self.model,@"pageNow":@(self.tag)};
}

@end


@implementation AcitvityCharamListRequest

- (NSString *)path{
    return @"planActivity/night_club_revel_charm_ranking.do";
}

- (NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (CurrentUser.userID.length >0) {
        [params setValue:CurrentUser.userID forKey:@"userId"];
    }
    
    if (self.tag) {
        [params setValue:@(self.tag) forKey:@"isall"];
    }
    
    return params.mutableCopy;
    //return @{@"userId":CurrentUser.userID,@"isall":@(self.tag)};
}

@end

@implementation AcitvityTheRichListRequest

- (NSString *)path{
    return @"planActivity/night_club_revel_daifug_ranking.do";
}

- (NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (CurrentUser.userID.length >0) {
        [params setValue:CurrentUser.userID forKey:@"userId"];
    }
    
    if (self.tag) {
        [params setValue:@(self.tag) forKey:@"isall"];
    }
    
    return params.mutableCopy;
    //return @{@"userId":CurrentUser.userID,@"isall":@(self.tag)};
}

@end
