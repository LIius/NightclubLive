//
//  SuccessInfoViewController.m
//  NightclubLive
//
//  Created by SuperDanny on 2016/12/14.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "SuccessInfoViewController.h"

@interface SuccessInfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *infoLab;

@end

@implementation SuccessInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    switch (_viewType) {
        case SuccessType_Recharge: {
            _infoLab.text = @"充值成功";
        }
            break;
        case SuccessType_WithdrawCash: {
            _infoLab.text = @"提现成功";
        }
            break;
        case SuccessType_Pay: {
            _infoLab.text = @"支付成功";
        }
            break;
        default:
            break;
    }
}

- (IBAction)okClick:(id)sender
{
    [self.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 4] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
