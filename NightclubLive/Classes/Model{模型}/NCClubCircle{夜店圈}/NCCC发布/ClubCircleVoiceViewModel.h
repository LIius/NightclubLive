//
//  ClubCircleVoiceViewModel.h
//  NightclubLive
//
//  Created by WanBo on 17/1/3.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MRCTableViewModel.h"

@interface ClubCircleVoiceViewModel : MRCTableViewModel

@property (nonatomic, copy, readonly) NSArray *datas;

@property (nonatomic, strong) RACCommand *getListcommand;
@end
