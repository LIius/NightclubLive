//
//  ChangePawViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/6/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ChangePawViewController.h"
#import "RLLRequest.h"

@interface ChangePawViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldTF;
@property (weak, nonatomic) IBOutlet UITextField *nPawTF;
@property (weak, nonatomic) IBOutlet UITextField *againNPawTF;

@end

@implementation ChangePawViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)okClick:(id)sender {
    
    [self.view endEditing:YES];
    
    //先检查有没有输入空
    NSString *error;
    if (!(_oldTF.text.length >= 6 && _oldTF.text.length <= 20)){
        error = @"请输入正确的旧密码";
    }
    else if (!(_nPawTF.text.length >= 6 && _nPawTF.text.length <= 20)){
        
        error = @"请输入正确的新密码";
    }
    else if (![_againNPawTF.text isEqualToString:_nPawTF.text]){
        error = @"两次输入的密码不一致";
    
    }
    
    if (error){
        ShowError(error);
        return;
    }
    
    // 无误正确
    //userId, passWord,newPassWord,phoneNum
    ChangePawRequest *r = [ChangePawRequest new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (CurrentUser.userID.length >0) {
        [params setValue:CurrentUser.userID forKey:@"userId"];
    }
    if (_oldTF.text.length > 0) {
        [params setValue:_oldTF.text forKey:@"passWord"];
    }
    if (_nPawTF.text.length >0) {
        [params setValue:_nPawTF.text forKey:@"newPassWord"];
    }
    if (CurrentUser.user.phone_num.length > 0) {
        [params setValue:CurrentUser.user.phone_num forKey:@"phoneNum"];
    }
    
    r.param = params;

    [r startRequestWithCompleted:^(ResponseState *state) {
        
        if (state.isSuccess){
            ShowSuccess(@"密码修改成功");
            [CurrentUser changePawNeedLogin];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            ShowError(state.message);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
