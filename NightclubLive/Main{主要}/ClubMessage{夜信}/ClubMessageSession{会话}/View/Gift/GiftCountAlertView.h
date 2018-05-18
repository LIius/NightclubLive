//
//  GiftAlertView.h
//  GiftAlertController
//
//  Created by RDP on 2017/3/24.
//  Copyright © 2017年 RDP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftCountAlertView : UIView

@property (weak, nonatomic) IBOutlet UITextField *countTF;

@property (weak, nonatomic) IBOutlet UIView *contentView;

+ (instancetype)giftAlert;

//- (void)show;
@end
