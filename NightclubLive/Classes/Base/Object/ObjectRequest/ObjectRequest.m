
//
//  ObjectRequest.m
//  NightclubLive
//
//  Created by RDP on 2017/3/8.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectRequest.h"

@implementation ObjectRequest


- (GJRequestMethod)method
{
    return GJRequestPOST;
}

- (NSDictionary *)httpHeader
{
    if (CurrentUser.token)
    {
        return @{@"token":CurrentUser.token};
    }
    
    return nil;
}

- (NSDictionary *)parameters
{
    return self.param;
}

- (void)startRequestWithCompleted:(CompletedBlock)completeBlock
{
    [self startWithCompletedBlock:^(GJBaseRequest *request)
     {
        NSLog(@"[request.header=%@]\n[request.path=%@]\n[request.parameters=%@]\n[request.responseObject=%@]",request.httpHeader,request.path,request.parameters,request.responseObject);
         
        ResponseState *state = [ResponseState objectWithDic:request.responseObject];
        
        self.responseState = state;
        
        // 判断code == 6 需要重新登录
        if (state.responseCode == 6){
        
            ShowError(state.message);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UserInfo needLogin];
            });
        }
        
        _responseData = request.responseObject;
        if (completeBlock)
            completeBlock(state);
        
    }];
}

+ (void)startRequestWithCompleted:(CompletedBlock)completeBlock
{
    ObjectRequest *r = [[[self class] alloc] init];
    
    [r startRequestWithCompleted:completeBlock];
}



@end
