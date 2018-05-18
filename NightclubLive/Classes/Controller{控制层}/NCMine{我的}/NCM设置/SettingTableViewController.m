//
//  SettingTableViewController.m
//  NightclubLive
//
//  Created by SuperDanny on 2016/12/8.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "SettingTableViewController.h"
#import "SystemTool.h"
#import "ScottAlertController.h"
#import "SuggestView.h"
#import "MineRequest.h"
#import "GlobalRequest.h"
#import "BlocksKit+UIKit.h"
@interface SettingTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *phoneNubLabel;
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;

@end

@implementation SettingTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLogoutBtn];
    [self setupCacheLabel];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    if (section == 0)
    {
        // 账号与安全
        [self.navigationController pushViewController:ViewController(@"ChangePwdSB", @"ChangePawViewController") animated:YES];
    } else if (section == 1)
    {
        if (row == 0)
        {
            // 拨打电话
            [self goCallPhone];
            
        }else if (row == 2)
        {
            // 意见反馈
            [self goSuggestVC];
        }
        
    } else if (section == 2) {
        
        if (row == 0)
        {
            PushViewController(ViewController(@"CheckVersionSB", @"CheckVersionViewController"));
        }
        else if (row == 1)
        {
            // 评价我们
            [self goEvaluateUS];
        } else if (row == 2)
        {
            [self goClearCache];
        }
    }
}

#pragma mark - 评价我们
- (void)goEvaluateUS
{
    NSString *urlStrig = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id/%@",APPStoreID];
    [[UIApplication sharedApplication] openURL:URL(urlStrig)];
}

#pragma mark - 清除缓存
- (void)goClearCache
{
    // 清除缓存
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"是否清除缓存？" preferredStyle:UIAlertControllerStyleAlert];
    @weakify(self);
    [alert addAction:[UIAlertAction actionWithTitle:@"清除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 清除缓存
        [SystemTool clearCacheWithCompletion:^{
            @strongify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.cacheLabel.text = @"0KB";
                ShowSuccess(@"清除成功");
            });
            
        }];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 意见反馈
- (void)goSuggestVC
{
    SuggestView *sugv = [SuggestView initFromXIB];
    CGFloat width = SCREEN_WIDTH * 0.8;
    CGFloat height = width * 0.8;
    CGFloat x = (SCREEN_WIDTH - width) * .5;
    CGFloat y = (SCREEN_HEIGHT - height) * 0.5;
    sugv.frame = CGRectMake(x, y, width, 316);
    sugv.submitBlock = ^(NSString *param) {
        
        if (param.length == 0){
            ShowError(@"请填写反馈内容");
            return;
        }
        
        SuggestRequest *r = [SuggestRequest new];
        r.model = param;
        [r startRequestWithCompleted:^(ResponseState *state) {
            NSString *msg = nil;
            if (state.isSuccess){
                msg = @"反馈成功";
            }
            else{
                msg = @"反馈失败";
            }
            
            ShowError(msg);
        }];
    };
    
    ScottAlertViewController *savc = [ScottAlertViewController alertControllerWithAlertView:sugv preferredStyle:ScottAlertControllerStyleAlert];
    savc.tapBackgroundDismissEnable = YES;
    
    [self presentViewController:savc animated:YES completion:nil];
}

#pragma mark - 拨打客服电话
- (void)goCallPhone
{
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",_phoneNubLabel.text]];
    [[UIApplication sharedApplication] openURL:telURL];
}

#pragma mark - 设置缓存信息
- (void)setupCacheLabel
{
    @weakify(self);
    // 获取缓存
    [SystemTool getFileSizeWithCompletion:^(NSString * sizeStr)
     {
         @strongify(self);
         dispatch_async(dispatch_get_main_queue(), ^{
             self.cacheLabel.text = sizeStr;
         });
         
     }];
}

#pragma mark - 创建退出登录按钮
- (void)setupLogoutBtn
{
    UIButton *btn = [UIButton new];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_提交"] forState:UIControlStateNormal];
    [btn setTitle:@"退出登录" forState:UIControlStateNormal];
    [btn bk_addEventHandler:^(id sender) {
        
        [[UserInfo shareUser] loginOut];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(37);
        (void)make.centerX;
        make.bottom.offset(kScreenHeight-64-15);
        make.height.offset(44);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
