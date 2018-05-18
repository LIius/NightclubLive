//
//  ReleaseDynamicViewModel.m
//  NightclubLive
//
//  Created by WanBo on 17/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ReleaseDynamicViewModel.h"
#import "AFNetworking.h"
#import "QiNiuUploadHelper.h"
#import "QiNiuSystemService.h"
#import "ClubCircleRequest.h"
#import "QiniuTool.h"

@interface ReleaseDynamicViewModel()

@property (nonatomic, strong, readwrite) RACCommand *commintReuqesCommand;

@end

@implementation ReleaseDynamicViewModel


- (void)initialize {
    
    [super initialize];
    
    @weakify(self);
    _commintReuqesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self);
            //没有选择图片的时候
            if (_imageArr.count==0) {
                ReleaseDynamicRequest *request = [ReleaseDynamicRequest new];
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                if (_isAddressOn){
                    [params setValue:self.province forKey:@"province"];
                    [params setValue:self.city forKey:@"city"];
                    [params setValue:self.districe forKey:@"district"];
                    [params setValue:self.address forKey:@"address"];
                    [params setValue:self.latitude forKey:@"latitude"];
                    [params setValue:self.longitude forKey:@"longitude"];
                }
                [params setValue:self.content forKey:@"content"];
                [params setValue:[UserInfo shareUser].userID forKey:@"userld"];
                
                request.param = [params copy];
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
                
            
        }else{
            
            //有提交图片
            QiniuTool *tool = [QiniuTool shareTool];
            [tool uploadImages:_imageArr type:UploadTypeSpaceTypeDynamic success:^(NSArray *urls) {
                
                NSLog(@"%@",urls);

                ReleaseDynamicRequest *request = [ReleaseDynamicRequest new];
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                if (_isAddressOn){
                    [params setValue:self.province forKey:@"province"];
                    [params setValue:self.city forKey:@"city"];
                    [params setValue:self.districe forKey:@"district"];
                    [params setValue:self.address forKey:@"address"];
                    [params setValue:self.latitude forKey:@"latitude"];
                    [params setValue:self.longitude forKey:@"longitude"];
                }
                [params setValue:self.content forKey:@"content"];
                [params setValue:[UserInfo shareUser].userID forKey:@"userId"];
                [params setValue:urls forKey:@"images"];
                
                request.param = [params copy];
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
                
            } failure:^(NSError *error) {
            }];
//            
//            [QiNiuSystemService uploadImages:_imageArr progress:^(CGFloat xx) {
//                
//            } success:^(NSArray *urls) {
//                
//                ReleaseDynamicRequest *request = [ReleaseDynamicRequest new];
//                NSMutableString *aurs = [NSMutableString string];
//                
//                for (int i = 0;i<urls.count;i++) {
//                    if (i==0) {
//                        [aurs appendString:@"["];
//                    }
//                    [aurs appendString:[NSString stringWithFormat:@"\"%@\"",urls[i]]];
//                    if (i!=urls.count-1) {
//                        [aurs appendString:@","];
//                        
//                    }else{
//                        [aurs appendString:@"]"];
//                    }
//                }
//                
//                NSLog(@"%@",aurs);
//                if (_isAddressOn){
////                request.param = @{@"userId":loginModel.token?loginModel.token:@"",@"content":_content.length>0?_content:@"",@"images":aurs,@"provice":@"广东省",@"city":@"中山市",@"district":@"xx区",@"address":@"xxx",@"latitude":@"22.80",@"longitude":@"113.40",};
////                }else{
////                request.param = @{@"userId":loginModel.token?loginModel.token:@"",@"content":_content.length>0?_content:@"",@"images":aurs};
//                    
//                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//                    if (_isAddressOn){
//                        [params setValue:self.province forKey:@"province"];
//                        [params setValue:self.city forKey:@"city"];
//                        [params setValue:self.districe forKey:@"district"];
//                        [params setValue:self.address forKey:@"address"];
//                        [params setValue:self.latitude forKey:@"latitude"];
//                        [params setValue:self.longitude forKey:@"longitude"];
//                    }
//                    [params setValue:self.content forKey:@"content"];
//                    [params setValue:aurs forKey:@"images"];
//                    [params setValue:[UserInfo shareUser].userID forKey:@"userld"];
//
//                }
//                
//
//                
//                NSLog(@"---%@",request.param);
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
//            
//            } failure:^{
//                [subscriber sendError:[NSError errorWithDomain:netWorkErrorDomain code:278 userInfo:nil]];
//
//            }];
//            
        }
            
            return nil;

///
              }];
        
        return [signal map:^id(NSDictionary *dict) {
            NSNumber *isSuccess = @([dict[@"state"] isEqualToString:@"true"]);
   
            return isSuccess;
        }];
    }];
    [self.commintReuqesCommand.errors subscribe:self.errors];

    
}

@end
