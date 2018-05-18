//
//  TheRichViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/6/13.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "TheRichViewController.h"
#import "MyAccountCollectionViewController.h"
#import "MineRequest.h"
#import "BlocksKit+UIKit.h"
@interface TheRichViewController ()

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *progressV; // 进度条
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn; // 充值按钮
@property (weak, nonatomic) IBOutlet UIButton *appointmentBtn; // 约台下单按钮
@property (weak, nonatomic) IBOutlet UIImageView *rankMaxIV; // 土豪级别
@property (weak, nonatomic) IBOutlet UILabel *rankLabel; // 土豪值
@property (weak, nonatomic) IBOutlet UILabel *currentNumLabel; // 当前值
@property (weak, nonatomic) IBOutlet UILabel *sumLabel; // 总共值
@property (weak, nonatomic) IBOutlet UIImageView *rankLeftIV;
@property (weak, nonatomic) IBOutlet UILabel *rankLeftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rankRightIV;
@property (weak, nonatomic) IBOutlet UILabel *rankRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *gapLabel;

@property (nonatomic, copy) NSString *theRichValue; /** 土豪值 */
@property (nonatomic, assign) NSInteger theRichRankNum; /** 土豪值所属等级 */

@end

@implementation TheRichViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view layoutIfNeeded];
    
    [self setupChargeBtn];
    
    [self setupAppointmentBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupRequest];
}

#pragma mark - 约台下单
- (void)setupAppointmentBtn
{
    @weakify(self);
    [_appointmentBtn bk_whenTapped:^{
        @strongify(self);
        [self.navigationController pushViewController: ViewController(@"AllBarListSB", @"AllBarListViewController") animated:YES];
    }];
}


#pragma mark - 充值
- (void)setupChargeBtn
{
    @weakify(self);
    [_rechargeBtn bk_whenTapped:^{
        @strongify(self);
        [self.navigationController pushViewController:[MyAccountCollectionViewController initSBWithSBName:@"MyAccountSB"] animated:YES];
    }];
}

#pragma mark - 请求数据
- (void)setupRequest
{
    PersonRankListRequest *r = [[PersonRankListRequest alloc] init];
    r.model = CurrentUser.userID;
    
    [r startRequestWithCompleted:^(ResponseState *state) {
        NSDictionary *param = [state.data firstObject];
        
        [self handleResponseData:param];
    }];

}

#pragma mark - 处理返回的数据
- (void)handleResponseData:(NSDictionary *)param
{
    //土豪值
    NSString *theRichValue = param[@"daifug_value"];
    
    // 计算对于的等级
    self.theRichValue = theRichValue;
    
    //设置顶部
    NSString *bigRankName = [NSString stringFromeArray:@[@"icon_vipzerobig",@"icon_viponebig",@"icon_viptwobig",@"icon_vipthreebig",@"icon_vipfourbig",@"icon_vipfivebig",@"icon_vipsixbig",@"icon_vipsevenbig",@"icon_vipeightbig",@"icon_vipninebig",@"icon_viptenbig",@""] index:self.theRichRankNum];
    
    _rankMaxIV.image = KGetImage(bigRankName);
    
    _rankLabel.text = [NSString stringWithFormat:@"土豪值:%@",theRichValue];
    
    // 设置当前等级
    NSString *sumValue = [NSString stringFromeArray:@[@"0",@"100",@"500",@"1000",@"3000",@"6000",@"10000",@"15000",@"20000",@"30000",@"50000",@""] index:self.theRichRankNum + 1];
    _currentNumLabel.text = [NSString stringWithFormat:@"%0.2f",[theRichValue floatValue]];
    _sumLabel.text = [NSString stringWithFormat:@"/%@",sumValue];
    
    NSArray *rankNames = @[@"土豪V0级",@"土豪V1级",@"土豪V2级",@"土豪V3级",@"土豪V4级",@"土豪V5级",@"土豪V6级",@"土豪V7级",@"土豪V8级",@"土豪V9级",@"土豪V10级",@""];
    NSArray *rankImages = @[@"icon_vipzero",@"icon_vipone",@"icon_viptwo",@"icon_vipthree",@"icon_vipfour",@"icon_vipfive",@"icon_vipsix",@"icon_seven",@"icon_eight",@"icon_ten"];
    
    _rankLeftIV.image = KGetImage([NSString stringFromeArray:rankImages index:self.theRichRankNum]);
    _rankLeftLabel.text = [NSString stringFromeArray:rankNames index:self.theRichRankNum];
    _rankRightLabel.text = [NSString stringFromeArray:rankNames index:self.theRichRankNum + 1];
    _rankRightIV.image = KGetImage([NSString stringFromeArray:rankImages index:self.theRichRankNum + 1]);
    
    _gapLabel.text = [NSString stringWithFormat:@"还有%0.2f土豪值就能升级了~",[sumValue floatValue] - [theRichValue floatValue]];
    
    // 添加进度
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, [theRichValue doubleValue] / [sumValue doubleValue] * _progressV.width, _progressV.height);
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    gradient.locations = @[@0.45,@0.5,@0.45];
    gradient.cornerRadius = 4;
    gradient.colors = @[(__bridge id)RGBCOLOR(255, 192, 0).CGColor,(__bridge id)RGBCOLOR(247, 243, 14).CGColor];
    [_progressV.layer addSublayer:gradient];
    [_headView bringSubviewToFront:_progressV];
}

#pragma mark - Setter
- (void)setTheRichRankNum:(NSInteger)theRichRankNum
{
    _theRichRankNum = theRichRankNum;
}

- (void)setTheRichValue:(NSString *)theRichValue
{
    _theRichValue = theRichValue;
    // 计算等级
    NSInteger rank = 0;
    switch ([theRichValue integerValue]) {
        case 0:{
            rank = 0;
        }break;
        case 100:{
            rank = 1;
        }break;
        case 500:{
            rank = 2;
        }break;
        case 1000:{
            rank = 3;
        }break;
        case 3000:{
            rank = 4;
        }break;
        case 6000:{
            rank  = 5;
        }break;
        case 10000:{
            rank = 6;
        }break;
        case 15000:{
            rank = 7;
        }break;
        case 20000:{
            rank = 8;
        }break;
        case 30000:{
            rank = 9;
        }break;
        case 50000:{
            rank = 10;
        }break;
    }

    _theRichRankNum = rank;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
