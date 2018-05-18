//
//  ChangePwdVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/27.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "ChangePwdVC.h"
#import "ChangePwdViewModel.h"
#import "BaseTabBarController.h"
#import "LoginViewModel.h"
#import "LoginAndRegistRequest.h"


@interface ChangePwdVC ()

@property (nonatomic, strong) ChangePwdViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UITextField *tnewPwdTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *surePwdTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

@implementation ChangePwdVC
@dynamic viewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self)
    
    RAC(self.viewModel, newpwd) = self.tnewPwdTextFiled.rac_textSignal;
    RAC(self.viewModel, surePwd) = self.surePwdTextFiled.rac_textSignal;
    RAC(self.doneBtn, tag) = self.viewModel.doneEnableSignal;

    [[self.doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *btn) {
        @strongify(self)
        
        [self.view endEditing:YES];
        if (btn.tag==1) {
            [self.view makeToast:@"请输入正确的新密码和确认密码" duration:1 position:CSToastPositionCenter];
        }
        else if (btn.tag==666){
            [self.viewModel.reuqesChangePwdCommand execute:nil];
            
            UserResetRequest *request = [UserResetRequest new];
            NSString *phone = [self.viewModel.params stringForKey:@"phone"];
            NSString *code  = [self.viewModel.params stringForKey:@"code"];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if (phone.length >0) {
                [params setValue:phone forKey:@"phonenum"];
            }
            if (_surePwdTextFiled.text.length > 0) {
                [params setValue:_surePwdTextFiled.text forKey:@"password"];
            }
            
            if (code.length > 0) {
                [params setValue:code forKey:@"verifyCode"];
            }
            
            request.param = params;
     
            [request startRequestWithCompleted:^(ResponseState *state) {
                if (state.isSuccess){
                    [CurrentUser loginOut];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    ShowError(@"修改成功");
                }
                else{
                    ShowError(state.message);
                }
            }];

        }
        
    }];
 
}

@end
