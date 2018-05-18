//
//  EmptyBigView.m
//  NightclubLive
//
//  Created by RDP on 2017/6/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "EmptyBigView.h"

@implementation EmptyBigView


+ (EmptyBigView *)viewWithTip:(NSString *)tip{
    
    EmptyBigView *view = [EmptyBigView initFromXIB];
    view.tipLabel.text = tip;
    return view;
}
@end
