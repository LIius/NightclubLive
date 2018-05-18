//
//  PaiPaiViewModel.m
//  NightclubLive
//
//  Created by WanBo on 17/2/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "PaiPaiViewModel.h"
#import "LiveRequest.h"
#import "PaiPaiModel.h"
#import "QiniuTool.h"
#import "ConvertTool.h"

@interface PaiPaiViewModel (){
    
    NSMutableArray *p_datas;
}

@property (nonatomic, copy, readwrite) NSArray *datas;
@property (nonatomic, strong, readwrite) RACCommand *getPaipaiListCommand;

@end

@implementation PaiPaiViewModel

- (instancetype)init{
    
    if (self = [super init]){
        
        p_datas = [NSMutableArray array];
    }
    return self;
}

- (void)initialize {
    
    [super initialize];

    
//    @weakify(self)
//    self.getPaipaiListCommand = [[RACCommand alloc] initWithSignalBlock:^(NSNumber *page) {
//        @strongify(self)
//        return [[self requestRemoteDataSignalWithPage:page.unsignedIntegerValue] takeUntil:self.rac_willDeallocSignal];
//    }];
//    
//    DataBaseManager *manager = [DataBaseManager defaultManager];
//    LoginModel *loginModel = [manager queryAllLoginModels].firstObject;
//    
//    RAC(self, datas) = [[self.getPaipaiListCommand.executionSignals.switchToLatest
//                         startWith:self.fetchLocalData]
//                        map:^(NSArray *datas) {
//                                return datas;
//                        }];
//    
//    [self.getPaipaiListCommand.errors subscribe:self.errors];
}
//
//- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
//    
//    RACSignal *fetchSignal = [RACSignal empty];
//    
//    fetchSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        PaiPaiGetListRequest *request = [PaiPaiGetListRequest new];
//        
//        [request startWithCompletedBlock:^(GJBaseRequest *request) {
//            
//            PaiPaiSuperModel *model = [PaiPaiSuperModel mj_objectWithKeyValues:request.responseJson];
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
//    return [fetchSignal map:^id(PaiPaiSuperModel *x) {
//        return x.result;
//    }];
//}
//
//- (id)fetchLocalData {
//    
//    return @[];
//    
//}

- (RACCommand *)getPaipaiListCommand{
    
    if (!_getPaipaiListCommand){
        
        _getPaipaiListCommand = [RACCommand createCommandWithDoBlock:^(id<RACSubscriber> subscriber) {
            
            if (self.tag == 0){
                PaiPaiGetListRequest *request = [PaiPaiGetListRequest new];
                request.param = @{@"pageNow":@(self.pageNow),@"userId":[UserInfo shareUser].userID};
                [request startWithCompletedBlock:^(GJBaseRequest *request) {
                    
                    ResponseState *state = [ResponseState objectWithDic:request.responseObject];
                    
                    if (state.isSuccess){
                        
                        if (self.refreshType == RefreshTypeLoad){
                            [p_datas removeAllObjects];
                        }
                        
                        [p_datas addObjectsFromArray:[PaiPaiModel arrayObjectWithDS:state.datas]];
                    }
                    
                    
                    [subscriber sendNext:state];
                    [subscriber sendCompleted];
                }];

            }
            else{
                PaiPaiUserListRequest *r = [PaiPaiUserListRequest new];
                r.param = @{@"pageNow":@(self.pageNow),@"userId":self.userid};
                [r startWithCompletedBlock:^(GJBaseRequest *request) {
                    
                    ResponseState *state = [ResponseState objectWithDic:request.responseObject];
                    
                    if (state.isSuccess){
                        
                        if (self.refreshType == RefreshTypeLoad){
                            [p_datas removeAllObjects];
                        }
                        
                        [p_datas addObjectsFromArray:[PaiPaiModel arrayObjectWithDS:state.datas]];
                    }
                    
                    
                    [subscriber sendNext:state];
                    [subscriber sendCompleted];

                }];
            }
            
        }];
    }
    return _getPaipaiListCommand;
}

- (RACCommand *)uploadVideCommand{
    
    
    if (!_uploadVideCommand){
        
        _uploadVideCommand = [RACCommand createCommandWithDoBlock:^(id<RACSubscriber> subscriber) {
            
            QiniuTool *tool = [QiniuTool shareTool];
            
            [tool uploadVideo:self.videURL type:UploadTypeSpaceTypePaipai success:^(NSString *url) {
                
                DLog(@"%@",url);
                
                [subscriber sendNext:url];
                [subscriber sendCompleted];
                
            } failure:^(NSError *error) {
            }];
        }];
    }
    return _uploadVideCommand;
}

- (NSArray *)datas{
    
    return [p_datas copy];
}

@end
