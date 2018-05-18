//
//  WithdrawSuccessViewController.m
//  NightclubLive
//
//  Created by rdp on 2017/5/25.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "WithdrawSuccessViewController.h"

@interface WithdrawSuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation WithdrawSuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 设置提示
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc] initWithString:_tipLabel.text];
    [mString addAttribute:NSForegroundColorAttributeName value:APPDefaultColor range:(NSRange){5,3}];
    _tipLabel.attributedText = mString;
}

- (IBAction)okClick:(id)sender
{
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    
    if (index > 2)
    {
        [self.navigationController popToViewController:self.navigationController.viewControllers[index - 2] animated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
