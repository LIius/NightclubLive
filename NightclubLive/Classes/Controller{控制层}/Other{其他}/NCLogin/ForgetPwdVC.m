//
//  ForgetPwdVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/27.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "ForgetPwdVC.h"
#import "ForgetPwdViewModel.h"
#import "ChangePwdVC.h"
#import "ChangePwdViewModel.h"
#import "LoginAndRegistRequest.h"

@interface ForgetPwdVC ()

@property (nonatomic, strong) ForgetPwdViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UIButton *countdownBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

@end

@implementation ForgetPwdVC
@dynamic viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self)

    RAC(self.viewModel, phone) = self.phoneTextFiled.rac_textSignal;
    RAC(self.viewModel, code) = self.codeTextFiled.rac_textSignal;
    RAC(self.nextStepBtn, tag) = self.viewModel.nextEnableSignal;
    RAC(self.countdownBtn, tag) = self.viewModel.nextEnableSignal;

    [[self.countdownBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self)
        
        [self.view endEditing:YES];
        if (btn.tag==1)
        {
            [self.view makeToast:@"请输入正确手机号码" duration:1 position:CSToastPositionCenter];
        }else {

            [self.viewModel.reuqesCodeCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
                
            }];
            
            GetCodeRequest *request = [GetCodeRequest new];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if (self.phoneTextFiled.text.length >0) {
                [params setValue:self.phoneTextFiled.text forKey:@"phonenum"];
            }
            
            [params setValue:@2 forKey:@"type"];
            
            request.param = params;
         
            [request startRequestWithCompleted:^(ResponseState *state) {
                
                if (state.responseCode == 3){
                    ShowSuccess(state.message);
                    [_countdownBtn startWithTime:60 title:@"获取验证码" countDownTitle:@"s" mainColor:[UIColor whiteColor] countColor:[UIColor clearColor]];
                }
                else{
                    ShowSuccess(@"短信发送失败");
                }
            }];
        }
        
    }];
    
    [[self.nextStepBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self)
        
        [self.view endEditing:YES];
        if (self.phoneTextFiled.text.length != 11) {
            [self.view makeToast:@"请输入正确手机号码" duration:1 position:CSToastPositionCenter];
        }else if (self.codeTextFiled.text.length == 0){
            [self.view makeToast:@"请输入正确验证码" duration:1 position:CSToastPositionCenter];
        }else {
            ChangePwdVC *vc = [ChangePwdVC controllerWithViewModel:[[ChangePwdViewModel alloc] initWithParams:@{@"phone":self.phoneTextFiled.text,@"code":self.codeTextFiled.text}] andSbName:@"ChangePwdSB"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    [self.viewModel.reuqesCodeCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
        [self.view makeToast:x duration:1 position:CSToastPositionCenter];
        
    }];

}

@end
