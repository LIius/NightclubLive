//
//  NCLoginVC.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/8.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NCLoginVC.h"
#import "ForgetPwdVC.h"
#import "RegisterVC.h"
#import "BindPhoneViewController.h"

#import "ForgetPwdViewModel.h"
#import "LoginViewModel.h"
#import "ThirdLoginModel.h"
#import "RegisterViewModel.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

@interface NCLoginVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherLoginH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerViewH;

@property (weak, nonatomic) IBOutlet UIView *pwdView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIButton *keepBtn;
@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UILabel *phonePlaceHolderLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdPlaceHolderLabel;


@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextFiled;

@property (nonatomic, strong) LoginViewModel *loginViewModel;

@end

@implementation NCLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 如果账号存在就加载
    NSString *name = CurrentUser.lgPhone;
    self.phoneTextFiled.text = name;
    [self resetTextfield:self.phoneTextFiled];

    [UIView cornerWithView:self.pwdView radius:5];
    [UIView cornerWithView:self.phoneView radius:5];
    
    // 登录请求
    [self.loginViewModel.reuqesLoginCommand.executing subscribeNext:^(NSNumber *executing) {
        
    }];
    
    // 忘记密码
    [[_forgetPwdBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ForgetPwdVC *vc = [ForgetPwdVC controllerWithViewModel:[[ForgetPwdViewModel alloc] initWithParams:nil] andSbName:@"ForgetPwdSB"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    // 立即注册
    [[_registerBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        RegisterVC *vc = [RegisterVC controllerWithViewModel:[[RegisterViewModel alloc] initWithParams:nil] andSbName:@"RegisterAndLogin"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    CloseLoading;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (iPhone5 || iPhone4) {
        [self.otherLoginH setConstant:40];
        [self.phoneViewH setConstant:20];
        [self.logoViewH setConstant:50];
    }else if(iPhoneX){
        [self.otherLoginH setConstant:132];
        [self.logoViewH setConstant:86];
        [self.phoneViewH setConstant:84];
        [self.registerViewH setConstant:60];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextField代理
- (void)textFieldDidChange:(NSNotification *)info
{
    UITextField *textField = info.object;
    [self resetTextfield:textField];
}

- (void)resetTextfield:(UITextField *)textField{
    if (textField.tag==51) {
        // 手机号码
        if (textField.text.length>0){
            self.phonePlaceHolderLabel.text=@"";
            self.cleanBtn.hidden = NO;
        }else{
            self.phonePlaceHolderLabel.text=@"请输入手机号码";
            self.cleanBtn.hidden = YES;
        }
    }else{
        if (textField.text.length>0){
            self.pwdPlaceHolderLabel.text=@"";
        }else{
            self.pwdPlaceHolderLabel.text=@"请输入密码";
        }
    }
}


- (IBAction)login:(id)sender {
    ShowLoading
    NSString *error = nil;
    
    [self.view endEditing:YES];
    
    if (![CheckTools isValidateMobileNumber:_phoneTextFiled.text]){
        error = @"请输入正确的账号";
    }
    else if (![CheckTools isCheckPassword:_pwdTextFiled.text]){
        error = @"请输入正确的密码";
    }
    
    if (error){
        CloseLoading
        ShowError(error);
        return;
    }
    
    CurrentUser.thirdUID = nil;
    [UserInfo shareUser].lgPaw = _pwdTextFiled.text;
    [UserInfo shareUser].lgPhone = _phoneTextFiled.text;
    [[UserInfo shareUser] loginWithCompletion:^(ResponseState *state) {
        
        CloseLoading
        if (state.isSuccess){
            DimssVC
        }
    }];
}

- (IBAction)thirdPartyLogin:(UIButton *)sender {
    NSInteger tag = sender.tag;
    [self loginSDKWithType:tag];
}

#pragma mark - 绑定第三方登录
- (void)loginSDKWithType:(SSDKPlatformType)type
{
    [WBLoadingHUD show];
    
    CurrentUser.lgPhone = nil;
    CurrentUser.lgPaw = nil;
    
    [ShareSDK getUserInfo:type onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         [WBLoadingHUD close];
         
         NSInteger loginType = (type == SSDKPlatformTypeSinaWeibo ? 3 : (type == SSDKPlatformTypeQQ ? 2 : 1));
         if (state == SSDKResponseStateSuccess)
         {
             NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:user.rawData];
             if (user.uid) {
                 [param setValue:user.uid forKey:@"uid"];
             }
             
             ThirdLoginModel *m = [[ThirdLoginModel alloc] init];
             m.loginType = loginType;
             m.optional  = param;
             CurrentUser.thirdType = loginType;
             [UserInfo shareUser].thirdUID = user.uid;
             
             ShowLoading
             [[UserInfo shareUser] loginWithCompletion:^(ResponseState *state) {
                 
                 CloseLoading
                 // 未进行手机号码绑定
                 if (state.responseCode == 3)
                 {
                     BindPhoneViewController *bindVC = [BindPhoneViewController initSBWithSBName:@"BindPhoneSB"];
                     
                     bindVC.model = m;
                     PushViewController(bindVC);
                 }
                 else if (state.responseCode == 0){
                     [self dismissViewControllerAnimated:YES completion:nil];
                 }
             }];
             
         }
         else{
             
             NSString *error = [NSString stringWithFormat:@"没有安装%@",[NSString stringFromeArray:@[@"未知软件",@"微信",@"QQ",@"微博"] index:loginType]];
             ShowError(error)
         }
     }];
    
}

- (IBAction)seePwd:(UIButton *)sender {
    if (sender.tag == -1){
        [_keepBtn setImage:KGetImage(@"icon_eyeclose") forState:UIControlStateNormal];
        _pwdTextFiled.secureTextEntry = YES;
    }
    else{
        
        [_keepBtn setImage:KGetImage(@"icon_eyeopen") forState:UIControlStateNormal];
        _pwdTextFiled.secureTextEntry = NO;
    }
    
    sender.tag *= -1;
}

- (IBAction)cleanPhone:(id)sender {
    self.phoneTextFiled.text = @"";
    [self resetTextfield:self.phoneTextFiled];
}

@end
