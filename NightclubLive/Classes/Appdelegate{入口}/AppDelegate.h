//
//  AppDelegate.h
//  NightclubLive
//
//  Created by WanBo on 16/11/26.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, assign, readonly) NetworkStatus networkStatus;

@property (strong, nonatomic) UIWindow *window;

@end

