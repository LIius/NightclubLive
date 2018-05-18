//
//  ClubCircleRequest.m
//  NightclubLive
//
//  Created by WanBo on 17/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ClubCircleRequest.h"
#import "DynamicListModel.h"
#import "VoiceListModel.h"
#import "DynamicCommentListModel.h"
#import "HeartsoundListModel.h"
#import "VoiceCommentModel.h"


@implementation ClubCircleGetListRequest

- (NSString *)path{
    return @"dynamic/getList.do";
}

@end

@implementation GetQNAuthTokenRequest

- (NSString *)path{
    return @"upload/getToken.do";
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

#pragma mark - 发布动态
@implementation ReleaseDynamicRequest

- (NSString *)path{
    return @"dynamic/addDynamic.do";
}

- (NSDictionary *)parameters{
    
    NSArray *imgs = [self.param arrayForKey:@"images"];
    
    
    if (imgs.count >0){
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:imgs
                                                           options:kNilOptions
                                                             error:nil];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.param];
        
        if (jsonString) {
            [params setValue:jsonString forKey:@"images"];
        }
        
        return params.mutableCopy;
    }
    
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

@implementation DeleteDynamicRequest

- (NSString *)path{
    
    return @"dynamic/editPersonDynamic.do";
}

@end

@implementation HeartSoundSubjectRequest

- (NSString *)path{
    return @"heartSoundSubject/getListHeartSoundSubject.do";
}

- (NSDictionary *)parameters{
    return self.param;
}

- (GJRequestMethod)method{
    return GJRequestPOST;
}

- (Class)modelClass{
    return [VoiceListModelSuperModel class];
}

- (GJAPICachePolicy)cachePolicy {
    return GJNotAPICachePolicy;
}

- (NSTimeInterval)cacheValidTime {
    return 10 * 60;
}

@end


@implementation CommentVoiceListRequest

- (NSString *)path{
    return @"commentary/getList.do";
}

- (NSDictionary *)parameters{
    return self.param;
}

- (GJRequestMethod)method{
    return GJRequestPOST;
}

- (Class)modelClass{
    return [VoiceCommentModel class];
}

- (GJAPICachePolicy)cachePolicy {
    return GJNotAPICachePolicy;
}

- (NSTimeInterval)cacheValidTime {
    return 10 * 60;
}

@end

@implementation HeartsoundRequest

- (NSString *)path{
    return @"heartsound/getList.do";
}

- (NSDictionary *)parameters{
    return self.param;
}

- (GJRequestMethod)method{
    return GJRequestPOST;
}

- (Class)modelClass{
    return [HeartsoundListSuperModel class];
}

- (GJAPICachePolicy)cachePolicy {
    return GJNotAPICachePolicy;
}

- (NSTimeInterval)cacheValidTime {
    return 10 * 60;
}

@end

@implementation AddHeartSoundRequest

- (NSString *)path{
    return @"heartsound/addHeartSound.do";
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

@implementation PraiseRequest

- (NSString *)path{

    if (self.tag == 1)
        return @"praise/cancelPraise.do";
    else
        return @"praise/addPraise.do";
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


@implementation BarTableNoRequest

- (NSString *)path{
    
    return @"seller/table_no.do";
}

@end


@implementation BarPackageDetailsRequest

- (NSString *)path{
    
    return @"combo/getComboDetail";
}

- (NSString *)baseUrl{
    
    return URL_TTPBASE;
}

@end

@implementation DeleteMyHearRequest

- (NSString *)path{
    return @"heartsound/delete.do";
}

- (NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.model) {
        [params setValue:self.model forKey:@"id"];
    }

    return params.mutableCopy;
    //return @{@"id":self.model};
}

@end
