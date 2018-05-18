//
//  ResponseState.m
//  NightclubLive
//
//  Created by RDP on 2017/3/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ResponseState.h"

@implementation ResponseState

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"version":@"v",
             @"msg":@"msg",
             @"datas":@"result",
             @"code":@"code",
             @"data":@"data",
             @"optional":@"data",
             @"responseCode":@"code"};
    
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    
    return @{@"datas":[NSDictionary class],@"data":[NSDictionary class]};
}


- (void)setCode:(NSInteger)code{
    
    if (code == 0)
        _isSuccess = YES;
    else
        _isSuccess = NO;
}

- (void)setMessage:(NSString *)message{
    
    _message = message;
    
    if (!_msg)
        _msg = message;
}

- (void)setMsg:(NSString *)msg{
    
    _msg = msg;
    
    if (!_message)
        _message = msg;
}

- (void)setState:(NSString *)state{
    
    _isSuccess = [state isEqualToString:@"true"];
}

@end
