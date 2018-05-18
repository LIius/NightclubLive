//
//  MiniNightBitViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MiniNightBitViewController.h"
#import "WithdrawCashTableViewController.h"
#import "UIAlertController+Factory.h"
#import "NCAlert.h"
@interface MiniNightBitViewController ()

@property (weak, nonatomic) IBOutlet UIButton *introduceBtn;
@property (weak, nonatomic) IBOutlet UIButton *convertRMBBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *convertNBBtn;

/** 夜比特余额 */
@property (weak, nonatomic) IBOutlet UILabel *ncBitLabel;
/** 小夜币余额 */
@property (weak, nonatomic) IBOutlet UILabel *mncBitLabel;

@property (weak, nonatomic) IBOutlet UIButton *moneyDescBtn;


@end

@implementation MiniNightBitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_moneyDescBtn setTitle:@"零钱余额(元)" forState:UIControlStateNormal];
    [_moneyDescBtn buttonImageLeftImageRightLabelWithImageString:@"icon_money" margin:6];
    
    _convertRMBBtn.layer.borderWidth = 1;
    _convertRMBBtn.layer.borderColor = APPDefaultColor.CGColor;
    _convertRMBBtn.layer.masksToBounds = YES;
    _convertRMBBtn.layer.cornerRadius = 5;
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:_introduceBtn.titleLabel.text];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [_introduceBtn setAttributedTitle:title
                      forState:UIControlStateNormal];
    
    NSMutableAttributedString *tipString = [[NSMutableAttributedString alloc] initWithString:_tipLabel.text];
    [tipString addAttribute:NSForegroundColorAttributeName value:APPDefaultColor range:(NSRange){1,3}];
    [tipString addAttribute:NSForegroundColorAttributeName value:APPDefaultColor  range:(NSRange){15,5}];
    [tipString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:(NSRange){17,4}];
    [_tipLabel setAttributedText:tipString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //加载显示数据
    _ncBitLabel.text = CurrentUser.account.night_bit;
    _mncBitLabel.text = CurrentUser.account.user_rmb;
}

#pragma mark - Private Method
- (void)loadDataToView
{
    _ncBitLabel.text = CurrentUser.account.night_bit;
    _mncBitLabel.text = CurrentUser.account.user_rmb;
}

#pragma mark - 零钱记录
- (IBAction)logClick:(id)sender
{
    PushViewController(ViewController(@"AccountLogSB", @"AccountLogViewController"));
}

#pragma mark - 兑换夜比特
- (IBAction)convertNBtnClick:(id)sender
{
    PushViewController(ViewController(@"ConvertNCNSB", @"ConvertNCNViewController"));
}

#pragma mark - 零钱体现
- (IBAction)convertRMBClick:(id)sender
{
    @weakify(self);
    [NCAlert showActionSheetWithDataSource:@[@"微信提现",@"支付宝提现"] blockHandel:^(NSInteger index) {
        if (index==0 || index == 1)
        {
            @strongify(self);
            WithdrawCashTableViewController *vc = [WithdrawCashTableViewController initSBWithSBName:@"WithdrawCashSB"];
            vc.tag = index;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];

}


@end
