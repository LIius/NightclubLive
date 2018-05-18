//
//  GiftWheelModel.h
//  NightclubLive
//
//  Created by RDP on 2017/3/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ModelObject.h"

@interface GiftWheelModel : ModelObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *prize;
@property (nonatomic, assign) NSInteger probability;
@property (nonatomic, assign) NSInteger angle;
@end
