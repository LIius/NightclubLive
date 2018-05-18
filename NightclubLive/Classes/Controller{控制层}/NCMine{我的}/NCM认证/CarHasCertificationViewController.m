//
//  CarHasCertificationViewController.m
//  NightclubLive
//
//  Created by SuperDanny on 2017/1/9.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "CarHasCertificationViewController.h"
#import "GlobalRequest.h"
#import "AuthModel.h"


@interface CarHasCertificationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *carIV;
@property (weak, nonatomic) IBOutlet UILabel *carNameLabel;

@end

@implementation CarHasCertificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupRequest];
}

#pragma mark - 获取车辆认证信息
- (void)setupRequest
{
    ShowLoading;
    GetCarRequest *r = [GetCarRequest new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([UserInfo shareUser].userID.length >0)
    {
        [params setValue:[UserInfo shareUser].userID forKey:@"userId"];
    }
    
    r.param = params;
    //r.param = @{@"userId":[UserInfo shareUser].userID};
    [r startRequestWithCompleted:^(ResponseState *state) {
        
        CloseLoading;
        
        CarAuthModel *m = [[CarAuthModel arrayObjectWithDS:state.datas] firstObject];
        
        //加载到页面
        [_carIV sd_setImageWithURL:nil placeholderImage:[UIImage picturePlaceholder]];
        _carNameLabel.text = m.brand;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
