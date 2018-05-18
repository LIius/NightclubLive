//
//  WheelTool.h
//  NightclubLive
//
//  转盘控制类
//  Created by RDP on 2017/3/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiftWheelModel.h"

@interface WheelTool : NSObject
/** 结果 */
@property (nonatomic, strong) GiftWheelModel *wheelResultModel;
/** 结果回调 */
@property (nonatomic, copy) CalkBackBlock wheelResultBlock;
@property (nonatomic, copy) CalkBackBlock end;
@property (nonatomic, copy) NSString *receiverID;
@property (nonatomic, copy) NSString *subjectID;
/**
 *  出现
 */
- (void)appear;
/**
 *  消失
 */
- (void)disappear;

/**
 *  停止动画限定角度
 */
- (void)endAniatiomWithAngle:(NSInteger)angle;
@end
