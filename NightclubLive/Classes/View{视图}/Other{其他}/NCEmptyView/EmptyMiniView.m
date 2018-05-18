//
//  EmptyMiniView.m
//  NightclubLive
//
//  Created by RDP on 2017/6/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "EmptyMiniView.h"

@implementation EmptyMiniView

+ (EmptyMiniView *)viewWithTip:(NSString *)tip{
    
    EmptyMiniView *v = [EmptyMiniView initFromXIB];
    v.frame = CGRectMake(-SCREEN_WIDTH * 0.25, 0, SCREEN_WIDTH, 50);
    v.tipLabel.text = tip;
    return v;
}

@end
