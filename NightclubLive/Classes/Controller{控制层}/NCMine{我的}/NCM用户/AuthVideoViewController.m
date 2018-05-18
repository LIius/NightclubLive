//
//  AuthVideoViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/7/29.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AuthVideoViewController.h"
#import "ZFPlayerView+Quick.h"
#import "UIImageView+SDWebImage.h"

@interface AuthVideoViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
@property (nonatomic,strong)ZFPlayerView *playView;

@end

@implementation AuthVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 加载数据
    if (self.coverImage ) {
        _coverIV.image = self.coverImage;
    }else{
        [_coverIV imageViewSizeWithURL:self.coverURL placeholderImage:[UIImage picturePlaceholder]];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.playView resetPlayer];
}

- (IBAction)playVideoClick:(UIButton *)sender
{
    sender.hidden = YES;
    
    self.playView = [ZFPlayerView quickInitSuperView:_contentView title:@"" coverURL:self.coverURL video:self.videoURL];
}

@end
