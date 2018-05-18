//
//  LoginVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/12.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "LoginVC.h"
#import "BaseTabBarController.h"
#import "RegisterVC.h"
#import "LoginViewModel.h"
#import "RegisterViewModel.h"

#import "ForgetPwdVC.h"
#import "ForgetPwdViewModel.h"
#import "FolkLoginViewModel.h"
#import "UserInfo.h"
#import "User.h"
#import "UserDetailRequest.h"
#import "BindPhoneViewController.h"
#import "RLLRequest.h"
#import "BindPhoneViewController.h"
#import "ThirdLoginModel.h"
//第三方SDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

NSString * const pushRegistSegueID = @"pushRegistSegueID";


@interface LoginVC ()

@property (weak, nonatomic) IBOutlet UIView *textContentView;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (nonatomic, strong) LoginViewModel *viewModel;
@property (nonatomic, strong) FolkLoginViewModel *flViewModel;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiboLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *weichatLogin;
@property (weak, nonatomic) IBOutlet UIButton *qqLogin;

@property (weak, nonatomic) IBOutlet UIButton *keepBtn;

// 约束

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneContentViewCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pwdCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons7;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons8;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons9;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons10;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons11;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons12;

@end

@implementation LoginVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (iPhone4||iPhone5) {
        _cons3.constant = _cons3.constant*SCREEN_H_POINT;
        _cons4.constant = _cons4.constant*SCREEN_H_POINT;
        _phoneContentViewCons.constant = _phoneContentViewCons.constant*SCREEN_H_POINT;
        _phoneCons.constant = _phoneCons.constant*SCREEN_H_POINT;
        _pwdCons.constant = _pwdCons.constant*SCREEN_H_POINT;
        _cons1.constant = _cons1.constant*SCREEN_H_POINT;
        _cons2.constant = _cons2.constant*SCREEN_H_POINT;
        _cons5.constant = _cons5.constant*SCREEN_H_POINT;
        _cons6.constant = _cons6.constant*SCREEN_H_POINT;
        _cons7.constant = _cons7.constant*SCREEN_H_POINT;
        _cons8.constant = _cons8.constant*SCREEN_H_POINT;
        _cons9.constant = _cons9.constant*SCREEN_H_POINT;
        _cons10.constant = _cons10.constant*SCREEN_H_POINT;
        _cons11.constant = _cons11.constant*SCREEN_H_POINT;
        _cons12.constant = _cons12.constant*SCREEN_H_POINT;
    }

    self.textContentView.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    self.textContentView.layer.borderWidth =  0.5;
    self.textContentView.layer.cornerRadius = 5;
    [self.viewModel.reuqesLoginCommand.executing subscribeNext:^(NSNumber *executing) {
        if (executing.boolValue) {
          //  [SVProgressHUD show];
        } else {
           // [SVProgressHUD dismiss];
        }
    }];
    
    // 忘记密码
    [[_forgetPwdBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        ForgetPwdVC *vc = [ForgetPwdVC controllerWithViewModel:[[ForgetPwdViewModel alloc] initWithParams:nil] andSbName:@"ForgetPwdSB"];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    // 如果账号存在就加载
    NSString *name = CurrentUser.lgPhone;
    _phoneTextFiled.text = name;
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    CloseLoading;
}

- (IBAction)loginClick:(id)sender
{
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

#pragma mark - Getter
- (FolkLoginViewModel *)flViewModel{
    
    if (!_flViewModel){
        
        _flViewModel = [FolkLoginViewModel new];
    }
    
    return _flViewModel;
}

#pragma mark - storyboaed-segue跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:pushRegistSegueID]) {
        RegisterVC *registVC = (RegisterVC *)segue.destinationViewController;
        registVC.viewModel = [[RegisterViewModel alloc] initWithParams:nil];
    }
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

#pragma mark - Button Click
- (IBAction)thirdPartyClick:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    [self loginSDKWithType:tag];
}

- (IBAction)backClick:(id)sender
{
    DimssVC
}

- (IBAction)pawAppearClick:(UIButton *)sender {
    
    if (sender.tag == -1){
        [_keepBtn setImage:KGetImage(@"icon_disappear") forState:UIControlStateNormal];
        _pwdTextFiled.secureTextEntry = YES;
    }
    else{
        
        [_keepBtn setImage:KGetImage(@"icon_appear") forState:UIControlStateNormal];
        _pwdTextFiled.secureTextEntry = NO;
    }
    
    sender.tag *= -1;
}



@end
