//
//  FindFriendViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/10.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "FindFriendViewController.h"
#import "FindFriendCell.h"
#import "FindUserInfoViewController.h"
#import "NewFriendTableViewController.h"
#import "ChatRequest.h"
#import "User.h"
#import "UIBarButtonItem+Badge.h"
#import "UIAlertController+Factory.h"

@interface FindFriendViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
UIScrollViewDelegate
>

@property (weak, nonatomic) IBOutlet UIView *searchBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIButton *friendBtn;

@end

@implementation FindFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _friendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [_friendBtn setTitle:@"新好友" forState:UIControlStateNormal];
    [_friendBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_friendBtn addTarget:self action:@selector(newFriendClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *newItem = [[UIBarButtonItem alloc] initWithCustomView:_friendBtn];
    
    self.navigationItem.rightBarButtonItem = newItem;
    self.currentPage = 1;
    self.refreshView = self.tableView;
    self.isFoot = YES;
    
    self.isShowEmpty = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //获取标志小红点
    NIMSystemNotificationFilter *filter = [NIMSystemNotificationFilter new];
    filter.notificationTypes = @[@5];
    NSInteger count = [[[NIMSDK sharedSDK] systemNotificationManager] allUnreadCount:filter];
    
    UIBarButtonItem *item = self.navigationItem.rightBarButtonItem;
    if (count > 0){
        item.badgeValue = @" ";
        item.badgeFont = [UIFont systemFontOfSize:0.5];
        item.badgeBGColor = [UIColor redColor];
        item.badge.width = 8;
        item.badge.height = 8;
        item.badge.y += 7;
        item.badge.x += item.width + 5;
        item.badge.layer.cornerRadius = 4;
    }
    else{
        item.badgeValue = nil;
    }
    
}


#pragma mark - UITable View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *FindFriendCellReuseID = @"FindFriendCell";
    
    FindFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:FindFriendCellReuseID];
    if (!cell)
    {
        cell = [[FindFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FindFriendCellReuseID];
    }
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 69;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return TABLE_HEAD_FOOT_SPACE;
}
#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DataUser *m = self.dataSource[indexPath.row];
    
    
    if ([m.ID isEqualToString:[UserInfo shareUser].userID]){
        
        [self presentViewController:[UIAlertController alertControllerWithTitle:@"提示" withMessage:@"不能对自己进行操作" calk:nil] animated:YES completion:nil];
        
        return;
    }
    
    //跳转到用户资料显示界面
    FindUserInfoViewController *infoVC = [FindUserInfoViewController initSBWithSBName:@"FindUserInfoSB"];
    
    infoVC.model = m;
    
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self findFriendClick:nil];
    
    return [textField resignFirstResponder];
}

#pragma mark - Private Method

- (IBAction)findFriendClick:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.searchTF.text.length == 0){
        
        [self.view makeToast:@"请输入关键词" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    
    self.pageNow = 1;
    [self.dataSource removeAllObjects];
    [self refreshMethod];
    
}



- (IBAction)newFriendClick:(id)sender
{
    NewFriendTableViewController *nVC = [NewFriendTableViewController initSBWithSBName:@"NewFriendSB"];
    
    [self.navigationController pushViewController:nVC animated:YES];
}

- (void)refreshMethod
{
    //搜索
    FindUserRequest *r = [FindUserRequest new];
    r.searchValue = self.searchTF.text;
    r.pageNow = self.pageNow;
    [r startRequestWithCompleted:^(ResponseState *state) {
        self.parses = [DataUser arrayObjectWithDS:state.data];
        //self.isShowEmpty = YES;
        if (self.dataSource.count == 0){//提示空
            
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"该用户不存在" withMessage:@"请检查你输入的账号是否正确" calk:^(id param) {
            }];
            [self presentViewController:ac animated:YES completion:nil];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
