//
//  AppointmentViewController.h
//  NightclubLive
//
//  Created by RDP on 2017/5/27.
//  Copyright © 2017年 WanBo. All rights reserved.
//  约台

#import "ObjectTableViewController.h"
@class BarModel;

@interface AppointmentViewController : ObjectTableViewController

/** 约台的酒吧 */
@property (nonatomic, strong) BarModel *bar;
/** 绑定的酒吧 的iD*/
@property (nonatomic, copy) NSString *bindBarID;

@end
