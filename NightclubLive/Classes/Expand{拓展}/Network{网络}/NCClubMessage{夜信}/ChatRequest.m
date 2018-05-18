//
//  ChatRequest.m
//  NightclubLive
//
//  Created by RDP on 2017/4/11.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ChatRequest.h"

@implementation FindUserRequest

- (NSString *)path{
    return @"user/findUser.do";
}

- (NSDictionary *)parameters{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (_searchValue.length >= 1)
        [param setObject:_searchValue forKey:@"value"];
    
    
    if ([_professionValue isEqualToString:@"男神"] || [_professionValue isEqualToString:@"女神"]){
        
        [param setValue:_professionValue forKey:@"sex"];
    }
    else{
        [param setValue:_professionValue forKey:@"profession"];
    }
    
    if (_pageNow >= 1){
        [param setValue:@(_pageNow) forKey:@"pageNow"];
    }
    
    if ([_professionValue isEqualToString:@"推荐"]){
        [param setValue:@"recommend" forKey:@"recommend"];
        [param removeObjectForKey:@"profession"];
    }
    
    return [param copy];
}

@end
