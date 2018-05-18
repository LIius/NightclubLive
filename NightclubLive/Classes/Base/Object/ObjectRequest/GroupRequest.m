//
//  GroupRequest.m
//  NightclubLive
//
//  Created by RDP on 2017/3/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GroupRequest.h"
#import "ObjectRequest.h"

@interface GroupRequest()
@property (nonatomic, strong,readwrite) NSMutableArray *prequests;
@end

@implementation GroupRequest

- (void)addRequests:(ObjectRequest *)request{
    
    [self.prequests addObject:request];
}

- (void)startRequestWithFinishBlock:(GroupReuqestFinishBloclk)finishBlock{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
        dispatch_group_t group = dispatch_group_create();
        
        for (ObjectRequest *r in self.prequests){
            
            dispatch_group_enter(group);
            
            [r startRequestWithCompleted:^(ResponseState *state) {
                
                dispatch_group_leave(group);
            }];
        }
        
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        dispatch_group_notify(group, queue, ^{
            
            if (finishBlock)
                finishBlock(self.requests);
        });
        
    });
}

- (NSMutableArray *)prequests{
    
    if (!_prequests){
        _prequests = [NSMutableArray array];
    }
    return _prequests;
}

- (NSArray *)requests{
    
    return [self.prequests copy];
}
@end
