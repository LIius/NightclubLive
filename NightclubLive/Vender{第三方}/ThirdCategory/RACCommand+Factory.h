//
//  RACCommand+Factory.h
//  NightclubLive
//
//  Created by RDP on 2017/3/3.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

typedef void (^signalDoBlock)(id<RACSubscriber> subscriber);

@interface RACCommand (Factory)

/**
 *  快速创建command
 *
 *  @param doBlocK 执行内容
 *
 *  @return 对象
 */
+ (instancetype)createCommandWithDoBlock:(signalDoBlock)doBlocK;

@end
