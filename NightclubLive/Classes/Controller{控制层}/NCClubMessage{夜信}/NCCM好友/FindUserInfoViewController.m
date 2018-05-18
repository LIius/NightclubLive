//
//  FindUserInfoViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/10.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "FindUserInfoViewController.h"
#import "WBAlertView.h"
#import "AddFriendView.h"
#import "UIBarButtonItem+Badge.h"
#import "LimitInput.h"
#import "UIAlertController+Factory.h"
@interface FindUserInfoViewController ()

/** 名称 */
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
/** 用户头像 */
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (weak, nonatomic) IBOutlet UIButton *chatBtn;
@property (weak, nonatomic) IBOutlet UILabel *idLab;
@end

@implementation FindUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DataUser *m = self.model;
    _nameLab.text = m.userName;
    _idLab.text = [NSString stringWithFormat:@"ID:%@",m.phoneNum];
    [_logoIV sd_setImageWithURL:m.profilePhoto placeholderImage:[UIImage userPlaceholder]];
    
    BOOL isFriend =  [[[NIMSDK sharedSDK] userManager] isMyFriend:m.phoneNum];
    
    if (isFriend){
        
        _addBtn.hidden = YES;
        [_chatBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).with.offset(-30.5);
            make.height.mas_equalTo(43);
        }];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Click

- (IBAction)chatClick:(id)sender {
    
    DataUser *m = self.model;
    
    NIMSession *session = [NIMSession session:m.phoneNum type:NIMSessionTypeP2P];
    
    NIMSessionViewController *chatVC = [[NIMSessionViewController alloc] initWithSession:session];
    
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (IBAction)addFriendClick:(id)sender {
    
   // AddFriendView *contentView = [AddFriendView initFromXIB];
    
    DataUser *m = self.model;
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"发送验证申请" okBlock:^(id param) {
        
        NIMUserRequest *r = [NIMUserRequest new];
        r.userId = m.phoneNum;
        r.operation = NIMUserOperationRequest;
        r.message = param;
        
        [[[NIMSDK sharedSDK] userManager] requestFriend:r completion:^(NSError * _Nullable error) {
            
            NSString *title = error ? @"发送验证失败" : @"发送验证成功";
            
            [self.view makeToast:title duration:1.0 position:CSToastPositionCenter];
        }];
        
    }];
    
    UITextField *tf = ac.textFields.firstObject;
    [tf setValue:@20 forKey:@"limit"];
    
    [self presentViewController:ac animated:YES completion:nil];
    
    /*WBAlertView *alertView = [WBAlertView alertTitle:@"发送验证申请" contentView:contentView];
    
    alertView.okBlock = ^(id value){
        


    };
    
    [alertView showView:self.view];*/
}



@end
