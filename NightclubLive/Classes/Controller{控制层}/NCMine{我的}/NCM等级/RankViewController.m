//
//  RankViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/19.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "RankViewController.h"


@interface RankViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *introduceIV;
@property (weak, nonatomic) IBOutlet UIImageView *rankProgressBackIV;
@property (weak, nonatomic) IBOutlet UIImageView *rankProgressIV; /** 等级进度 */

//等级I 0 -> 3 (对应等级小虾，少年，青年，大神)
/** DN */
/** 小虾等级 */
@property (weak, nonatomic) IBOutlet UIImageView *rank_0IV;
/** 少年等级 */
@property (weak, nonatomic) IBOutlet UIImageView *rank_1IV;
/** 少年等级 */
@property (weak, nonatomic) IBOutlet UIImageView *rank_2IV;
/** 青年等级 */
@property (weak, nonatomic) IBOutlet UIImageView *rank_3IV;
/** 等级图标 */
@property (weak, nonatomic) IBOutlet UIImageView *rankIV;
/** 等级称号 */
@property (weak, nonatomic) IBOutlet UILabel *rankNameLabel;
/** 魅力值 */
@property (weak, nonatomic) IBOutlet UILabel *charmLable;

//星星部分
@property (weak, nonatomic) IBOutlet UIImageView *oneRankIV;
@property (weak, nonatomic) IBOutlet UIImageView *twoRankIV;
@property (weak, nonatomic) IBOutlet UIImageView *threeRankIV;
@property (weak, nonatomic) IBOutlet UIImageView *fourRankIV;

//数值部分
/** 数额0 */
@property (weak, nonatomic) IBOutlet UIImageView *num0IV;
@property (weak, nonatomic) IBOutlet UIImageView *num20000IV;
@property (weak, nonatomic) IBOutlet UIImageView *num40000IV;
@property (weak, nonatomic) IBOutlet UIImageView *num80000IV;
@property (weak, nonatomic) IBOutlet UIView *headBackView;

@end

@implementation RankViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupViewDidload];
}

- (void)setupViewDidload
{
    // 防止图片变形
    UIImage *progressImage = KGetImage(@"icon_jindutiaosmall");
    CGFloat w = progressImage.size.width * 0.5;
    CGFloat h = progressImage.size.height * 0.5;
    progressImage =  [progressImage resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeTile];
    _rankProgressIV.image = progressImage;
    UIImage *rankBackImage =  _rankProgressBackIV.image;
    w = rankBackImage.size.width * 0.5;
    h = rankBackImage.size.height * 0.5;
    rankBackImage =  [rankBackImage resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w) resizingMode:UIImageResizingModeStretch];
    _rankProgressBackIV.image = rankBackImage;
    
    
    // 调整进度
    [self.view layoutIfNeeded];
    
    //选取合适的进度
    CGFloat progressFloat = 0;
    CGFloat starTurnWidth = _oneRankIV.width - 0.24 * _oneRankIV.width;
    CGFloat starFalseWidth = _oneRankIV.width * 0.24;
    CGFloat spaceWidth = _twoRankIV.x - CGRectGetMaxX(_oneRankIV.frame) + 0.24 * _oneRankIV.width;
    NSInteger rank = CurrentUser.account.rank;
    CGFloat charm = [CurrentUser.account.charm_value floatValue];
    
    if (rank == 0){
        progressFloat = spaceWidth * charm / 20000;
    }
    else if (rank == 1){
        progressFloat = spaceWidth * (charm - 20000) / 20000 + spaceWidth;
    }
    else if (rank == 2){
        
        progressFloat = (spaceWidth * 2) * (charm - 40000) / 40000 + spaceWidth * 2;
    }
    else{
        progressFloat = spaceWidth * (charm - 80000) / 20000 + spaceWidth * 4;
    }
    
    progressFloat = progressFloat + starFalseWidth + starTurnWidth * (rank + 1);
    
    [_rankProgressIV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rankProgressIV.superview).offset(20.5 + _oneRankIV.width * 3/25);
        make.height.equalTo(_rankProgressBackIV).multipliedBy(2);
        make.centerY.equalTo(_rankProgressBackIV.mas_centerY);
        make.width.mas_equalTo(progressFloat);
    }];
}

#pragma mark - 实现父类方法
- (void)loadDataToView
{
    // 加载数据
    NSInteger rank = CurrentUser.account.rank;
    NSString *rankName = CurrentUser.account.rankName;
    // 头部
    NSString *imageName;
    imageName = [NSString stringFromeArray:@[@"icon_reddiamondbig",@"icon_yellowdiamondbig",@"icon_bluediamondbig",@"icon_yellowdiamondbig"] index:CurrentUser.account.rank];
    _rankIV.image = KGetImage(imageName);
    _charmLable.text = [NSString stringWithFormat:@"魅力值：%@",CurrentUser.account.charm_value];
    _rankNameLabel.text =  rankName;
    
    UIImageView *rangIV = [NSString imageViewFromeArray:@[_rank_0IV,_rank_1IV,_rank_2IV,_rank_3IV] index:rank];
    imageName = [NSString stringFromeArray:@[@"icon_xiaomion",@"icon_shaonianon",@"icon_qingnianon",@"icon_dashengon"] index:rank];
    rangIV.image = KGetImage(imageName);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
