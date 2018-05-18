//
//  PaiPaiListRequest.m
//  NightclubLive
//
//  Created by RDP on 2017/5/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "PaiPaiListRequest.h"

@implementation PaiPaiListRequest

@end


@implementation DeleteRequest

- (NSString *)path{
    return @"paipai/deletePaipai.do";
}

- (NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.model) {
        [params setValue:self.model forKey:@"id"];
    }
    
    return params.mutableCopy;
    
    //return @{@"id":self.model};
}
@end
