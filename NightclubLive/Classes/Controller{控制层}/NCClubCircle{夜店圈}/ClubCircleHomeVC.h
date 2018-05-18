//
//  ClubCircleHomeVC.h
//  NightclubLive
//
//  Created by WanBo on 16/12/2.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPageController.h"

typedef NS_ENUM(NSUInteger, WMMenuViewPosition) {
    WMMenuViewPositionDefault,
    WMMenuViewPositionBottom,
};

@interface ClubCircleHomeVC :WMPageController
@property (nonatomic, assign) WMMenuViewPosition menuViewPosition;
@end
