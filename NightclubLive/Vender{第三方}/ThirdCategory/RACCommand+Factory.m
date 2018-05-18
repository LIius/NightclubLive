//
//  RACCommand+Factory.m
//  NightclubLive
//
//  Created by RDP on 2017/3/3.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "RACCommand+Factory.h"

@implementation RACCommand (Factory)


+ (instancetype)createCommandWithDoBlock:(signalDoBlock)doBlocK{
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            if (doBlocK)
                doBlocK(subscriber);
            
            return nil;
        }];
        
        return signal;
    }];
    
    return command;
}
@end
