//
//  WithdrawCashTableViewController.m
//  NightclubLive
//
//  Created by SuperDanny on 2016/12/13.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "WithdrawCashTableViewController.h"
#import "MineRequest.h"
#import "WithdrawSuccessViewController.h"

@interface WithdrawCashTableViewController ()
<
UIScrollViewDelegate,
UITextFieldDelegate
>

@property (weak, nonatomic) IBOutlet UILabel *accountTipLabel;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UILabel *nameTipLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UILabel *moneyTipLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UILabel *sumMoneyLabel;

@end

@implementation WithdrawCashTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.view.backgroundColor = UIColorHex(0xEFF0F1);
    
    [self setupViewDidload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"*可提现金额为%@元",CurrentUser.account.user_rmb]];
    [mString addAttribute:NSForegroundColorAttributeName value:APPDefaultColor range:(NSRange){0,1}];
    [mString addAttribute:NSForegroundColorAttributeName value:APPDefaultColor range:(NSRange){7,CurrentUser.account.user_rmb.length}];
    _sumMoneyLabel.attributedText = mString;
}

- (void)setupViewDidload
{
    _accountTipLabel.text = [NSString stringFromeArray:@[@"微信账号",@"支付宝账号"] index:self.tag];
    NSMutableAttributedString *ms = [[NSMutableAttributedString alloc] initWithString:_nameTipLabel.text];
    [ms addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:_nameTipLabel.font.pointSize - 3] range:NSMakeRange(2, 4)];
    
    _nameTipLabel.attributedText = ms;
    
    
    ms = [[NSMutableAttributedString alloc] initWithString:_moneyTipLabel.text];
    [ms addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:_moneyTipLabel.font.pointSize - 3] range:NSMakeRange(2, 3)];
    _moneyTipLabel.attributedText = ms;
}

#pragma mark - 确定转出
- (IBAction)withdrawCashAction:(id)sender
{
    [self.view endEditing:YES];
    
    //判断
    NSString *error = nil;
    
    AccountModel *account = CurrentUser.account;
    //获取金额提现金额
    CGFloat withdrawMoney = [_moneyTF.text doubleValue];
    //获取账号目前的金额
    CGFloat accountMoney = [account.user_rmb doubleValue];
    if (_accountTF.text.length == 0)
        error = @"请输入账号";
    else if(_moneyTF.text.length == 0)
        error = @"请输入提现金额";
    else if (withdrawMoney >accountMoney)
        error = @"提现金额不能大于账号余额";
    else if (self.nameTF.text.length == 0){
        error = @"请输入提现人姓名";
    }
    
    if (error){
        ShowError(error);
        return;
    }

    [self setupWithdraw];
}

- (void)setupWithdraw
{
    @weakify(self);
    WithdrawRequest *r = [WithdrawRequest new];
    r.account = _accountTF.text;
    r.money = _moneyTF.text;
    r.name = _nameTF.text;
    r.type = self.tag == 0 ? 1 : 0;
    ShowLoading
    
    [r startRequestWithCompleted:^(ResponseState *state) {
        @strongify(self);
        CloseLoading;
        if (state.isSuccess){
            
            //更新用户资料
            [CurrentUser updateUserAccountCompletion:^(id param) {
            }];
            
            WithdrawSuccessViewController *vc = ViewController(@"WithdrawSuccessSB", @"WithdrawSuccessViewController");
            
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            ShowError(@"提现失败");
        }
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
