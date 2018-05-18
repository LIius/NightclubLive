//
//  AddressBookViewController.m
//  NightclubLive
//
//  Created by SuperDanny on 2017/1/17.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AddressBookViewController.h"
#import "AddressBookCell.h"
#import "AddressBookHeaderView.h"
#import "AddressBookTool.h"
#import "MyFriendInfoViewController.h"

#import "AddressBookCellSectionOne.h"

@interface AddressBookViewController ()
<
UIScrollViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 头部view */
@property (nonatomic, copy) NSArray *headViews;
/** 好友列表 */
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSArray *searchFriends;
/** 通讯列表 */
@property (nonatomic, strong) NSArray *addressBooks;
@property (nonatomic, strong) NSArray *searchAddressBooks;
@property (nonatomic, strong) NSMutableArray *selectPhone;
/** cell 勾选状态 */
@property (nonatomic, strong) NSMutableDictionary *checkStatues;

/** 短信对象 */
@property (nonatomic, strong) AddressBookTool *addressBookTool;

@property (strong, nonatomic) NSMutableArray <NSNumber *> *statusArr;
@property (weak, nonatomic) IBOutlet UITextField *searchTextfield;

@end

@implementation AddressBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _statusArr = @[@0, @0].mutableCopy;
    _checkStatues = [NSMutableDictionary dictionary];
    _searchAddressBooks = [NSMutableArray array];
    _searchFriends = [NSMutableArray array];
    _selectPhone = [NSMutableArray array];

    [self setupTabelView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setupTabelView
{
    // 创建头部
    AddressBookHeaderView *myFriendNiew = [[AddressBookHeaderView alloc] initWithTitle:@"我的好友" status:NO];
    AddressBookHeaderView *addressBookView = [[AddressBookHeaderView alloc] initWithTitle:@"手机通讯录" status:NO];
    _headViews = @[myFriendNiew,addressBookView];
    
    // 获取通讯好友
    _addressBooks =  [[AddressBookTool new] getAddressBooks];
    _friends = [[NIMSDK sharedSDK].userManager myFriends];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressBookCell" bundle:nil] forCellReuseIdentifier:@"AddressBookCell"];
     //[self.tableView registerNib:[UINib nibWithNibName:@"AddressBookCell" bundle:nil] forCellReuseIdentifier:@"AddressBookCell"];
    //[self.tableView registerNib:[UINib nibWithNibName:@"AddressBookCellSectionOne" bundle:nil] forCellReuseIdentifier:@"AddressBookCellSectionOne"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressBookCellSectionOne" bundle:nil] forCellReuseIdentifier:@"AddressBookCellSectionOne"];
    
    [self.tableView reloadInMain];
}

#pragma mark - UITextField代理
- (void)textFieldDidChange:(NSNotification *)info
{
    UITextField *textField = info.object;
    
    self.searchTextfield.text = textField.text;
   
    // 先取消调用搜索方法
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(searchResult) object:nil];
    // 0.5秒后调用搜索方法
    [self performSelector:@selector(searchResult) withObject:nil afterDelay:0.5];
}

- (void)searchResult
{
    // 进行搜索
    NSMutableArray *temps = [NSMutableArray array];
    // 搜索好友
    for (NIMUser *user in _friends)
    {
        BOOL alias = [user.alias containsString:self.searchTextfield.text];
        BOOL nickName = [user.userInfo.nickName containsString:self.searchTextfield.text];
        
        if (alias || nickName){
            [temps addObject:user];
        }
    }
    _searchFriends = [temps copy];
    
    
    NSMutableArray *temps2 = [NSMutableArray array];
    // 搜索通讯录
    for (AddressBookModel *m in _addressBooks)
    {
        BOOL rang = [m.name containsString:self.searchTextfield.text];
        
        if (rang)
        {
            [temps2 addObject:m];
        }
    }
    _searchAddressBooks = [temps2 copy];
    
    [self.tableView reloadInMain];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchTextfield.text.length == 0)
    {
        if (_statusArr[section].boolValue)
        {
            if (section == 0)
            {
                return _friends.count;
            }
            else{
                return _addressBooks.count;
            }
        }
    }else
    {
        if (section == 0)
        {
            return _searchFriends.count;
        }
        else{
            return _searchAddressBooks.count;
        }
    }
   
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        // 这里需使用这个这个方法，会从xib加载cell
        AddressBookCellSectionOne *cell = (AddressBookCellSectionOne *)[AddressBookCellSectionOne dequeueReusableWithTableView:tableView];

        if (self.searchTextfield.text.length == 0)
        {
            cell.userModel =  _friends[indexPath.row] ;
        }else{
            cell.userModel =  _searchFriends[indexPath.row]  ;
        }
  
        return cell;
    }else{
        // 这里需使用这个这个方法，会从xib加载cell
        AddressBookCell *cell = (AddressBookCell *)[AddressBookCell dequeueReusableWithTableView:tableView];
  
        if (self.searchTextfield.text.length == 0)
        {
            cell.addressModel =   _addressBooks[indexPath.row] ;
        }else{
            cell.addressModel =   _searchAddressBooks[indexPath.row] ;
        }

        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 0.1;
    }
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    @weakify(self);
    AddressBookHeaderView *view = _headViews[section];
    view.inviteBtn.hidden = section == 0;
    [view setSelectBlock:^(BOOL isOpen)
    {
        // 点击我的好友或者手机通讯录
        @strongify(self);
        [self.statusArr replaceObjectAtIndex:section withObject:@(isOpen)];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    // 添加邀请事件
    view.invitionBlock = ^(id param)
    {
        // 寻找勾选的
        NSMutableArray *phones = [NSMutableArray array];

        for (NSString *phone in [_checkStatues allKeys])
        {
            if (phone) {
                [phones addObject:phone];
            }
        }
        
        NSString *sendMsg = [NSString stringWithFormat:@"我的夜店网邀请码为%@，一起加入夜店网吧：http://www.yd2019.cn",CurrentUser.user.userInvitationCode];
        
        _addressBookTool = [[AddressBookTool alloc] init];
        [_addressBookTool sendMessage:[phones copy] content:sendMsg calkBlock:^(id param) {
            
        }];

    };
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [AddressBookCellSectionOne cellHeight];
    }
    return [AddressBookCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        // 进入聊天界面
        NIMUser *user = _friends[indexPath.row];
        
        /*NIMSession *session = [NIMSession session:user.userId type:NIMSessionTypeP2P];
         NIMSessionViewController *chatVC = [[NIMSessionViewController alloc] initWithSession:session];*/
        MyFriendInfoViewController *vc = [MyFriendInfoViewController initSBWithSBName:@"MyFriendInfoSB"];
        vc.model = user;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        return;
    }else if (indexPath.section == 1)
    {
        AddressBookCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSString *key = cell.addressModel.phoneNum;
        if ([cell.addressModel.isChoose boolValue]) {
            [_checkStatues removeObjectForKey:key];
            DLog(@"[移除=%@",key);
        }else{
            [_checkStatues setValue:cell.addressModel.name forKey:key];
            DLog(@"[加入=%@",key);
        }

        cell.addressModel.isChoose = [cell.addressModel.isChoose boolValue]?@0:@1;

        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
