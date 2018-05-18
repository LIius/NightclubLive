//
//  GiftAlertView.h
//  NightclubLive
//
//  Created by RDP on 2017/3/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiftAlertView : UIView
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *backIV;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/** 0-提示 1-结果 */
@property (nonatomic, assign) NSInteger alertType;

@property (weak, nonatomic) IBOutlet UIButton *okBtn;

+ (instancetype)viewWithType:(NSInteger)type withMessage:(NSString *)message;

- (void)show;
@end


