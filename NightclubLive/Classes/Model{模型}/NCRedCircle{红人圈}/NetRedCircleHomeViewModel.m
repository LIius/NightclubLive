//
//  NetRedCircleHomeViewModel.m
//  NightclubLive
//
//  Created by WanBo on 17/1/14.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NetRedCircleHomeViewModel.h"
#import "NetRedCircleRequest.h"
#import "NetRedBannerModel.h"

@interface NetRedCircleHomeViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *dataReuqesCommand;

@end

@implementation NetRedCircleHomeViewModel

- (void)initialize {

//--------------------------------------------------------------
    _dataReuqesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    
    RACSignal *bannerSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        NetRedBannnerCircleRequest *request = [NetRedBannnerCircleRequest new];
        
        [request startWithCompletedBlock:^(GJBaseRequest *request) {
            if (!request.error) {
                
                NSLog(@"%@",request.responseJson);
                NetRedBannerSuperModel *model = [NetRedBannerSuperModel mj_objectWithKeyValues:request.responseJson];

                [subscriber sendNext:model];
                [subscriber sendCompleted];
                
            }else{
                if (SharedAppDelegate.networkStatus==NotReachable){
                    [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:278 userInfo:nil]];
                }else{
                    [subscriber sendError:request.error];
                }
                [subscriber sendCompleted];
            }
        }];
        NSLog(@"---%@",request.param);
        return nil;
    }];
        //-_____________________________________________________________________________

        
        RACSignal *getListSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            GetListRequest *request = [GetListRequest new];
            
            
            [request startWithCompletedBlock:^(GJBaseRequest *request) {
                if (!request.error) {
                    
                    NSLog(@"%@",request.responseJson);
                    ListSuperModel *model = [ListSuperModel mj_objectWithKeyValues:request.responseJson];
                    
                    [subscriber sendNext:model];
                    [subscriber sendCompleted];

                }else{
                    if (SharedAppDelegate.networkStatus==NotReachable){
                        [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:278 userInfo:nil]];
                    }else{
                        [subscriber sendError:request.error];
                    }
                    [subscriber sendCompleted];
                }
            }];
            NSLog(@"---%@",request.param);
            return nil;
        }];
        //-_____________________________________________________________________________
        //-_____________________________________________________________________________
        
        
        RACSignal *activityListSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            ActivityListRequest *request = [ActivityListRequest new];
            
            [request startWithCompletedBlock:^(GJBaseRequest *request) {
                if (!request.error) {
                    NSLog(@"%@",request.responseJson);
                    ActivityListSuperModel *model = [ActivityListSuperModel mj_objectWithKeyValues:request.responseJson];
                    
                    [subscriber sendNext:model];
                    [subscriber sendCompleted];
                    
                }else{
                    if (SharedAppDelegate.networkStatus==NotReachable){
                        [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:278 userInfo:nil]];
                    }else{
                        [subscriber sendError:request.error];
                    }
                    [subscriber sendCompleted];
                }
            }];
            NSLog(@"---%@",request.param);
            return nil;
        }];
        //-_____________________________________________________________________________
        
        
        RACSignal *zipSignal = [RACSignal zip:@[bannerSignal,getListSignal,activityListSignal] reduce:^id(NetRedBannerSuperModel *model1,ListSuperModel *model2,ActivityListSuperModel *model3){
            
            return RACTuplePack(model1.result,model2.result,model3.result);
            
        }];
        return zipSignal;

    }];

    [self.dataReuqesCommand.errors subscribe:self.errors];

}

@end
