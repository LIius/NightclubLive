//
//  WheelView.m
//  NightclubLive
//
//  Created by RDP on 2017/3/17.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "WheelView.h"

/** 最大圈数 */
static NSInteger maxLoopCount = 5;

@interface WheelView(){
    
    NSInteger angle;
    //当前圈数
    NSInteger loopCount;
}
@property (weak, nonatomic) IBOutlet UIView *wheelBackView;
@property (weak, nonatomic) IBOutlet UIImageView *wheelBackIV;
@property (weak, nonatomic) IBOutlet UIView *ballBackView;
@property (weak, nonatomic) IBOutlet UIImageView *ballIV;
@property (weak, nonatomic) IBOutlet UIImageView *leafIV;
@property (weak, nonatomic) IBOutlet UIButton *moveBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (nonatomic, assign) BOOL canAniatiom;
@property (nonatomic, assign) NSInteger stopAngle;
//
//@property (strong, nonatomic) UIView *wheelBackView;
//@property (strong, nonatomic) UIImageView *wheelBackIV;
//@property (strong, nonatomic) UIView *ballBackView;
//@property (strong, nonatomic) UIImageView *ballIV;
//@property (strong, nonatomic) UIImageView *leafIV;
//@property (strong, nonatomic) UIButton *moveBtn;
//@property (strong, nonatomic) UIButton *closeBtn;
//@property (nonatomic, strong) UIView *spaceView;


@end

@implementation WheelView

#pragma mark - Init

+ (instancetype)wheel{
    
    WheelView *v = [[[NSBundle mainBundle] loadNibNamed:@"WheelView" owner:nil options:nil] firstObject];
    
    v.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
    v.frame = KEYWINDOW.bounds;
    
    [KEYWINDOW addSubview:v];
    
    
    v.wheelBackView.frame = CGRectMake(v.width, v.height, 0, 0);
    [v changeSubview];
    v.closeBtn.frame = CGRectMake(0, 0, 0, 0);

    v.stopAngle = -1;
    
    return v;
}

#pragma mark - Private

- (void)changeSubview{
    
    //改变大转盘内容
    //1.改变背景
    CGRect frame;
    CGFloat width = _wheelBackView.width * 0.92;;
    CGFloat height = width * (708 / 666);
    frame = _wheelBackIV.frame;
    frame.size = CGSizeMake(width, height);
    frame.origin = CGPointMake(_wheelBackView.width * 0.08 * 0.5, 0);
    _wheelBackIV.frame = frame;
    
    //2.改变转盘背景
    frame = _ballBackView.frame;
    frame.size = CGSizeMake(_wheelBackView.width * 0.8, _wheelBackView.width * 0.8);
    frame.origin = CGPointMake((_wheelBackView.width - frame.size.width) * 0.5, _wheelBackIV.height * 0.4);
    _ballBackView.frame = frame;
    
    //3.大转盘外盘
    frame = _ballIV.frame;
    frame.size = _ballBackView.size;
    frame.origin = CGPointMake((_ballBackView.width - frame.size.width) * 0.5, 0);
    _ballIV.frame = frame;
    
    
    //4.转盘叶子
    frame = _leafIV.frame;
    frame.size = CGSizeMake(_ballIV.size.width * 0.8, _ballIV.size.width * 0.8);
    frame.origin = CGPointMake((_ballBackView.width - frame.size.width) * 0.5, (_ballBackView.height - frame.size.height) * 0.5);
    _leafIV.frame = frame;
    
    
    //5.按键
    frame = _moveBtn.frame;
    frame.size = CGSizeMake(_leafIV.width * 0.4, _leafIV.width * 0.4);
    frame.origin = CGPointMake((_ballBackView.width - frame.size.width) * 0.5, (_ballBackView.height - frame.size.height) * 0.5);
    _moveBtn.frame = frame;
}

#pragma mark - public 

- (void)appear{
    
    [_leafIV sd_setImageWithURL:self.leafImageURL];
    
    [UIView animateWithDuration:1.0 animations:^{
        
        self.closeBtn.frame = CGRectMake(30, 0, 35.5, 89.5);

        self.wheelBackView.frame = CGRectMake(0, CGRectGetMaxY(self.closeBtn.frame), self.width, self.height * 0.8);
        [self changeSubview];
    }];
}

- (void)dispaer{
    
}

- (void)endAnmitionWithAngel:(NSInteger)stopAngel{
    
    self.stopAngle = stopAngel;
}


#pragma mark - Button click

- (IBAction)selfTag:(id)sender {
    
  //  [self removeFromSuperview];
}

- (IBAction)moveClick:(id)sender {
    
    
    if ([_ballIV isAnimating]){{
        [_ballIV stopAnimating];
        _canAniatiom = NO;
    }
    }else{
        angle = 0;
        loopCount = 0;
        [self.leafIV sd_setImageWithURL:self.leafImageURL];
        [_ballIV setAnimationImages:@[[UIImage imageNamed:@"bg_botton1"],[UIImage imageNamed:@"bg_botton2"]]];
        _ballIV.animationRepeatCount = 0;
        _ballIV.animationDuration = 1.53f;
        [_ballIV startAnimating];
        
        _canAniatiom = YES;
        
        [self startAnimation];
        
        if (self.startAnmitaion){
            
            self.startAnmitaion(nil);
        }

    }
    
}

- (void)startAnimation{
    
    [UIView animateWithDuration:0.07 animations:^{
        
       CGAffineTransform affine =  CGAffineTransformMakeRotation(angle * (M_PI /180.0f));
        
        _leafIV.transform = affine;
        
    } completion:^(BOOL finished) {
        
        if (self.stopAngle == angle && loopCount > maxLoopCount){
            _canAniatiom = NO;
        }
        
        if (_canAniatiom){
            
            angle += 45;
            
            if (angle > 360){
                angle = 0;
                loopCount += 1;
            }
            
            [self startAnimation];
        }else{
            
            [_ballIV stopAnimating];
            
            if (self.endAnimation)
                self.endAnimation(nil);
            
            DLog(@"angle = %ld",angle);

        }
    }];

}

- (IBAction)closeBtn:(id)sender {
    
    [self removeFromSuperview];
}
@end
