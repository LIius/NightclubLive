//
//  ClubCircleVoiceViewModel.m
//  NightclubLive
//
//  Created by WanBo on 17/1/3.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ClubCircleVoiceViewModel.h"
#import "ClubCircleRequest.h"
#import "DynamicListModel.h"
#import "VoiceListModel.h"

@interface ClubCircleVoiceViewModel ()

@property (nonatomic, copy, readwrite) NSArray *datas;

@end
@implementation ClubCircleVoiceViewModel

- (instancetype)init{
    
    self = [super init];
    
    if (!self)
        return nil;
    
    return self;
}

- (void)initialize {
    
    [super initialize];
    
    @weakify(self)
    RAC(self, datas) = [[self.requestRemoteDataCommand.executionSignals.switchToLatest
                         startWith:self.fetchLocalData]
                        map:^(NSArray *datas) {
                            
                            @strongify(self)
                            if (self.dataSource == nil) {
                                return datas;
                            } else {
                                //有待处理的业务逻辑
                                return datas;
                            }
                            
                        }];
    
    [self.requestRemoteDataCommand.errors subscribe:self.errors];
    
}

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    
    RACSignal *fetchSignal = nil;
    fetchSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        HeartSoundSubjectRequest *request = [HeartSoundSubjectRequest new];
        
        [request startWithCompletedBlock:^(GJBaseRequest *request) {
            
            if (request.error) {
                if (SharedAppDelegate.networkStatus==NotReachable){
                    [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:278 userInfo:nil]];
                }else{
                    [subscriber sendError:request.error];
                }
                [subscriber sendCompleted];
            }else{
                
                VoiceListModelSuperModel *model = [VoiceListModelSuperModel mj_objectWithKeyValues:request.responseJson];
                NSLog(@"%@",request.responseJson);
                
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            }
        }];
        
        return nil;
    }];
    
    return [fetchSignal map:^id(DynamicListSuperModel *model) {
        return model.result;
    }];
}

- (id)fetchLocalData {
    
    return @[];
}


#pragma mark - Getter

- (RACCommand *)getListcommand{
    
    if (!_getListcommand){
        
        _getListcommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                
                HeartSoundSubjectRequest *request = [HeartSoundSubjectRequest new];
                
                [request startWithCompletedBlock:^(GJBaseRequest *request) {
                    
                    if (request.error) {
                        if (SharedAppDelegate.networkStatus==NotReachable){
                            [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:278 userInfo:nil]];
                        }else{
                            [subscriber sendError:request.error];
                        }
                        [subscriber sendCompleted];
                    }else{
                        
                        NSArray *datas = [VoiceListModel arrayObjectWithDS:request.responseObject[@"data"]];
                        _datas = datas;
                        [subscriber sendNext:@{@"msg":request.responseObject[@"msg"],@"data":datas,@"dataCount":@(datas.count)}];
                        [subscriber sendCompleted];
                    }
                }];

                
                return nil;
            }];
            
            return [signal map:^id(id value) {
                return value;
            }];
        }];
    }
    return _getListcommand;
}


@end
