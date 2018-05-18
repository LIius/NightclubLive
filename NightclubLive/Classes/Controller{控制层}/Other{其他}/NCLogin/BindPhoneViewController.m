//
//  BindPhoneViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/3/29.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "LoginAndRegistRequest.h"
#import "ThirdLoginModel.h"
#import "RLLRequest.h"



@interface BindPhoneViewController ()

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;

@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
}

#pragma mark - Button Click

- (IBAction)sendCodeClick:(id)sender {
    
    [self.view endEditing:YES];
    
    if (_phoneTF.text.length == 0){
        ShowError(@"请输入手机号码");
        return;
    }
    
    GetCodeRequest *r = [GetCodeRequest new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_phoneTF.text.length >0) {
        [params setValue:_phoneTF.text forKey:@"phonenum"];
    }
    
    [params setValue:@(5) forKey:@"type"];
    
    r.param = params;

    [r startRequestWithCompleted:^(ResponseState *state) {
        
        if (state.responseCode == 3){
            
            [_sendBtn startWithTime:60 title:@"获取验证码" countDownTitle:@"秒" mainColor:[UIColor clearColor] countColor:[UIColor clearColor]];
        }
        
        [self.view makeToast:state.message duration:1.0 position:CSToastPositionCenter];
    }];
}

- (IBAction)bindClick:(id)sender
{
    [self.view endEditing:YES];
    
    if (![_phoneTF.text isPhoneNum]){
        ShowSuccess(@"请输入正确的手机号码");
        return;
    }
    
    ThirdLoginModel *m = self.model;
    
    BindPhoneRequest *r = [BindPhoneRequest new];
    NSArray *typeArray = @[@"",@"weixin_uid",@"qq_uid",@"weibo_uid"];
    NSString *key = [typeArray stringAtIndex:m.loginType];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (m.userName.length >0) {
        [params setValue:m.userName forKey:@"userName"];
    }
    if (_phoneTF.text.length > 0) {
        [params setValue:_phoneTF.text forKey:@"phoneNum"];
    }
    if (m.sex) {
        [params setValue:@(m.sex) forKey:@"sex"];
    }
    if (m.userImg.length > 0) {
        [params setValue:m.userImg forKey:@"profilePhoto"];
    }
    
    [params setValue:@(0) forKey:@"appUserRole"];
    
    
    if (_codeTF.text.length > 0) {
        [params setValue:_codeTF.text forKey:@"verifyCode"];
    }
    
    if (_loginType) {
        [params setValue:@(_loginType) forKey:@"from_user"];
    }
    
    if (m.uid.length >0) {
        [params setValue:m.uid forKey:key];
    }
    r.param = params;

    [r startRequestWithCompleted:^(ResponseState *state) {
        
        if (state.isSuccess){
            //进行登录
            
            SignOnRequest *r = [SignOnRequest new];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if (m.uid.length >0) {
                [params setValue:m.uid forKey:key];
            }
            r.param = params;
            //r.param = @{key:m.uid};
            [r startRequestWithCompleted:^(ResponseState *state) {
                
                ShowSuccess(@"绑定成功");
                if (state.isSuccess){
                    [CurrentUser loginWithCompletion:^(ResponseState *state) {
                        if (state.isSuccess){

                            [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
                        }
                        else{
                            ShowError(@"绑定失败");
                        }
                    }];
                }
            }];
        }
        else{
            ShowError(@"绑定失败");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

@end
