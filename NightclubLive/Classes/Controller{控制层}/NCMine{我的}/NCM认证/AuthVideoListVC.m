//
//  AuthVideoListVC.m
//  NightclubLive
//
//  Created by RDP on 2017/9/11.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AuthVideoListVC.h"
#import "GlobalRequest.h"
#import "AuthModel.h"
#import "AuthVideoCell.h"
#import "IDImagePickerCoordinator.h"
#import "QiniuTool.h"
@interface AuthVideoListVC ()

@property (weak, nonatomic) IBOutlet UIButton *reAuthBtn;
@property (nonatomic, strong) IDImagePickerCoordinator  *imagePickerCoordinator;

@end

@implementation AuthVideoListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isHead = YES;
    self.tableView.rowHeight = (272/375.0) * SCREEN_WIDTH;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self rowCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *AuthVideoCellID = @"AuthVideoCell";
    
    AuthVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:AuthVideoCellID];
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (NSInteger)rowCount
{
    if (self.dataSource.count == 0)
        return 0;
    
    if (self.dataSource.count == 1){
        return 1;
    }
    
    if (self.dataSource.count >= 2){
        
        AuthVideoModel *m_1 = self.dataSource[0];
        if (m_1.status == 1)
            return 1;
        else
            return 2;
    }
    
    return 0;
}

- (void)refreshMethod
{
    [super refreshMethod];
    
    // 加载新的视频
    GetVideoRequest *r = [GetVideoRequest new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (CurrentUser.userID.length >0) {
        [params setValue:CurrentUser.userID forKey:@"userId"];
    }
    r.param = params;
    //r.param = @{@"userId":CurrentUser.userID};
    [r startRequestWithCompleted:^(ResponseState *state) {
        
        self.parses = [AuthVideoModel arrayObjectWithDS:state.datas];
        
        self.reAuthBtn.hidden = (self.dataSource.count > 1);
        
        [self.reAuthBtn setTitle:self.dataSource.count  >= 1 ? @"重新认证":@"添加认证" forState:UIControlStateNormal];
    }];
}

#pragma mark - 重新认证
- (IBAction)reAuthVideo:(id)sender
{
#if TARGET_IPHONE_SIMULATOR
    ShowMessage(@"请使用真机测试");
#else
    [self addAuthVideo];
#endif
}

#pragma mark - 添加认证
- (void)addAuthVideo
{
    @weakify(self);

    self.imagePickerCoordinator = [IDImagePickerCoordinator new];
    self.imagePickerCoordinator.cameraVC.videoMaximumDuration = 60;
    self.imagePickerCoordinator.cameraVC.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    [self.imagePickerCoordinator setFinishRecordBlock:^(NSURL *recordedVideoURL,  UIImage *coverImage) {
        
        QiniuTool *tool = [QiniuTool shareTool];
        
        ShowLoading
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            __block NSString *imageUlr = nil;
            __block NSString *videoUlr = nil;
            dispatch_group_t group = dispatch_group_create();
            dispatch_queue_t queue = dispatch_queue_create("upload", nil);
            
            dispatch_group_enter(group);
            dispatch_group_enter(group);
            
            // 上传视频到七牛
            dispatch_group_async(group, queue, ^{
                
                NSString *fileString = [recordedVideoURL absoluteString];
                
                NSURL *fileURL = [NSURL fileURLWithPath:fileString];
                
                [tool uploadVideo:fileURL type:UploadTypeSpaceTypeAuth success:^(id value) {

                    dispatch_group_leave(group);
                    
                    videoUlr = value;
                } failure:^(NSError *error) {
                    
                }];
                
            });
            
            // 上传封面图到七牛
            dispatch_group_async(group, queue, ^{
                
                [tool uploadImages:@[coverImage] type:UploadTypeSpaceTypeAuth success:^(id value) {
                    
                    dispatch_group_leave(group);
                    
                    imageUlr = [value firstObject];
                    
                } failure:^(NSError *error) {
                    
                }];
                
            });
            
            dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                
                // 上传NC服务器
                VideoReuqest *r = [VideoReuqest new];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                if ([UserInfo shareUser].userID.length >0) {
                    [params setValue:[UserInfo shareUser].userID forKey:@"userId"];
                }
                if (videoUlr.length > 0) {
                    [params setValue:videoUlr forKey:@"Url"];
                }
                if (imageUlr.length > 0) {
                    [params setValue:imageUlr forKey:@"coverUrl"];
                }
                
                r.param = params;
                //r.param = @{@"userId":[UserInfo shareUser].userID,@"Url":videoUlr,@"coverUrl":imageUlr};
                [r startRequestWithCompleted:^(ResponseState *state) {
                    @strongify(self);
                    CloseLoading
                    
                    if (state.isSuccess)
                    {
                        ShowSuccess(@"个人视频已提交，请等待审核");
       
                        [self requestBegin];
            
                        // 重新获取用户资料
                        [CurrentUser updateUserDataCompletion:^(id param) {
                            
                        }];
                    }
                    else{
                        ShowError(@"上传认证视频失败");
                    }
                    
                }];
                
            });
            
        });
    }];
    
    [self presentViewController:[_imagePickerCoordinator cameraVC] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
