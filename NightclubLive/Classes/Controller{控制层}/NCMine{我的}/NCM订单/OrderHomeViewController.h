//
//  OrderHomeViewController.h
//  NightclubLive
//
//  Created by RDP on 2017/4/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPageController.h"

typedef NS_ENUM(NSUInteger, WMMenuViewPosition) {
    WMMenuViewPositionDefault,
    WMMenuViewPositionBottom,
};

@interface OrderHomeViewController : WMPageController

@property (nonatomic, assign) WMMenuViewPosition menuViewPosition;

@end
