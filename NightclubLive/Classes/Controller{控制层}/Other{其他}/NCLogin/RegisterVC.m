//
//  RegisterVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/12.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "RegisterVC.h"
#import "VerificationCodeVC.h"
#import "RegisterViewModel.h"
#import "VerificationCodeViewModel.h"
#import "AXWebViewController.h"

@interface RegisterVC ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *invitaionCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *showPawBtn;

@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;
@property (nonatomic, strong) RegisterViewModel *viewModel;

@end

@implementation RegisterVC
@dynamic viewModel;

- (void)viewDidLoad {
    
    [super viewDidLoad];

    @weakify(self)
    //rac biding
    RAC(self.viewModel, password) = self.pwdTextFiled.rac_textSignal;
    RAC(self.viewModel, phone) = self.phoneTextFiled.rac_textSignal;
    RAC(self.viewModel, invationCode) = self.invitaionCodeTextField.rac_textSignal;
    RAC(self.nextStepBtn, tag) = self.viewModel.nextEnableSignal;

    // 下一步
    [[self.nextStepBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self)
        
        [self.view endEditing:YES];
        if (btn.tag==1) {
            [self.view makeToast:@"请输入正确的手机号码" duration:1 position:CSToastPositionCenter];
        }else if (btn.tag==2) {
            [self.view makeToast:@"请输入正确的注册密码" duration:1 position:CSToastPositionCenter];
        }
        else if(btn.tag==3){
            [self.view makeToast:@"请输入正确的邀请码" duration:1 position:CSToastPositionCenter];
        }
        else if (btn.tag==666) {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"phone":self.viewModel.phone,@"pwd":self.viewModel.password}];
            
            if (self.viewModel.invationCode.length == InvationLength)
                [params setValue:self.viewModel.invationCode forKey:@"invaitionCode"];
            
            VerificationCodeViewModel *viewModel = [[VerificationCodeViewModel alloc] initWithParams:[params copy]];
            VerificationCodeVC *vc = [VerificationCodeVC controllerWithViewModel:nil andSbName:@"VerificationCodeSB"];
            vc.viewModel = viewModel;
            vc.phone = _phoneTextFiled.text;
            vc.paw = _pwdTextFiled.text;
            vc.invitationCode = _invitaionCodeTextField.text;
            [self.navigationController pushViewController:vc animated:YES];
        }

    }];
    
    // 添加关闭键盘
    UITapGestureRecognizer *tagGest = [UITapGestureRecognizer new];
    [tagGest.rac_gestureSignal subscribeNext:^(id x) {
        @strongify(self)
        [self.view endEditing:YES];
    }];
}


- (IBAction)seeRuleClick:(id)sender
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"注册协议" ofType:@"png"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AXWebViewController *webC = [[AXWebViewController alloc] initWithRequest:request];
    if (AX_WEB_VIEW_CONTROLLER_iOS9_0_AVAILABLE()) {
        webC.webView.allowsLinkPreview = YES;
    }
    webC.showsToolBar = NO;
    webC.showsBackgroundLabel = NO;
    
    webC.title = @"注册协议";
    [self.navigationController pushViewController:webC animated:YES];
}

- (IBAction)pawShowHiddenClick:(UIButton *)sender
{
    if (sender.tag == -1){
        [_showPawBtn setImage:KGetImage(@"icon_disappear") forState:UIControlStateNormal];
        _pwdTextFiled.secureTextEntry = YES;
    }
    else{
        
        [_showPawBtn setImage:KGetImage(@"icon_appear") forState:UIControlStateNormal];
        _pwdTextFiled.secureTextEntry = NO;
    }
    
    sender.tag *= -1;
}

@end
