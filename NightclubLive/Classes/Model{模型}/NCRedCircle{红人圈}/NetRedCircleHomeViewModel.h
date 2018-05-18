//
//  NetRedCircleHomeViewModel.h
//  NightclubLive
//
//  Created by WanBo on 17/1/14.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MRCTableViewModel.h"

@interface NetRedCircleHomeViewModel : MRCTableViewModel

@property (nonatomic, strong, readonly) RACCommand *dataReuqesCommand;

@end
