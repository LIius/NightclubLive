//
//  WBAlertView.m
//  NightclubLive
//
//  Created by RDP on 2017/4/10.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "WBAlertView.h"

static CGFloat ContentBackViewHeight = 135;
static CGFloat ContentBackViewWidth  = 250;

@interface WBAlertView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) UIView *customView;
@end

@implementation WBAlertView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    //添加键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardChange:(NSNotification *)notification{
    
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;

    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
      //  _backView.frame = CGRectMake((SCREEN_WIDTH - _backView.width) * 0.5, SCREEN_HEIGHT-height - 66, _backView.width,_backView.height);
        
    //    _backView.y = SCREEN_HEIGHT-height - 66;
      //  [self layoutIfNeeded];
      //  [self.superview layoutIfNeeded];
    }];

}

+ (instancetype)alertTitle:(NSString *)title contentView:(UIView *)contentView{
    
    WBAlertView *alertView = [[[NSBundle mainBundle] loadNibNamed:@"WBAlertView" owner:nil options:nil] firstObject];
    
    alertView.title = title;
    alertView.customView = contentView;
    // alertView.contentView = contentView;
    [alertView initView];
    
    return alertView;
    
}


#pragma mark - Private

- (void)initView{
    self.backView.width = ContentBackViewWidth * 0.1;
    self.backView.height = ContentBackViewHeight * 0.1;
    self.center = self.center;
    
//    _customView.frame = CGRectMake(0, 0, _contentView.width * 0.8, _contentView.height);
    [_contentView addSubview:_customView];
    
    [_customView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(_contentView).multipliedBy(0.8);
        make.height.equalTo(_contentView).multipliedBy(1);
        make.centerX.equalTo(_contentView.mas_centerX);
        make.centerY.equalTo(_contentView.mas_centerY);
    }];
}

- (void)removeSelf{
    
    [self removeFromSuperview];
}

#pragma mark - Public Method

- (void)showView:(UIView *)view{
    
    if (!view){
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        view = window;
    }
    
    self.bounds = view.bounds;
    self.x = 0;
    self.y = 0;
    
    [view addSubview:self];
    
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear          animations:^{
        
        /*CGRect frame = self.backView.frame;
         frame.size.width = ContentBackViewWidth;
         frame.size.height = ContentBackViewHeight;
         
         self.backView.frame = frame;*/
        
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(ContentBackViewWidth);
            make.height.mas_equalTo(ContentBackViewHeight);
        }];
        
    } completion:^(BOOL finished) {
    }];

}

- (void)close{
}

#pragma mark - Setter

- (void)setTitle:(NSString *)title{
    
    _title = title;
    
 //   [_title setTitle:title forState:UIControlStateNormal];
    
    _titleLabel.text = title;
}

- (void)setOkTitle:(NSString *)okTitle{
    
    _okTitle = okTitle;
    
    [_okBtn setTitle:okTitle forState:UIControlStateNormal];
}

#pragma mark - Getter

- (UIView *)content{
    
    return self.contentView;
}

#pragma mark - Button Click

- (IBAction)cancelClick:(id)sender {
    
    [self removeSelf];
}

- (IBAction)okClick:(id)sender {
    
    if (_okBlock)
        _okBlock(nil);
    
    [self removeSelf];
}

@end
