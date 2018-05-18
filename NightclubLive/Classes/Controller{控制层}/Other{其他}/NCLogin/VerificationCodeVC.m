//
//  VerificationCodeVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/12.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "VerificationCodeVC.h"
#import "VerificationCodeViewModel.h"
#import "LRUserInfoViewController.h"
#import "LoginAndRegistRequest.h"
#import "GlobalRequest.h"
#import "UIWindow+CurrentViewController.h"

@interface VerificationCodeVC ()

@property (weak, nonatomic) IBOutlet UIButton *countdownBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (nonatomic, strong) VerificationCodeViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIButton *reCountDownBtn;
@property (weak, nonatomic) IBOutlet UILabel *oldPhoneLable;

@end

@implementation VerificationCodeVC
@dynamic viewModel;

- (void)viewDidLoad {
    
    [super viewDidLoad];

    _oldPhoneLable.text = self.viewModel.params[@"phone"];

    RAC(self.viewModel, code) = self.codeTextFiled.rac_textSignal;
    RAC(self.doneBtn, tag) = self.viewModel.doneEnableSignal;
    RAC(self.reCountDownBtn, tag) = self.viewModel.doneEnableSignal;

    @weakify(self);
    
    // 下一步
    [[self.doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn)
    {
        @strongify(self)
        
        [self.view endEditing:YES];
    
        if (_codeTextFiled.text.length == 0){
            ShowError(@"请输入验证码");
            return;
        }
        
        // 进行验证码验证
        LRUserInfoViewController *vc = [LRUserInfoViewController initSBWithSBName:@"LRUserInfoSB"];
        vc.authCode = self.codeTextFiled.text;
        vc.phone = self.phone;
        vc.paw = self.paw;
        vc.invitationCode = self.invitationCode;
        
        [self.navigationController pushViewController:vc animated:YES];
    }];

    [[_countdownBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn)
    {
        @strongify(self);
        [self.view endEditing:YES];

        [self getCode];

    }];
    
    [[_reCountDownBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn)
     {
        @strongify(self);
        [self.view endEditing:YES];
        [self.viewModel.reuqesCodeCommand execute:nil];
    }];
    
    [self.viewModel.reuqesCodeCommand.executionSignals.switchToLatest subscribeNext:^(id x) {

        if ([x[@"code"] integerValue] == 3){
            
            [_reCountDownBtn startWithTime:60 title:@"收不到验证码？点击重发" countDownTitle:@"s" mainColor:[UIColor clearColor] countColor:[UIColor clearColor]];
            
        }

    }];
    
    [self.viewModel.reuqesRegistCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *resultDic)
    {
        if ([resultDic[@"isSuccess"] boolValue]) {
            [[UIApplication sharedApplication].delegate.window makeToast:@"注册成功！" duration:3 position:CSToastPositionCenter];
            [self.navigationController popToRootViewControllerAnimated:YES];

        }
        else{
            
            // 错误情况
            [[UIApplication sharedApplication].delegate.window makeToast:resultDic[@"msg"] duration:1 position:CSToastPositionCenter];
        }
    }];

    [self.viewModel.reuqesRegistCommand.executing subscribeNext:^(NSNumber *executing)
    {
        if (executing.boolValue) {
            ShowLoading
        } else {
            CloseLoading
        }
    }];
    
    [self.view endEditing:YES];
    
    [self getCode];
}

#pragma mark - 获取验证码
- (void)getCode
{
    GetCodeRequest *request = [GetCodeRequest new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.phone.length >0) {
        [params setValue:self.phone forKey:@"phonenum"];
    }
    [params setValue:@1 forKey:@"type"];
    request.param = params;

    [request startRequestWithCompleted:^(ResponseState *state)
     {
        [self.view makeToast:state.message duration:1 position:CSToastPositionCenter];
        if (state.responseCode == 3)
        {
            [_countdownBtn startWithTime:60 title:@"获取验证码" countDownTitle:@"s" mainColor:APPDefaultColor countColor:[UIColor clearColor]];
        }
    }];
}

@end
