//
//  WBLoadingHUD.m
//  WBLoadingHUD
//
//  Created by RDP on 2017/4/10.
//  Copyright © 2017年 RDP. All rights reserved.
//

#import "WBLoadingHUD.h"

static WBLoadingHUD *HUD;

@interface WBLoadingHUD()

@property (weak, nonatomic) IBOutlet UIImageView *animationIV;

@property (nonatomic, strong) NSArray *animationImgs;
@end

@implementation WBLoadingHUD


- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
}

+ (instancetype)share{
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        HUD = [[[NSBundle mainBundle] loadNibNamed:@"WBLoadingHUD" owner:nil options:nil] firstObject];
        HUD.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

    });
    
    return HUD;
}

+ (void)show{
    
    [[WBLoadingHUD share] private_show];
}

+ (void)close{
    
    [[WBLoadingHUD share] stopAnimation];
}

- (void)private_show{
    
    [self runEventIntMain:^{
        if ([[WBLoadingHUD share].animationIV isAnimating]){//播放动画中
            [WBLoadingHUD close];
        }
        else{
            [[WBLoadingHUD share] initAnimation];
            
        }
        
        [[UIApplication sharedApplication].windows.firstObject addSubview:[WBLoadingHUD share]];
        [[WBLoadingHUD share] startAnimation];

    }];
}

- (void)initAnimation{
    
    [self.animationIV setAnimationImages:self.animationImgs];
    [self.animationIV setAnimationDuration:1.05];
    [self.animationIV setAnimationRepeatCount:0];
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [WBLoadingHUD share].frame = CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height);
}

- (void)stopAnimation{

    [self runEventIntMain:^{
        
        [self.animationIV stopAnimating];
        self.animationImgs = nil;
        
        [[WBLoadingHUD share] removeFromSuperview];
    }];
}

- (void)startAnimation{
    
    [self.animationIV startAnimating];
}

- (NSArray *)animationImgs{
    
    if (!_animationImgs){
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSInteger i = 3 ; i <= 28 ; i ++){
            
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"弹弹球_000%0.2ld",(long)i] ofType:@"png"]];
            
            [array addObject:image];
        }
        
        _animationImgs = [array copy];
        
    }
    return _animationImgs;
}


- (void)removeSelf{
    
    [WBLoadingHUD close];
}


#pragma mark - GCG

- (void)runEventIntMain:(void (^)())eventBlock{
    
    NSThread *currentThread =  [NSThread currentThread];
    
    if ([currentThread isMainThread]){
        
        eventBlock();
        
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        eventBlock();
        
    });
}

@end
