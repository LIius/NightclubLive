//
//  GetQiniuTokenRequest.m
//  NightclubLive
//
//  Created by RDP on 2017/3/1.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GetQiniuTokenRequest.h"

@implementation GetQiniuTokenRequest

- (NSString *)path{
    
    return @"upload/getToken.do";
}

- (NSDictionary *)parameters{
    
    return self.param;
}

- (GJAPICachePolicy)cachePolicy{
   
    return GJNotAPICachePolicy;
}
@end
