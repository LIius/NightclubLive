//
//  NCPlayVideoViewController.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/10/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NCPlayVideoViewController.h"

@interface NCPlayVideoViewController ()

@property (nonatomic,strong)AVPlayer *player;

@end

@implementation NCPlayVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    self.player = [[AVPlayer alloc]initWithPlayerItem:_playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    // 设置模式
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.contentsScale = [UIScreen mainScreen].scale;
    playerLayer.frame = CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.width *9/16);
    [self.view.layer addSublayer:playerLayer];
    [self.player play];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
