//
//  FollowFanViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//  Edit by cr

#import "FollowFanViewController.h"
#import "FollowFanCell.h"
#import "MineRequest.h"
#import "MineModelList.h"
#import "DDAlertController.h"
#import "UserInfoViewController.h"
#import "EmptyBigView.h"
#import "MineRequest.h"
#import "UILabel+NavTitleView.h"


@interface FollowFanViewController ()
@property(nonatomic,strong)UIView *emptyView;
@end

@implementation FollowFanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSArray *titleArr = @[@"我的关注",@"我的粉丝"];
    NSString *title = [titleArr stringAtIndex:self.tag];
    self.navigationItem.titleView = [UILabel navWithTitle:title];
    
    self.isHead = YES;
    self.isFoot = YES;
}

- (void)refreshMethod
{
    @weakify(self);
    FenGZRequest *r = [FenGZRequest new];
    r.tag = self.tag;
    r.pageNow = self.pageNow;
    [r startRequestWithCompleted:^(ResponseState *state)
     {
         @strongify(self);
        self.parses = [FenGZModel arrayObjectWithDS:state.data];
        [self requestEnd];
    }];
}

#pragma mark - Table Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.dataSource.count == 0 )
    {
        if (!_emptyView)
        {
            UIView *v = [EmptyBigView viewWithTip:self.tag == 0 ? @"目前没有粉丝呢~" : @"没有关注的人呢~"];
  
            v.frame = [NCEmpty getEmtpyViewRectWithScrollView:self.tableView];
            [self.view addSubview:v];
            _emptyView = v;
        }
        
    }else{
        if (_emptyView)
            [_emptyView removeFromSuperview];
        
    }
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    
    FollowFanCell *cell = [tableView dequeueReusableCellWithIdentifier:FollowFanCellReuseID];
    
    cell.tag = self.tag;
    cell.model = self.dataSource[indexPath.row];
    cell.indexPath = indexPath;
    cell.followBlock = ^(NSIndexPath *vIndexPath)
    {
        @strongify(self);

        FenGZModel *m = self.dataSource[vIndexPath.row];
        if (self.tag == 1)
        {
            AddGZRequest *r = [AddGZRequest new];
            r.model = m.user_id;
            [r startRequestWithCompleted:^(ResponseState *state) {
                @strongify(self);
                if (state.isSuccess)
                {
                    m.follow = !m.follow;
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                else{
                    ShowError(@"关注失败");
                }
            }];

        }
        else{
            // 添加关注
            FenGZModel *m = self.dataSource[vIndexPath.row];
            AddGZRequest *r = [AddGZRequest new];
            r.model = m.user_id;
            
            [r startRequestWithCompleted:^(ResponseState *state)
             {
                @strongify(self);
                if (state.isSuccess){
                    m.follow = YES;
                    //  [weakself.dataSource removeObjectAtIndex:vIndexPath.row];
                    //   [weakself.tableView deleteRowsAtIndexPaths:@[vIndexPath] withRowAnimation:UITableViewRowAnimationRight];
                    [self.tableView reloadInMain];
                }
                else
                    ShowError(@"添加关注失败");
            }];
        }

    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FenGZModel *m = self.dataSource[indexPath.row];
    
    UserInfoViewController *vc = ViewController(@"UserInfoSB", @"UserInfoViewController");
    User *u = [[User alloc] init];
    u.userId = self.tag == 0 ? m.follow_user_id : m.user_id;
    vc.userModel = u;
    
    PushViewController(vc);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
