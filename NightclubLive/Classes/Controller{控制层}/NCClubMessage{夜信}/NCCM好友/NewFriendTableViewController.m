//
//  NewFriendTableViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/10.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NewFriendTableViewController.h"
#import "NewFriendCell.h"
#import "EmptyBigView.h"

@interface NewFriendTableViewController ()
 @property(nonatomic,strong)UIView *emptyView;
@end

@implementation NewFriendTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getNotificaionList];

  //  self.isShowEmpty = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (void)getNotificaionList{
    
    //获取申请好友通知
    NIMSystemNotificationFilter *filter = [[NIMSystemNotificationFilter alloc] init];
    filter.notificationTypes  = @[@(NIMSystemNotificationTypeFriendAdd)];
    
    NSArray *requetN = [[[NIMSDK sharedSDK] systemNotificationManager] fetchSystemNotifications:nil limit:100 filter:filter];
    
    //去除重复
    NSMutableArray *temp = [NSMutableArray array];
    for (NIMSystemNotification *n1 in requetN){
        
        BOOL ishave = NO;
        
        for (NIMSystemNotification *n2 in temp){
            
            if ([n1.sourceID isEqualToString:n2.sourceID]){
                ishave = YES;
                break;
            }
        }
        
        if (!ishave)
            [temp addObject:n1];
    }
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:temp];
    //清除好友通知
    [[[NIMSDK sharedSDK] systemNotificationManager] markAllNotificationsAsRead:filter];
    
    [self.tableView reloadInMain];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

   
    
    if (self.dataSource.count == 0 )
    {
        if (!_emptyView)
        {
            UIView *v = [EmptyBigView viewWithTip:@"没有好友申请呢~"];
            v.frame = [NCEmpty getEmtpyViewRectWithScrollView:self.tableView];
            [self.view addSubview:v];
            _emptyView = v;
        }
        
    }else{
        if (_emptyView){
            [_emptyView removeFromSuperview];
        }
        
    }
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return TABLE_HEAD_FOOT_SPACE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @weakify(self);
    static NSString *NewFriendCellReuseID = @"NewFriendCell";
    
    NewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:NewFriendCellReuseID];
    if (!cell)
    {
        cell = [[NewFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewFriendCellReuseID];
    }
    cell.model = self.dataSource[indexPath.row];
    cell.indexPath = indexPath;
    
    cell.addBlock = ^(NSIndexPath *valueIndexPath){
        
        NIMSystemNotification *notificaiton = self.dataSource[valueIndexPath.row];
        
        //同意1.同意。2.向申请方发送通知消息
        //1.同意
        NIMUserRequest *r = [NIMUserRequest new];
        r.operation = NIMUserOperationVerify;
        r.userId = notificaiton.sourceID;
        [[[NIMSDK sharedSDK] userManager] requestFriend:r completion:^(NSError * _Nullable error) {
            @strongify(self);
            if (!error){
                
                //2.发送通知
                NIMMessage *message = [[NIMMessage alloc] init];
                message.text    = @"我们已经成功成为好友，可以开始聊天了";
                
                //构造会话
                NIMSession *session = [NIMSession session:notificaiton.sourceID type:NIMSessionTypeP2P];
                
                //发送消息
                [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:session error:nil];

                //刷新
                [self getNotificaionList];
                
               // [self.tableView reloadInMain];
            }
            
            [self.view makeToast:error ? @"同意失败" : @"添加成功" duration:1.0 position:CSToastPositionCenter];
            
        }];
        
        
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 66;
}


@end
