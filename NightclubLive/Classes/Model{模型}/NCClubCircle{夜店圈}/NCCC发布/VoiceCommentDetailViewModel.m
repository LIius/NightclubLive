//
//  VoiceCommentDetailViewModel.m
//  NightclubLive
//
//  Created by WanBo on 17/1/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "VoiceCommentDetailViewModel.h"
#import "ClubCircleRequest.h"
#import "DynamicListModel.h"
#import "AFNetworking.h"
#import "QiniuSDK.h"
#import "GPraiseRequest.h"

@interface VoiceCommentDetailViewModel (){
    
    NSMutableArray *p_datas;
}

@property (nonatomic, readwrite) NSArray *datas;
@property (nonatomic, strong, readwrite) RACCommand *voiceCommintCommand;
@property (nonatomic, strong, readwrite) RACCommand *likeReuqesCommand;

@end

@implementation VoiceCommentDetailViewModel

- (instancetype)init{
    
    self = [super init];
    
    p_datas = [NSMutableArray array];
    
    return self;
}

- (void)removeAtIndex:(NSInteger)index{
    [p_datas removeObjectAtIndex:index];
}

- (void)initialize {
    
    [super initialize];
    
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
    [self.voiceCommintCommand.errors subscribe:self.errors];
    
    //--------------------------------------------------------------
    _likeReuqesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            PraiseRequest *request = [PraiseRequest new];
            /*if([input intValue]==1){
                request.param = @{@"typeId":@1,@"subjectId":_model.ID,@"userId":loginModel.token?loginModel.token:@"",@"subjectTypeId":@2,@"likes":@1};
            }else{
                request.param = @{@"typeId":@2,@"subjectId":_comsubjectID,@"userId":loginModel.token?loginModel.token:@"",@"subjectTypeId":@2,@"likes":@1};
            }*/
            
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
        
        /*return [signal map:^id(NSDictionary *dict) {
            NSNumber *isSuccess = @([dict[@"state"] isEqualToString:@"true"]);
            
            return isSuccess;
        }];*/
        return signal;
    }];
//    [self.likeReuqesCommand.errors subscribe:self.errors];
}

//- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
//    
//    RACSignal *fetchSignal = [RACSignal empty];
//    
//    fetchSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        CommentVoiceListRequest *request = [CommentVoiceListRequest new];
//        //typeId   1.动态 2.心声
//        //subjectId   动态或者心声的ID
//        request.param = @{@"typeId":@2,@"subjectId":_model.ID};
//        [request startWithCompletedBlock:^(GJBaseRequest *request) {
//            
//            VoiceCommentModel *model = [VoiceCommentModel mj_objectWithKeyValues:request.responseJson];
//            NSLog(@"%@",request.responseJson);
//            
//            [subscriber sendNext:model];
//            [subscriber sendCompleted];
//            
//            if (request.error) {
//                if (SharedAppDelegate.networkStatus==NotReachable){
//                    [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:278 userInfo:nil]];
//                }else{
//                    [subscriber sendError:request.error];
//                }
//                [subscriber sendCompleted];
//            }
//        }];
//        
//        return nil;
//    }];
//    
//    return [fetchSignal map:^id(VoiceCommentModel *model) {
//        return model.result;
//    }];
//}

- (id)fetchLocalData {
    
    return @[];
    
}

- (RACCommand *)voiceCommintCommand{
    
    @weakify(self);
    if (!_voiceCommintCommand){
        
      //  weakify(self);
        _voiceCommintCommand = [RACCommand createCommandWithDoBlock:^(id<RACSubscriber> subscriber) {
            
            CommentRequest *request = [CommentRequest new];
//            if (_touserID) {
//                request.param = @{@"userId":[UserInfo shareUser].userID,@"content":_content.length>0?_content:@"",@"typeId":@2,@"subjectId":_model.ID,@"toUserId":_touserID};
//                
//            }else{
//                request.param = @{@"userId":[UserInfo shareUser].userID,@"content":_content.length>0?_content:@"",@"typeId":@2,@"subjectId":_model.ID};
//                
//            }
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if ([UserInfo shareUser].userID.length >0) {
                [params setValue:[UserInfo shareUser].userID forKey:@"userId"];
            }
            if (_content.length > 0) {
                [params setValue:_content forKey:@"content"];
            }else{
                [params setValue:@"" forKey:@"content"];
            }
            
            [params setValue:@2 forKey:@"typeId"];
            
            if (_model.ID.length >0) {
                [params setValue:_model.ID forKey:@"subjectId"];
            }
            
            if (_touserID.length >0) {
                [params setValue:_touserID forKey:@"toUserId"];
            }
            
            if (_replyType) {
                [params setValue:@(_replyType) forKey:@"Reply_type"];
            }
            
            // NSDictionary *param =  @{@"userId":[UserInfo shareUser].userID,@"content":_content.length>0?_content:@"",@"typeId":@2,@"subjectId":_model.ID,@"toUserId":_touserID,@"Reply_type":@(_replyType)};
            
            request.param = params;
            
            /*[request startWithCompletedBlock:^(GJBaseRequest *request) {
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
            }];*/
            
            [request startRequestWithCompleted:^(ResponseState *state) {
                @strongify(self);
                [subscriber sendNext:state];
                [subscriber sendCompleted];
                self.touserID = nil;

            }];
        }];
    }
    
    return _voiceCommintCommand;
}


- (RACCommand *)getCommentListCommand{
    
    if (!_getCommentListCommand){
        
        _getCommentListCommand = [RACCommand createCommandWithDoBlock:^(id<RACSubscriber> subscriber) {
            
            CommentVoiceListRequest *r = [CommentVoiceListRequest new];
            r.param = @{@"pageNow":@(self.pageNow),@"typeId":@2,@"subjectId":self.model.ID,@"userId":[UserInfo shareUser].userID};
            
            [r startWithCompletedBlock:^(GJBaseRequest *request) {
                
                ResponseState *state = [ResponseState objectWithDic:request.responseObject];
                
                if (state.isSuccess){
                    
                    if (self.refreshType == RefreshTypeLoad)
                        [p_datas removeAllObjects];
                    
                    [p_datas addObjectsFromArray:[VoiceCommentListModel arrayObjectWithDS:state.data]];
                }

                
                [subscriber sendNext:state];
                [subscriber sendCompleted];
                
            }];
        }];
    }
    return _getCommentListCommand;
}

- (NSArray *)datas{
    
    return [p_datas copy];
}
@end
