//
//  CharmHUD.m
//  NightclubLive
//
//  Created by rdp on 2017/5/26.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "CharmHUD.h"
#import "UIView+ScottAlertView.h"
#import "UIWindow+CurrentViewController.h"
#import "RankViewController.h"
#import "BlocksKit+UIKit.h"
@implementation CharmHUD

#pragma mark - 生命周期

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    @weakify(self);
    //增加事件
    [_closeBtn bk_whenTapped:^{
        @strongify(self);
        [self remove];
    }];
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
}

#pragma mark - Public Methodo

+ (CharmHUD *) showCharHUDWithCharValue:(NSString *)charmValue{
    
    CharmHUD *hud = [CharmHUD initFromXIB];
    hud.charmValueLabel.text = [NSString stringWithFormat:@"+ %@",charmValue];
    hud.frame= CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [ShareWindow addSubview:hud];
    
    return hud;
}

#pragma mark - Priavte

- (void)autoRemoveFromSuperView{

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 2), dispatch_get_global_queue(0, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self remove];
        });
        
    });
}

- (void)remove{
    
    [self removeFromSuperview];
}


- (IBAction)rankClick:(id)sender {
    
    if (self.removeBlock)
        self.removeBlock(nil);
    
    [self remove];
    
    [self autoRemoveFromSuperView];
    
}


@end
