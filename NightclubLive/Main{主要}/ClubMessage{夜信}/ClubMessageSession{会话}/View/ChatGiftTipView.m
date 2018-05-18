//
//  ChatGiftTipView.m
//  NightclubLive
//
//  Created by RDP on 2017/3/22.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ChatGiftTipView.h"

@implementation ChatGiftTipView

+ (instancetype)tipView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"ChatGiftTipView" owner:nil options:nil] firstObject];
}

#pragma mark - Button Click

- (IBAction)closeClick:(id)sender {
    
    [self removeFromSuperview];
}

@end
