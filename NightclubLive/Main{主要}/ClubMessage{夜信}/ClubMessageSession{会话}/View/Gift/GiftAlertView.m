//
//  GiftAlertView.m
//  NightclubLive
//
//  Created by RDP on 2017/3/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GiftAlertView.h"

@implementation GiftAlertView

+ (instancetype)viewWithType:(NSInteger)type withMessage:(NSString *)message{
    
    GiftAlertView *view  = [[[NSBundle mainBundle] loadNibNamed:@"GiftAlertView" owner:nil options:nil] firstObject];
    
    view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    
    view.frame = KEYWINDOW.bounds;
    
    view.backIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"tishi%ld",type]];
    
    view.contentLabel.text = message;

    return view;

}

- (IBAction)okClick:(id)sender {
    
    [self removeView];
}

- (IBAction)cancelClick:(id)sender {
    
    [self removeView];
}

- (void)removeView{
    
    [UIView animateWithDuration:0.8 animations:^{
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(self).multipliedBy(0.1);
            
        }];
        
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}

- (void)show{
    
    //_contentView.hidden = NO;
    
    [self layoutIfNeeded];

    [UIView animateWithDuration:0.8 animations:^{
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(self).multipliedBy(0.8);
            
        }];
        
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
      //  [self removeFromSuperview];
    }];

}
@end
