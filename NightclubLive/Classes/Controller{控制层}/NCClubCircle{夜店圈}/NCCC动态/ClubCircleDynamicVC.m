 //
//  ClubCircleDynamicVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/2.
//  Copyright © 2016年 WanBo. All rights reserved.
//  夜店圈--动态

#import "ClubCircleDynamicVC.h"
#import "ClubCircleDynamicCell.h"
#import "ClubCircleDynamicDetailVC.h"
#import "ClubCircleDynamicViewModel.h"
#import "ClubCircleDynamicDetailViewModel.h"
#import "LocationTool.h"

#import "XLPhotoBrowser.h"
#import "JhtFloatingBall.h"
#import "ClubCircleRequest.h"
#import "GPraiseRequest.h"
#import "GiftView.h"
#import "UserInfoViewController.h"
#import "EmptyBigView.h"
#import "LGAudioPlayer.h"
#import "DownloadAudioService.h"
#import "GiftTool.h"

@interface ClubCircleDynamicVC ()<LGAudioPlayerDelegate>
@property(nonatomic,strong)UIView *emptyView;
@end

@implementation ClubCircleDynamicVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 添加刷新功能
    
    self.pageNow = 1;
    self.refreshView = self.tableView;
    self.isHead = YES;
    self.isFoot = YES;
    self.disableViewRefresh = YES;
    [self refreshMethod];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:NOTIFICATION_SLRELEASEDYNAMIC object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [KNotificationCenter removeObserver:self];
}

- (void)refreshMethod
{
    NSString *userID = [UserInfo shareUser].userID;
    
    if ([userID integerValue] == -1)
    {
        [self.tableView endRefresh];
        return;
    }
    
    ClubCircleGetListRequest *r = [ClubCircleGetListRequest new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.pageNow) {
        [params setValue:@(self.pageNow) forKey:@"pageNow"];
    }
    if ([UserInfo shareUser].location.lclatitude) {
        [params setValue:[UserInfo shareUser].location.lclatitude forKey:@"latitude"];
    }
    if ([UserInfo shareUser].location.lclongitude) {
        [params setValue:[UserInfo shareUser].location.lclongitude forKey:@"longitude"];
    }
    if (userID.length >0) {
        [params setValue:userID forKey:@"userId"];
    }
    r.param = params;
    //r.param = @{@"pageNow":@(self.pageNow),@"latitude":[UserInfo shareUser].location.lclatitude,@"longitude":[UserInfo shareUser].location.lclongitude,@"userId":userID};
    
    @weakify(self);
    [r startRequestWithCompleted:^(ResponseState *state) {
        @strongify(self);
        if (state.isSuccess){
            NSArray *array = [DynamicListModel arrayObjectWithDS:state.datas];
            self.parses = [DynamicListModelFrame arrayObjectWithFrameObject:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }
    }];
}

- (void)tongzhi:(NSNotification *)text
{
    //[self.viewModel.requestRemoteDataCommand execute:nil];
    
    [self requestBegin];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicListModelFrame *frame = self.dataSource[indexPath.row];
    
    return frame.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (self.dataSource.count == 0 )
    {
        if (!_emptyView)
        {
            EmptyBigView *view = [EmptyBigView initFromXIB];
            view.tipLabel.text = @"还没有动态发布呢~";
            UIView *v = view;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ClubCircleDynamicCell";
    
    DynamicListModelFrame *frame = self.dataSource[indexPath.row];
    NSInteger layoutType = (frame.model.images.count >= 3 ? 1 : 0);
    
    DLog(@"layout = %ld",layoutType);
    
    ClubCircleDynamicCell *cell = (ClubCircleDynamicCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // 调整布局
    [cell switchLayout:layoutType imageCount:frame.model.images.count];
    
    cell.tag = indexPath.row;
    
    cell.indexPath = indexPath;
    
    @weakify(self);
    kWeakSelf(cell);

    cell.praiseBlock = ^(id value){
        
        // 点赞
        DynamicListModelFrame *frame = self.dataSource[indexPath.row];
        DynamicListModel *m = frame.model;
        GPraiseRequest *request = [GPraiseRequest new];
        request.praiseType = m.ispraise;
        request.subjectTypeId = 1;
        request.subjectId = frame.model.ID;
        request.type = 1;
        request.receiverID = frame.model.user.ID;
//
//         /** 赞类型 */
//        @property (nonatomic, assign) PraiseType praiseType;
//        /** 分类类型 1-动态 2-心声 3-活动 4-拍拍 */
//        @property (nonatomic, assign) NSInteger subjectTypeId;
//        /** 点赞类型 1-主题 2-评论*/
//        @property (nonatomic, assign) NSInteger type;
//        /** 点赞ID */
//        @property (nonatomic, assign) NSString *subjectId;
//        /** 发布主题者的ID（如果点赞的是主题） */
//        @property (nonatomic, copy) NSString *receiverID;

        
        [request startRequestWithCompleted:^(ResponseState *state) {
            @strongify(self);
            if (state.isSuccess){
                
                if (m.ispraise){
                    m.ispraise = 0;
                    m.praise -= 1;
                }
                else{
                    m.ispraise = 1;
                    m.praise += 1;
                }
                [self.tableView reloadRowsAtIndexPaths:@[weakcell.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            else{
                [self.view makeToast:@"点赞失败" duration:1.0 position:CSToastPositionCenter];
            }
        }];

    };
    
    cell.sendGiftBlock = ^(NSIndexPath *selectIndexPath){
        @strongify(self);
        DynamicListModelFrame *m = self.dataSource[selectIndexPath.row];
        GiftTool *tool = [GiftTool defaultGiftTool];
        tool.receiverID = m.model.user.ID;
        tool.giftType = 1;
        tool.projectID = m.model.ID;
        [tool showGiftView];
    };
    
    cell.voiceBlock = ^(NSIndexPath *selectIndexPath) {
        @strongify(self);
        DynamicListModelFrame *m = self.dataSource[selectIndexPath.row];
        
        [DownloadAudioService downloadAudioWithUrl:[m.model.voicelen absoluteString] saveDirectoryPath:DocumentPath fileName:@"xxxxxxx.amr" finish:^(NSString *filePath) {
            
            CloseLoading;
            
            [[LGAudioPlayer sharePlayer] playAudioWithURLString:filePath atIndex:selectIndexPath.row];
            [LGAudioPlayer sharePlayer].delegate  = self;
            
        } failed:^(id x){
            
        }];

        
    };
    
    cell.imageClickBlock = ^(NSIndexPath *selectIndex){
        @strongify(self);
        DynamicListModelFrame *f = self.dataSource[selectIndex.section];
        
        [XLPhotoBrowser showPhotoBrowserWithImages:f.model.images currentImageIndex:selectIndex.row];
    };
    
    cell.logoClickBlock = ^(NSIndexPath *vIndexPath){
        @strongify(self);
        UserInfoViewController *infoVC = ViewController(@"UserInfoSB", @"UserInfoViewController");
        
        DynamicListModelFrame *m = self.dataSource[vIndexPath.row];
        User *user = [User new];
        user.userId = m.model.userId;
        infoVC.userModel = user;
        [self.navigationController pushViewController:infoVC animated:YES];
    };
    
    [cell bindModel:frame];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicListModelFrame *frameModel = self.dataSource[indexPath.row];
    
    ClubCircleDynamicDetailSuperVC *vc = [ClubCircleDynamicDetailSuperVC initSBWithSBName:@"ClubCircleDynamicDetailSuperSB"];
    
    // 删除
    vc.deleteBlock = ^(NSDictionary *deleteParam)
    {
        NSIndexPath *indexPath = deleteParam[@"indexPath"];
        [self.dataSource removeObjectAtIndex:indexPath.row];
 
        [self.tableView reloadInMain];
    };
    
    vc.model = frameModel.model;
    vc.indexPath = indexPath;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - LGAudioPlayerDelegate
- (void)audioPlayerStateDidChanged:(LGAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    ClubCircleDynamicCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];

    dispatch_async(dispatch_get_main_queue(), ^{
 
        [cell setPlayStateImageWithTag:audioPlayerState];
    });
}

@end
