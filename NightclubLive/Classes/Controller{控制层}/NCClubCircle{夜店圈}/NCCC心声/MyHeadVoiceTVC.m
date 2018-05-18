//
//  MyHeadVoiceTVC.m
//  NightclubLive
//
//  Created by RDP on 2017/9/8.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MyHeadVoiceTVC.h"
#import "MineRequest.h"
#import "VoiceListModel.h"
#import "ClubCircleGuiMiVoiceCell.h"
#import "EmptyBigView.h"
#import "GPraiseRequest.h"
#import "VoiceCommentDetailVC.h"
#import "VoiceCommentDetailViewModel.h"
#import "LGAudioKit.h"
#import "DownloadAudioService.h"

@interface MyHeadVoiceTVC ()<ClubCircleGuiMiVoiceCellDelegate,LGAudioPlayerDelegate>
 @property(nonatomic,strong)UIView *emptyView;
@end

@implementation MyHeadVoiceTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isHead = YES;
    self.isFoot = YES;
}

- (void)refreshMethod
{
    [super refreshMethod];
    
    MyVoiceListRequest *r = [MyVoiceListRequest new];
    r.pageNow = self.pageNow;
    [r startRequestWithCompleted:^(ResponseState *state) {
      self.parses = [HeartsoundListModel arrayObjectWithDS:state.datas];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (self.dataSource.count == 0 )
    {
        if (!_emptyView)
        {
            UIView *v = [EmptyBigView viewWithTip:@"说出你的心声吧"];
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
    static NSString *cellIdentifier = @"ClubCircleGuiMiVoiceCellID";
    
    ClubCircleGuiMiVoiceCell *cell = (ClubCircleGuiMiVoiceCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    HeartsoundListModel *model = self.dataSource[indexPath.row];
    
    @weakify(self);
    cell.likeCallback = ^(NSIndexPath *cellIndexPath)
    {
        @strongify(self);
        [self likeRequest:cellIndexPath];
    };

    cell.model = model;
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ClubCircleGuiMiVoiceCell cellHeightWithObj:self.dataSource[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VoiceCommentDetailViewModel *viewModel = [[VoiceCommentDetailViewModel alloc] initWithParams:nil];
    HeartsoundListModel *model = self.dataSource[indexPath.row];
    VoiceListModel *m = self.model;
    viewModel.model = model;
    viewModel.themID = m.ID;
    VoiceCommentDetailSuperVC *vc = [VoiceCommentDetailSuperVC controllerWithViewModel:viewModel andSbName:@"VoiceCommentDetailSuperSB"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)likeRequest:(NSIndexPath *)cellIndexPath
{
    @weakify(self);
    HeartsoundListModel *m = self.dataSource[cellIndexPath.row];
    GPraiseRequest *r = [GPraiseRequest new];
    r.subjectTypeId = 2;
    r.subjectId = m.ID;
    r.type = 1;
    r.praiseType= m.ispraise ? 1 : 0;
    [r startRequestWithCompleted:^(ResponseState *state)
     {
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
            
            [self.tableView reloadRowsAtIndexPaths:@[cellIndexPath]withRowAnimation:UITableViewRowAnimationNone];
        }
        else{
            ShowError(state.message);
        }
    }];
}

#pragma mark - LGAudioPlayerDelegate
- (void)audioPlayerStateDidChanged:(LGAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    ClubCircleGuiMiVoiceCell *voiceMessageCell = [self.tableView cellForRowAtIndexPath:indexPath];
    LGVoicePlayState voicePlayState;
    switch (audioPlayerState)
    {
        case LGAudioPlayerStateNormal:
            voicePlayState = LGVoicePlayStateNormal;
            break;
        case LGAudioPlayerStatePlaying:
            voicePlayState = LGVoicePlayStatePlaying;
            break;
        case LGAudioPlayerStateCancel:
            voicePlayState = LGVoicePlayStateCancel;
            break;
            
        default:
            break;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [voiceMessageCell setVoicePlayState:voicePlayState];
    });
}

#pragma mark - LGTableViewCellDelegate
- (void)voiceMessageTaped:(ClubCircleGuiMiVoiceCell *)cell
{
    [cell setVoicePlayState:LGVoicePlayStatePlaying];
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    HeartsoundListModel *messageModel = [self.dataSource objectAtIndex:indexPath.row];
    
    ShowLoading
    
    [DownloadAudioService downloadAudioWithUrl:messageModel.voicelen saveDirectoryPath:DocumentPath fileName:@"xxxxxxx.amr" finish:^(NSString *filePath) {
        
        CloseLoading;
        
        [[LGAudioPlayer sharePlayer] playAudioWithURLString:filePath atIndex:indexPath.row];
        [LGAudioPlayer sharePlayer].delegate  = self;
        
    } failed:^(id x){
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
