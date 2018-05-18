//
//  BlacklistViewController.m
//  NightclubLive
//
//  Created by SuperDanny on 2017/1/19.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "BlacklistViewController.h"
#import "BlacklistCell.h"
#import "EmptyMiniView.h"
#import "NIMKit.h"

@interface BlacklistViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BlacklistViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.tableFooterView = [UIView new];
    self.refreshView = _tableView;
    
    [self setupBlackList];
}

- (void)setupBlackList
{
    self.data = @[].mutableCopy;
    NSMutableArray *array = @[].mutableCopy;
    for (NIMUser *user in [NIMSDK sharedSDK].userManager.myBlackList)
    {
        [array addObject:user.userId];
    }
    
    @weakify(self);
    ShowLoading;
    [[NIMSDK sharedSDK].userManager fetchUserInfos:array completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error)
     {
         @strongify(self);
         DLog(@"%ld",users.count);
         dispatch_async(dispatch_get_main_queue(), ^{
             
             for (NIMUser *mUser in users) {
                 
                 [self.data addObject:mUser];
                 [self.tableView reloadData];
                 DLog(@"userId=%@---%@",mUser.userInfo.avatarUrl,mUser.userInfo.nickName);
             }
             
             if (users.count == 0) {
                 
                 UIView *view = [EmptyMiniView viewWithTip:@"小黑屋没有人哦~"];
                 view.center = self.view.center;
                 [self.view addSubview:view];
             }
             
             CloseLoading;
         });
         
     }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlacklistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (!cell)
    {
        cell = [[BlacklistCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.nUserModel = self.data[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [BlacklistCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NIMUser *model =  self.data[indexPath.row];
    NSString *messageStr = [NSString stringWithFormat:@"\n是否将 %@ 移出黑名单",model.userInfo.nickName];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:messageStr];
    [attr addAttribute:NSForegroundColorAttributeName value:UIColorHex(0x98999a) range:NSMakeRange(0, messageStr.length)];
    [attr addAttribute:NSForegroundColorAttributeName value:UIColorHex(0xca52a1) range:NSMakeRange(@"是否将".length+1, model.userInfo.nickName.length + 2)];
    
    DDAlertController *alert = [DDAlertController alertControllerWithTitle:@"提示" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    alert.titleColor = UIColorHex(0x323334);
    alert.messageAtt = attr;

    DDAlertAction *action1 = [DDAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    action1.textColor = UIColorHex(0x656667);
    [alert addAction:action1];
    
    @weakify(self);
    DDAlertAction *action = [DDAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        NIMUser *user =  self.data[indexPath.row];
        
        [[[NIMSDK sharedSDK] userManager] removeFromBlackBlackList:user.userId completion:^(NSError * _Nullable error)
        {
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^
            {
                if (!error){
                    
                    [self.data removeObjectAtIndex:indexPath.row];
                    
                    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                    [self.tableView deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
                    //[self.tableView reloadInMain];
                }else{
                    
                    [self.view makeToast:@"移除黑名单失败" duration:1.0 position:CSToastPositionCenter];
                }
            });
            
            
        }];
        
    }];
    
    action.textColor = UIColorHex(0xca52a1);
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
