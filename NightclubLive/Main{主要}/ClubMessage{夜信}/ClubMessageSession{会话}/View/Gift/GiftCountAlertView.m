//
//  GiftAlertView.m
//  GiftAlertController
//
//  Created by RDP on 2017/3/24.
//  Copyright © 2017年 RDP. All rights reserved.
//

#import "GiftCountAlertView.h"

@implementation GiftCountAlertView

+ (instancetype)giftAlert{
    
    GiftCountAlertView  *giftAlert = [[[NSBundle mainBundle] loadNibNamed:@"GiftCountAlertView" owner:nil options:nil] firstObject];

    giftAlert.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1];
    
    giftAlert.center = KEYWINDOW.center;
    
    return giftAlert;
}

- (void)close{
    [self removeFromSuperview];
}

- (IBAction)close:(id)sender {
    [self close];
}

- (IBAction)cancelClick:(id)sender {
    [self close];
}

- (IBAction)okClick:(id)sender {
    [self close];
}

@end
