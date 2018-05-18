//
//  ClubCircleDynamicDetailViewModel.m
//  NightclubLive
//
//  Created by WanBo on 17/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ClubCircleDynamicDetailViewModel.h"
#import "ClubCircleRequest.h"

@interface ClubCircleDynamicDetailViewModel(){
    
    NSMutableArray *p_datas;
}

@property (nonatomic, strong, readwrite) RACCommand *commentReuqesCommand;
@property (nonatomic, strong, readwrite) RACCommand *reportReuqesCommand;
//@property (nonatomic, copy, readwrite) NSMutableArray *datas;

@property (nonatomic, strong, readwrite) RACCommand *likeReuqesCommand;

@end

@implementation ClubCircleDynamicDetailViewModel

- (void)initialize {
    
    [super initialize];

    p_datas = [NSMutableArray array];
    
//    DataBaseManager *manager = [DataBaseManager defaultManager];
//    LoginModel *loginModel = [manager queryAllLoginModels].firstObject;
//
//    @weakify(self)
//    RAC(self, datas) = [[self.requestRemoteDataCommand.executionSignals.switchToLatest
//                         startWith:self.fetchLocalData]
//                        map:^(NSArray *datas) {
//                            
//                            @strongify(self)
//                            if (self.dataSource == nil) {
//                                return datas;
//                            } else {
//                                //有待处理的业务逻辑
//                                return datas;
//                            }
//                            
//                        }];
//    
//    [self.requestRemoteDataCommand.errors subscribe:self.errors];
//    
//    _commentReuqesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        
//        
//        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            if (!loginModel) {
//                [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:360 userInfo:nil]];
//            }
//                CommentRequest *request = [CommentRequest new];
//            if (_touserID) {
//                request.param = @{@"typeId":@"1",@"subjectId":_subjectID,@"content":_content,@"userId":loginModel.token?loginModel.token:@"",@"toUserId":_touserID};
//
//            }else{
//                request.param = @{@"typeId":@"1",@"subjectId":_subjectID,@"content":_content,@"userId":loginModel.token?loginModel.token:@""};
//
//            }
//            
//                [request startWithCompletedBlock:^(GJBaseRequest *request) {
//                    if (!request.error) {
//                        NSLog(@"%@",request.responseJson);
//                        
//                        [subscriber sendNext:request.responseJson];
//                        [subscriber sendCompleted];
//                        
//                    }else{
//                        if (SharedAppDelegate.networkStatus==NotReachable){
//                            [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:278 userInfo:nil]];
//                        }else{
//                            [subscriber sendError:request.error];
//                        }
//                        [subscriber sendCompleted];
//                    }
//                }];
//                NSLog(@"---%@",request.param);
//                
//
//            return nil;
//        }];
//        
//        return [signal map:^id(NSDictionary *dict) {
//            NSNumber *isSuccess = @([dict[@"state"] isEqualToString:@"true"]);
//            
//            return isSuccess;
//        }];
//    }];
//    
//    [self.commentReuqesCommand.errors subscribe:self.errors];
//    [self.reportReuqesCommand.errors subscribe:self.errors];
//
//    //--------------------------------------------------------------
//    _likeReuqesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        
//        
//        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            if (!loginModel) {
//                [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:360 userInfo:nil]];
//            }
//            PraiseRequest *request = [PraiseRequest new];
//            if([input intValue]==1){
//                //typeId  点赞的类型（1、主题；2、评论）
//
//                request.param = @{@"typeId":@1,@"subjectId":_model.ID,@"userId":loginModel.token?loginModel.token:@"",@"subjectTypeId":@1,@"likes":@1};
//
//            }else{
//                request.param = @{@"typeId":@2,@"subjectId":_comsubjectID,@"userId":loginModel.token?loginModel.token:@"",@"subjectTypeId":@2,@"likes":@1};
//            }
//            
//            [request startWithCompletedBlock:^(GJBaseRequest *request) {
//                if (!request.error) {
//                    NSLog(@"%@",request.responseJson);
//                    
//                    [subscriber sendNext:request.responseJson];
//                    [subscriber sendCompleted];
//                    
//                }else{
//                    if (SharedAppDelegate.networkStatus==NotReachable){
//                        [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:278 userInfo:nil]];
//                    }else{
//                        [subscriber sendError:request.error];
//                    }
//                    [subscriber sendCompleted];
//                }
//            }];
//            NSLog(@"---%@",request.param);
//            
//            
//            return nil;
//        }];
//        
//        return [signal map:^id(NSDictionary *dict) {
//
//            return @{@"resultCode":@([dict[@"state"] isEqualToString:@"true"] ? 0 : 1),@"type":@(0)};
//        }];
//    }];
//    [self.likeReuqesCommand.errors subscribe:self.errors];

}

//- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
//
//    RACSignal *fetchSignal = [RACSignal empty];
//    
//    fetchSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        CommentarygetListRequest *request = [CommentarygetListRequest new];
//        //typeId   1.动态 2.心声
//
//        request.param = @{@"typeId":@1,@"subjectId":_model.ID};
//        [request startWithCompletedBlock:^(GJBaseRequest *request) {
//            
//            if (request.error) {
//                if (SharedAppDelegate.networkStatus==NotReachable){
//                    [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:278 userInfo:nil]];
//                }else{
//                    [subscriber sendError:request.error];
//                }
//                [subscriber sendCompleted];
//            }else{
//                
//                DynamicCommentListSuperModel *model = [DynamicCommentListSuperModel mj_objectWithKeyValues:request.responseJson];
//                NSLog(@"%@",request.responseJson);
////                
//                [subscriber sendNext:model];
//                [subscriber sendCompleted];
//            }
//        }];
//        
//        return nil;
//    }];
//    
//    return [fetchSignal map:^id(DynamicCommentListSuperModel *model) {
//        NSMutableArray *marr = [NSMutableArray array];
//        for (DynamicCommentListModel *model11 in model.result) {
//                [marr addObject:model11];
//        }
//        return model.result;
//    }];
//}

//- (RACCommand *)unlikeRequestCommand{
//    
//    if (!_unlikeRequestCommand){
//        
//        _unlikeRequestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            
//            
//            RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                
//                PraiseRequest *request = [PraiseRequest new];
//                //typeId  点赞的类型（1、主题；2、评论）
//                request.param = @{@"userId":[UserInfo shareUser].userID,@"subjectTypeId":@(1),@"subjectId":_model.ID,@"typeId":@(1)};
//                request.tag = 1;
//                
//                [request startWithCompletedBlock:^(GJBaseRequest *request) {
//                    if (!request.error) {
//                        NSLog(@"%@",request.responseJson);
//                        
//                        [subscriber sendNext:request.responseJson];
//                        [subscriber sendCompleted];
//                        
//                    }else{
//                        if (SharedAppDelegate.networkStatus==NotReachable){
//                            [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:278 userInfo:nil]];
//                        }else{
//                            [subscriber sendError:request.error];
//                        }
//                        [subscriber sendCompleted];
//                    }
//                }];
//                NSLog(@"---%@",request.param);
//                
//                
//                return nil;
//            }];
//            
//            return [signal map:^id(NSDictionary *dict) {
//
//                return @{@"resultCode":dict[@"code"],@"type":@(1)};
//            }];
//        }];
//
//    }
//    return _unlikeRequestCommand;
//}

- (RACCommand *)getReplyCommand{
    
    if (!_getReplyCommand){
        
        _getReplyCommand = [RACCommand createCommandWithDoBlock:^(id<RACSubscriber> subscriber) {
            
            CommentarygetListRequest *r = [CommentarygetListRequest new];
            
            r.param = @{@"pageNow":@(self.currentPage),@"typeId":@1,@"subjectId":_model.ID,@"userId":[UserInfo shareUser].userID};
            
            [r startWithCompletedBlock:^(GJBaseRequest *request) {
                
                ResponseState *state = [ResponseState objectWithDic:request.responseObject];
                
                if (state.isSuccess){
                    
                    if (self.refreshType == RefreshTypeLoad){
                        [p_datas removeAllObjects];
                    }
                    
                    [p_datas addObjectsFromArray:[DynamicCommentListModel arrayObjectWithDS:state.data]];
                }
                
                [subscriber sendNext:state];
                [subscriber sendCompleted];
                
            }];
        }];
    }
    return _getReplyCommand;
}

- (RACCommand *)reportReuqesCommand{

    if (!_reportReuqesCommand){
        
//        ReportRequest *request = [ReportRequest new];
//        
//        request.param = @{@"reportType":@"0",@"subjectId":_subjectID,@"content":@"xxxx",@"userId":loginModel.token?loginModel.token:@"",@"subjectTypeId":@"1"};
//        
//        [request startWithCompletedBlock:^(GJBaseRequest *request) {
//            if (!request.error) {
//                NSLog(@"%@",request.responseJson);
//                
//                [subscriber sendNext:request.responseJson];
//                [subscriber sendCompleted];
//                
//            }else{
//                if (SharedAppDelegate.networkStatus==NotReachable){
//                    [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:278 userInfo:nil]];
//                }else{
//                    [subscriber sendError:request.error];
//                }
//                [subscriber sendCompleted];
//            }
//        }];

        
    }
    return _reportReuqesCommand;
}

- (RACCommand *)commentReuqesCommand{
    
    if (!_commentReuqesCommand){
        
        _commentReuqesCommand = [RACCommand createCommandWithDoBlock:^(id<RACSubscriber> subscriber) {
            
            CommentRequest *request = [CommentRequest new];
            
            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"typeId":@1,@"subjectId":self.model.ID,@"content":self.content,@"userId":[UserInfo shareUser].userID}];
            if (_touserID){
                [param setValue:_touserID forKey:@"toUserId"];
            }
            
            request.param = [param copy];
            
            [request startWithCompletedBlock:^(GJBaseRequest *request) {
                
                ResponseState *state = [ResponseState objectWithDic:request.responseObject];
                
                [subscriber sendNext:state];
                [subscriber sendCompleted];
            }];

            
        }];
    }
    return _commentReuqesCommand;
}


- (NSArray *)datas{

    return [p_datas copy];
}
@end
