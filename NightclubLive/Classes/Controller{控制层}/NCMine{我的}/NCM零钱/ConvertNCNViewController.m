//
//  ConvertNCNViewController.m
//  NightclubLive
//
//  Created by rdp on 2017/5/25.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ConvertNCNViewController.h"
#import "MineModelList.h"
#import "MineRequest.h"
#import "MineRequest.h"
#import "ExChangeView.h"
#import "ScottAlertController.h"

@interface ConvertNCNViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *convertNumTF;
@property (weak, nonatomic) IBOutlet UILabel *sumMoneyLabel;

@end

@implementation ConvertNCNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self seutpViewDidload];
}

- (void)seutpViewDidload
{
    _accountTF.text = CurrentUser.lgPhone;
    
    {
        // 更新显示
        double canGetNCNum = [CurrentUser.account.user_rmb doubleValue] * 11;
        NSString *canGetNCNumString = [NSString stringWithFormat:@"%0.2f",canGetNCNum];
        NSMutableAttributedString *mString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"* 可兑换夜比特总额为%@夜比特",canGetNCNumString]];
        [mString addAttribute:NSForegroundColorAttributeName value:APPDefaultColor range:(NSRange){0,1}];
        [mString addAttribute:NSForegroundColorAttributeName value:APPDefaultColor range:(NSRange){11,canGetNCNumString.length}];
        _sumMoneyLabel.attributedText = mString;
    }
}

- (IBAction)okClik:(id)sender
{
    // 检查兑换数额
    double nc = [_convertNumTF.text doubleValue];
    NSString *error;
    
    if (nc <= 0){
        error = @"请输入正确的金额";
    }
    
    if (error){
        ShowError(error);
        return;
    }
    
    [self setupChargeNCN:nc];
}

- (void)setupChargeNCN:(double)nc
{
    @weakify(self);
    // 进行网络请求
    ConvertNVRequest *r = [ConvertNVRequest new];
    r.nc = nc;
    [r startRequestWithCompleted:^(ResponseState *state)
     {
         @strongify(self);
         ExChangeView *v = [ExChangeView initFromXIB];
         v.model = _convertNumTF.text;
         if (!state){
             v.showType = ExChangeTipTypeNoNetWork;
         }
         else{
             if (state.isSuccess)
             {
                 // 更新一下用户账号信息
                 [CurrentUser updateUserAccountCompletion:^(id param) {
                 }];
                 
                 v.showType = ExChangeTipTypeSucess;
             }
             else{
                 v.showType = ExChangeTipTypeFail;
             }
         }
         
         ScottAlertViewController *s = [ScottAlertViewController alertControllerWithAlertView:v];
         
         v.okBlock = ^(id param)
         {
             @strongify(self);
             if (state.isSuccess)
             {
                 [self.navigationController popViewControllerAnimated:YES];
             }
         };
         
         [self presentViewController:s animated:YES completion:nil];
     }];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
