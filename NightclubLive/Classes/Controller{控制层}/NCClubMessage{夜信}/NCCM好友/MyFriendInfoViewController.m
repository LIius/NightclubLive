//
//  MyFriendInfoViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MyFriendInfoViewController.h"
#import "NTESSessionViewController.h"

@interface MyFriendInfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UIButton *blackBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation MyFriendInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NIMUser *m = self.model;
    _nameLabel.text = m.userInfo.nickName ? m.userInfo.nickName : m.alias;
    _idLabel.text = [NSString stringWithFormat:@"ID:%@",m.userId];
    [_logoIV sd_setImageWithURL:URL(m.userInfo.avatarUrl) placeholderImage:[UIImage userPlaceholder]];
    
  //  self.view.layer.masksToBounds
    _blackBtn.layer.borderColor = APPDefaultColor.CGColor;
    _blackBtn.layer.borderWidth = 0.5;
    
    _deleteBtn.layer.borderColor = APPDefaultColor.CGColor;
    _deleteBtn.layer.borderWidth = 0.5;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Click

- (IBAction)chatClick:(id)sender {
    
    NIMUser *m = self.model;
    
    NIMSession *session = [NIMSession session:m.userId type:NIMSessionTypeP2P];
    
    NTESSessionViewController *chatVC = [[NTESSessionViewController alloc] initWithSession:session];
    
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (IBAction)blackClick:(id)sender {
    
    NIMUser *m = self.model;

    [[NIMSDK sharedSDK].userManager addToBlackList:m.userId completion:^(NSError * _Nullable error) {
    
        [SharedAppDelegate.window makeToast:error ? @"拉入黑名单失败" : @"拉入黑名单成功"  duration:1.0 position:CSToastPositionCenter];
        
        if (!error){
            
            [[NIMSDK sharedSDK].userManager deleteFriend:m.userId completion:^(NSError * _Nullable error) {
                
                [self.navigationController popViewControllerAnimated:YES];

            }];
        }
        
    }];
}

- (IBAction)deleteClick:(id)sender {
    
    NIMUser *m = self.model;
    
    [[NIMSDK sharedSDK].userManager deleteFriend:m.userId completion:^(NSError * _Nullable error) {
        
        
        [SharedAppDelegate.window makeToast:error ? @"删除好友失败" : @"删除好友成功" duration:1.0 position:CSToastPositionCenter];
        
        if (!error){
            
            [self.navigationController popViewControllerAnimated:YES];
        }

    }];
}


@end
