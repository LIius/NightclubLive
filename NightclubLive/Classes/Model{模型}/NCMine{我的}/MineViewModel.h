//
//  MineViewModel.h
//  NightclubLive
//
//  Created by RDP on 2017/2/27.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MRCViewModel.h"

@interface MineViewModel : MRCViewModel
/** 定位名 */
@property (nonatomic, copy) NSString  *location;
/** 纬度 */
@property (nonatomic, assign) CGFloat latitude;
/** 经度 */
@property (nonatomic, assign) CGFloat longitude;
/** 定完位置signal */
@property (nonatomic, strong) RACSignal *locationFinishSignal;
/** 定位执行 */
@property (nonatomic, strong) RACCommand *locationCommand;
@end
