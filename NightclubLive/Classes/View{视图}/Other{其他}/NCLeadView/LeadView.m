   //
//  LeadView.m
//  NightclubLive
//
//  Created by RDP on 2017/3/21.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "LeadView.h"

@interface LeadView()<UIScrollViewDelegate>

/** 滚动视图 */
@property (nonatomic, strong) UIScrollView *contentSV;
/** 点击进入 */
@property (nonatomic, strong) UIButton *enterBtn;

@end

@implementation LeadView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]){
        
        //添加内容
        [self addSubview:({
            
            UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.bounds];        self.contentSV.backgroundColor = [UIColor blueColor];
            sv.pagingEnabled = YES;
            sv.bouncesZoom = NO;
            sv.bounces = NO;
            sv.delegate = self;
            self.contentSV = sv;
            
        })];
        
        [self addSubview:({
            
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
            [btn addTarget:self action:@selector(enterAppClick) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:KGetImage(@"icon_purpleenter") forState:UIControlStateNormal];
            btn.hidden = YES;

            self.enterBtn = btn;
        })];
        
        [self addLeadImg];
   
    }
    return self;
}


/**
 *  添加引导页
 */
- (void)addLeadImg
{

    NSArray *leadImgs = @[@"icon_intruductionone",@"icon_intruductiontwo",@"icon_intruductionthree",@"icon_intruductionfour"];
    
    for (NSInteger i = 0 ; i < leadImgs.count ; i ++){
        
        UIImageView *leadIV = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.width, 0, self.width, self.height)];
        
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:leadImgs[i] ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        
        [leadIV sd_setImageWithURL:nil placeholderImage:image];
        [_contentSV addSubview:leadIV];
    }
    
    _contentSV.contentSize = CGSizeMake(leadImgs.count * self.width, self.height);
    
    CGFloat width  = self.width * 0.4;
    CGFloat height = self.height * 0.06;
    _enterBtn.frame = CGRectMake((self.width - width) * 0.5, self.height - self.height * 0.024 - height, width, height);
}

#pragma mark - Button Click

- (void)enterAppClick{
    
    [_enterBtn removeFromSuperview];
    
    [UIView animateWithDuration:1.0 animations:^{
        _contentSV.frame = CGRectMake( -self.width , 0, self.width, self.height);
    } completion:^(BOOL finished) {
        //发送移除通知
        [[NSNotificationCenter defaultCenter] postNotificationName:LeadNotificationAddKey object:nil];
        [self removeFromSuperview];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger currentIndex =  floor((scrollView.contentOffset.x - scrollView.width / 2) /scrollView.width) + 1;
    _enterBtn.hidden = !(currentIndex == 3);
}

@end
