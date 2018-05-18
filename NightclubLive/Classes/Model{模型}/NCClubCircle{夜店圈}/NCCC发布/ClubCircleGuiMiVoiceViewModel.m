//
//  ClubCircleGuiMiVoiceViewModel.m
//  NightclubLive
//
//  Created by WanBo on 17/1/5.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ClubCircleGuiMiVoiceViewModel.h"
#import "ClubCircleRequest.h"
#import "DynamicListModel.h"
#import "AFNetworking.h"
#import "QiniuSDK.h"
#import "GPraiseRequest.h"

@interface ClubCircleGuiMiVoiceViewModel (){
    
    NSMutableArray *p_datas;
}
//@property (nonatomic, readwrite) NSArray *datas;
@property (nonatomic, strong, readwrite) RACCommand *voiceCommintCommand;
@property (nonatomic, strong, readwrite) RACCommand *likeReuqesCommand;

@end

@implementation ClubCircleGuiMiVoiceViewModel

- (instancetype)init{
    
    self = [super init];
    
    if (!self)
        return nil;
    
    
    return self;
}


- (void)initialize{
    
    [super initialize];
    
    p_datas = [NSMutableArray array];
}

//
//- (void)initialize {
//    
//    [super initialize];
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
//    DataBaseManager *manager = [DataBaseManager defaultManager];
//    LoginModel *loginModel = [manager queryAllLoginModels].firstObject;
//    
//    _voiceCommintCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        
//        RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//            if (!loginModel) {
//                [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:360 userInfo:nil]];
//            }
//            if ([input boolValue]) {
//                //************************************************************************
//                AddHeartSoundRequest *request = [AddHeartSoundRequest new];
//
//                request.param = @{@"userId":loginModel.token?loginModel.token:@"",@"content":_content.length>0?_content:@"",@"anonymous":_isNiming,@"type":_model.ID,@"provice":@"广东省",@"city":@"中山市",@"district":@"xx区",@"address":@"xxx",@"latitude":@"22.80",@"longitude":@"113.40",@"messageType":@1};
//                //************************************************************************
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
//                }];//
//                
//            }else{
//                //************************************************************************
//                GetQNAuthTokenRequest *request = [GetQNAuthTokenRequest new];
//                [request startWithCompletedBlock:^(GJBaseRequest *request) {
//                    if (!request.error) {
//                        NSString * token = request.responseJson[@"result"];
//                        QNUploadManager *upManager = [[QNUploadManager alloc] init];
//                        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:nil params:nil checkCrc:NO cancellationSignal:nil];
//                        
//                        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//                        NSTimeInterval fix=[dat timeIntervalSince1970]*1000;
//                        
//                        [upManager putFile:_file key:[NSString stringWithFormat:@"%ldvoice.caf",(long)fix] token:token complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp)   {
//                            
//                            if(resp){
//                                //
//                                AddHeartSoundRequest *request = [AddHeartSoundRequest new];
//                                request.param = @{@"userId":loginModel.token?loginModel.token:@"",@"content":@"",@"anonymous":_isNiming,@"voicelen":[NSString stringWithFormat:@"%@%@",URL_QINIU,key],@"type":_model.ID,@"provice":@"广东省",@"city":@"中山市",@"district":@"xx区",@"address":@"xxx",@"latitude":@"22.80",@"longitude":@"113.40",@"duration":@(_duration*1000),@"messageType":@2};
//                                
//                                [request startWithCompletedBlock:^(GJBaseRequest *request) {
//                                    if (!request.error) {
//                                        NSLog(@"%@",request.responseJson);
//                                        
//                                        [subscriber sendNext:request.responseJson];
//                                        [subscriber sendCompleted];
//                                        
//                                    }else{
//                                        if (SharedAppDelegate.networkStatus==NotReachable){
//                                            [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:278 userInfo:nil]];
//                                        }else{
//                                            [subscriber sendError:request.error];
//                                        }
//                                        [subscriber sendCompleted];
//                                    }
//                                }];//
//                            }
//                            
//                        } option:opt];
//                    }
//                }];
//                //************************************************************************
//
//            }
//
//            return nil;
//        }];
//        
//        return [requestSignal map:^id(NSDictionary *dict) {
//            NSNumber *isSuccess = @([dict[@"state"] isEqualToString:@"true"]);
//            
//            return isSuccess;
//        }];
//        
//    }];
//    
//    [self.voiceCommintCommand.errors subscribe:self.errors];
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
//                request.param = @{@"typeId":@1,@"subjectId":_model.ID,@"userId":loginModel.token?loginModel.token:@"",@"subjectTypeId":@2,@"likes":@1};
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
//            NSNumber *isSuccess = @([dict[@"state"] isEqualToString:@"true"]);
//            
//            return isSuccess;
//        }];
//    }];
//    [self.likeReuqesCommand.errors subscribe:self.errors];
//}
//
//- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
//    
//    RACSignal *fetchSignal = [RACSignal empty];
//    
//    fetchSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        HeartsoundRequest *request = [HeartsoundRequest new];
//        //typeId   1.动态 2.心声
//        //subjectId   动态或者心声的ID
//        request.param = @{@"typeId":@2,@"subjectId":_model.ID};
//        [request startWithCompletedBlock:^(GJBaseRequest *request) {
//            
//            HeartsoundListSuperModel *model = [HeartsoundListSuperModel mj_objectWithKeyValues:request.responseJson];
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
//    return [fetchSignal map:^id(HeartsoundListSuperModel *model) {
//        return model.result;
//    }];
//}
//
//- (id)fetchLocalData {
//
//    return @[];
//    
//}

#pragma mark - Getter

- (RACCommand *)getListCommand{
    
    if (!_getListCommand){
        
        _getListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                UserInfo *userInfo = [UserInfo shareUser];
                HeartsoundRequest *request = [HeartsoundRequest new];
                request.param = @{@"pageNow":@(self.pageNow),@"type":self.model.ID,@"latitude":userInfo.location.lclatitude,@"longitude":userInfo.location.lclongitude,@"userId":userInfo.userID};
                
                [request startWithCompletedBlock:^(GJBaseRequest *request) {
                    
                    ResponseState *state = [[ResponseState alloc] initWithDic:request.responseObject];
                    
                    NSLog(@"%@",state);
                    
                    
                    if (state.isSuccess){
                        
                        if (self.refreshType == RefreshTypeLoad)
                            [p_datas removeAllObjects];
                        
                        [p_datas addObjectsFromArray:[HeartsoundListModel arrayObjectWithDS:state.datas]];
                    }
                    
                    [subscriber sendNext:state];
                    [subscriber sendCompleted];
                    

                }];
                
                return nil;
            }];
            return signal;
            
        }];
    }
    return _getListCommand;
}

- (RACCommand *)voiceCommintCommand{
    
    if (!_voiceCommintCommand){
        
        _voiceCommintCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                AddHeartSoundRequest *request = [AddHeartSoundRequest new];
                
                NSMutableDictionary *param = [NSMutableDictionary dictionary];
                
                UserInfo *user = [UserInfo shareUser];
                [param setValue:user.userID forKey:@"userId"];
                [param setValue:self.model.ID forKey:@"type"];
                [param setValue:@(self.messageType) forKey:@"messageType"];
                [param setValue:@(self.isAnonymous) forKey:@"anonymous"];
                [param setValue:user.location.lcprovince forKey:@"provice"];
                [param setValue:user.location.lccity forKey:@"city"];
                [param setValue:user.location.lcaddress forKey:@"address"];
                [param setValue:user.location.lclatitude forKey:@"latitude"];
                [param setValue:user.location.lclongitude forKey:@"longitude"];
             //   [param setValue:@(2) forKey:@"Reply_type"];
                [param setValue:user.location.district forKey:@"district"];
                if (self.messageType == 1){//文本
                    [param setValue:self.content forKey:@"content"];
                }
                else{//语音
                    [param setValue:@((NSInteger)(self.duration * 1000)) forKey:@"duration"];
                    [param setValue:self.voicelen forKey:@"voicelen"];
                }
                request.param = param;
                [request startWithCompletedBlock:^(GJBaseRequest *request) {
                    
                    ResponseState *state = [ResponseState objectWithDic:request.responseObject];
                    
                    [subscriber sendNext:state];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return signal;
        }];
    }
    return _voiceCommintCommand;
}

//- (RACCommand *)unlikeRequestCommand{
//    
//    if (!_unlikeRequestCommand){
//        
//        _unlikeRequestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//            
//            RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//                
//                return nil;
//            }];
//            
//            return signal;
//        }];
//    }
//    return _unlikeRequestCommand;
//}

- (RACCommand *)likeReuqesCommand{
    
    if (!_likeReuqesCommand){
        
        _likeReuqesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            
            RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                PraiseRequest *request = [PraiseRequest new];
                //typeId  点赞的类型（1、主题；2、评论）
                
//                DynamicListModelFrame *frame = p_datas[self.indexPath.row];
//                DynamicListModel *model = frame.model;
                
                HeartsoundListModel *model  = p_datas[self.indexPath.row];
                
                request.param = @{@"userId":[UserInfo shareUser].userID,@"subjectTypeId":@(2),@"subjectId":model.ID,@"typeId":@(1)};
                
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
    
    if (!_unlikeRequestCommand){
        
        _unlikeRequestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            
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
    return _unlikeRequestCommand;
}

- (RACCommand *)praiseCommand{
    
    if (!_praiseCommand){
        _praiseCommand = [RACCommand createCommandWithDoBlock:^(id<RACSubscriber> subscriber) {
            
            HeartsoundListModel *model = p_datas[self.indexPath.row];
            
            GPraiseRequest *r = [GPraiseRequest new];
            r.subjectTypeId = 2;
            r.subjectId  = model.ID;
            r.type = 1;
            r.praiseType = model.ispraise == 0 ? PriaseAdd : PriaseCancel;
            
            [r startWithCompletedBlock:^(GJBaseRequest *request) {
                
                ResponseState *state = [ResponseState objectWithDic:request.responseObject];
                
                if (state.isSuccess){
                    HeartsoundListModel *model = p_datas[self.indexPath.row];
                    
                    if (model.ispraise == 1){
                        model.ispraise = 0;
                        model.praise -= 1;
                    }
                    else{
                        model.ispraise = 1;
                        model.praise += 1;
                    }
                    
                }
                
                [subscriber sendNext:state];
                [subscriber sendCompleted];
            }];
            
        }];
    }
    return _praiseCommand;
}

- (NSArray *)datas{
    
    return [p_datas copy];
}
@end
