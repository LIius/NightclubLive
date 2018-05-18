//
//  ObjectView.h
//  NightclubLive
//
//  Created by RDP on 2017/4/13.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObjectView : UIView
@property (nonatomic, weak) id model;
+ (instancetype)initFromXIB;
@end
