//
//  AllActivitiesViewModel.m
//  NightclubLive
//
//  Created by WanBo on 17/1/16.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AllActivitiesViewModel.h"
#import "CampaignRequest.h"
#import "CampaignModel.h"

@implementation AllActivitiesViewModel

- (instancetype)init{
    
    self = [super init];
    
    if (!self)
        return nil;
    
    _runforCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

            //请求列表
//            CampaignListRequest *request = [CampaignListRequest new];
//            
//            [request startWithCompletedBlock:^(GJBaseRequest *request) {
//            
//                NSDictionary *responseDic = request.responseObject;
//                [subscriber sendNext:responseDic];
//                [subscriber sendCompleted];
//            }];
            
            CampaignListRequest *r = [CampaignListRequest new];
            
            [r startWithCompletedBlock:^(GJBaseRequest *request) {
                
    //            ResponseState *state = [ResponseState objectWithDic:request.responseObject];
//                
//                [self.dataSource ]
            }];
            
            return nil;
        }];
        
        return signal;
    }];
    
    
    return self;
}
@end
