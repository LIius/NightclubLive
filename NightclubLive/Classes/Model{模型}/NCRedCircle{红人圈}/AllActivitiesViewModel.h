//
//  AllActivitiesViewModel.h
//  NightclubLive
//
//  Created by WanBo on 17/1/16.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MRCTableViewModel.h"

@interface AllActivitiesViewModel : MRCTableViewModel

@property (nonatomic, strong)NSArray *arr;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *datas;
/** 获取竞选列表command */
@property (nonatomic, strong,readonly) RACCommand *runforCommand;
@end
