//
//  DDJoinView.m
//  NightclubLive
//
//  Created by SuperDanny on 2016/12/20.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "DDJoinView.h"

@interface DDJoinView ()

@property (strong, nonatomic) UIButton *bgView;

@end

@implementation DDJoinView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"DDJoinView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 195);
    }
    return self;
}

- (IBAction)add:(id)sender {
}

- (IBAction)reduce:(id)sender {
}

- (void)show {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _bgView = [[UIButton alloc] init];
    _bgView.backgroundColor = UIColorHex(0x000000);
    _bgView.alpha = 0.25;
    _bgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [_bgView addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:_bgView];
    
    [window addSubview:self];
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        (void)make.left;
        (void)make.centerX;
        make.height.offset(195);
        make.bottom.offset(0);
    }];

    [UIView animateWithDuration:0.3f animations:^{
        [window layoutIfNeeded];
    }];
}

#pragma mark - 關閉
- (void)close:(id)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        (void)make.left;
        (void)make.centerX;
        make.height.offset(195);
        make.bottom.offset(195);
    }];
    
    [UIView animateWithDuration:0.3f animations:^{
        [window layoutIfNeeded];
    } completion:^(BOOL finished) {
        for (UIView *v in [self subviews]) {
            [v removeFromSuperview];
        }
        [self removeFromSuperview];
        [_bgView removeFromSuperview];
    }];
}

@end
