//
//  ClubCircleDynamicViewModel.m
//  NightclubLive
//
//  Created by WanBo on 17/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ClubCircleDynamicViewModel.h"
#import "ClubCircleRequest.h"
#import "DynamicListModel.h"


@interface ClubCircleDynamicViewModel (){
    NSMutableArray *p_datas;
}

//@property (nonatomic, copy, readwrite) NSMutableArray *datas;
@property (nonatomic, strong, readwrite) RACCommand *likeReuqesCommand;
@property (nonatomic, strong, readwrite) RACCommand *unlikeReuqesCommand;

@end

@implementation ClubCircleDynamicViewModel


- (instancetype)init{
    
    self = [super init];
    
    if (!self)
        return self;
    
    p_datas = [NSMutableArray array];
    

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
    //--------------------------------------------------------------    [self.likeReuqesCommand.errors subscribe:self.errors];
    //--------------------------------------------------------------
    //获取列表
    
    [self.unlikeReuqesCommand.errors subscribe:self.errors];
    
    return self;
}


- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    
    RACSignal *fetchSignal = [RACSignal empty];
    
    fetchSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setValue:@(self.page) forKey:@"pageNow"];
        if (_onLocation){
            [params setValue:self.latitude forKey:@"latitude"];
            [params setValue:self.longitude forKey:@"longitude"];
        }
        
        ClubCircleGetListRequest *request = [ClubCircleGetListRequest new];
        request.param = [params copy];
        
        [request startWithCompletedBlock:^(GJBaseRequest *request) {
            
            DynamicListSuperModel *model = [DynamicListSuperModel mj_objectWithKeyValues:request.responseJson];

            [subscriber sendNext:@{@"list":model.result,@"code":request.responseObject[@"code"],@"msg":request.responseObject[@"msg"],@"listCount":@(model.result.count)}];
            [subscriber sendCompleted];

            if (request.error) {
                if (SharedAppDelegate.networkStatus==NotReachable){
                    [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:278 userInfo:nil]];
                }else{
                    [subscriber sendError:request.error];
                }
                [subscriber sendCompleted];
            }
        }];
    
    return nil;
    }];

    return [fetchSignal map:^id(id value) {
        
        if (self.refreshType == RefreshTypeLoad && [value[@"code"] integerValue] == 0){
            
            [p_datas removeAllObjects];
        }
        
        NSArray *list = value[@"list"];
        [p_datas addObjectsFromArray:list];
        
        return value;
    }];
}

- (id)fetchLocalData {
    
    return @[];
    
}


#pragma mark - Getter

- (RACCommand *)getListCommand{
    
    if (!_getListCommand){
        
        _getListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            RACSignal *s = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                
                [params setValue:@(self.page) forKey:@"pageNow"];
                [params setValue:[UserInfo shareUser].userID forKey:@"userId"];
                if (_onLocation){
                    [params setValue:self.latitude forKey:@"latitude"];
                    [params setValue:self.longitude forKey:@"longitude"];
                }
                
                ClubCircleGetListRequest *request = [ClubCircleGetListRequest new];
                request.param = [params copy];
                
                [request startWithCompletedBlock:^(GJBaseRequest *request) {
                    
                    if (request.error) {
                        if (SharedAppDelegate.networkStatus==NotReachable){
                            [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:278 userInfo:nil]];
                        }else{
                            [subscriber sendError:request.error];
                        }
                        [subscriber sendCompleted];
                    }
                    
                    if ([request.responseObject[@"code"] integerValue] == 1){
                        
                        [subscriber sendNext:@{@"code":request.responseObject[@"code"],@"msg":request.responseObject[@"msg"],@"listCount":@(0)}];
                        [subscriber sendCompleted];
                    }
                    else{
                        
                        DynamicListSuperModel *model = [DynamicListSuperModel mj_objectWithKeyValues:request.responseJson];
                        
                        if (model.result){
                            [subscriber sendNext:@{@"list":model.result,@"code":request.responseObject[@"code"],@"msg":request.responseObject[@"msg"],@"listCount":@(model.result.count)}];
                        }
                        else{
                            [subscriber sendNext:nil];
                        }
                        
                        [subscriber sendCompleted];

                    }
                }];
                
                return nil;
            }];
            
            return [s map:^id(NSDictionary *value) {

                NSArray *datas = value[@"list"];
                
                NSArray *frames;
                
                
                if (self.refreshType == RefreshTypeLoad){
                    [p_datas removeAllObjects];
                }
                
                if (datas.count > 0){
                    frames = [DynamicListModelFrame arrayObjectWithFrameObject:datas];
                    [p_datas addObjectsFromArray:frames];
                }
                
                
                return value;
            }];
        }];
    }
    return _getListCommand;
}

- (RACCommand *)likeReuqesCommand{
    
    if (!_likeReuqesCommand){
        
        _likeReuqesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            
            RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

                PraiseRequest *request = [PraiseRequest new];
                //typeId  点赞的类型（1、主题；2、评论）
                
                DynamicListModelFrame *frame = p_datas[self.indexPath.row];
                DynamicListModel *model = frame.model;
                
                request.param = @{@"userId":[UserInfo shareUser].userID,@"subjectTypeId":@(1),@"subjectId":model.ID,@"typeId":@(1)};
                
                [request startWithCompletedBlock:^(GJBaseRequest *request) {
                    if (!request.error) {
                        NSLog(@"%@",request.responseJson);
                        
                        [subscriber sendNext:request.responseJson];
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
            
            return [signal map:^id(NSDictionary *dict) {
               
                BOOL isSuccess = [dict[@"state"] isEqualToString:@"true"];
                DynamicListModelFrame *frameModel = p_datas[self.indexPath.row];
                frameModel.model.ispraise = isSuccess;
                frameModel.model.praise += (isSuccess ? 1 : 0);
                
                return @{@"resultCode":@(isSuccess),@"msg":dict[@"message"]};
            }];
        }];

    }
    return _likeReuqesCommand;
}

- (RACCommand *)unlikeReuqesCommand{
    
    if (!_unlikeReuqesCommand){
        
        _unlikeReuqesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            
            RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

                DynamicListModelFrame *frame = p_datas[self.indexPath.row];
                DynamicListModel *model = frame.model;
                
                PraiseRequest *request = [PraiseRequest new];
                //typeId  点赞的类型（1、主题；2、评论）
                request.param = @{@"userId":[UserInfo shareUser].userID,@"subjectTypeId":@(1),@"subjectId":model.ID,@"typeId":@(1)};
                request.tag = 1;
                
                [request startWithCompletedBlock:^(GJBaseRequest *request) {
                    if (!request.error) {
                        NSLog(@"%@",request.responseJson);
                        
                        [subscriber sendNext:request.responseJson];
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
            
            return [signal map:^id(NSDictionary *dict) {
                BOOL isSuccess = [dict[@"code"] integerValue] == 0;
                DynamicListModelFrame *frameModel = p_datas[self.indexPath.row];
                frameModel.model.ispraise = (isSuccess ? NO : YES);
                frameModel.model.praise -= (isSuccess ? 1 : 0);
                
                return @{@"resultCode":@(isSuccess),@"msg":dict[@"msg"]};            }];
        }];

    }
    return _unlikeReuqesCommand;
}

- (NSArray *)datas{
    
    return [p_datas copy];
}

@end
