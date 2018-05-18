//
//  VideoCertificationViewController.m
//  NightclubLive
//
//  Created by SuperDanny on 2017/1/9.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "VideoCertificationViewController.h"
#import "IDImagePickerCoordinator.h"
#import "QiNiuSystemService.h"
#import "GlobalRequest.h"
#import "QiniuTool.h"
#import "AuthModel.h"
#import "ZFPlayerView+Quick.h"


@interface VideoCertificationViewController ()

@property (weak, nonatomic) IBOutlet UIButton *contentBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *videoBgView; ///背景
@property (weak, nonatomic) IBOutlet UIImageView *videoPlayImgV;///视频中间播放图标
@property (weak, nonatomic) IBOutlet UIImageView *recordImgV;///录制视频中间图标
@property (weak, nonatomic) IBOutlet UILabel *recordMemoLab;
@property (weak, nonatomic) IBOutlet UILabel *memoLab;///尚未认证备注
@property (weak, nonatomic) IBOutlet UILabel *passMemoLab;///认证通过备注

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;

@property (nonatomic, strong) IDImagePickerCoordinator *imagePickerCoordinator;
@property (nonatomic, strong) AuthVideoModel *avModel;

@end

@implementation VideoCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureData];
    
    if (_isPass && self.model){//获取用户视频认证资料
        
        ShowLoading
        
        //加载新的视频
        GetVideoRequest *r = [GetVideoRequest new];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (self.model) {
            [params setValue:self.model forKey:@"userId"];
        }
        r.param = params;
        //r.param = @{@"userId":self.model};
        [r startRequestWithCompleted:^(ResponseState *state) {
            
            AuthVideoModel *m = [AuthVideoModel objectWithDic:state.datas.firstObject];
            self.avModel = m;
            [_videoBgView sd_setImageWithURL:m.coverUrl];
            [_videoBgView autoAdjustWidth];
            CloseLoading
            
            _passMemoLab.text = [NSString stringFromeArray:@[@"本视频正在等待夜店网平台认证",@"本视频已通过夜店网平台认证"] index:m.status];
            
        }];
    }
}

- (void)configureData {
    if (_isPass) {
        _recordImgV.hidden = YES;
        _videoPlayImgV.hidden = NO;
        _recordMemoLab.hidden = YES;
        _passMemoLab.hidden = NO;
        _memoLab.hidden = YES;
    } else {
        _recordImgV.hidden = NO;
        _videoPlayImgV.hidden = YES;
        _recordMemoLab.hidden = NO;
        _passMemoLab.hidden = YES;
        _rightItem.image = nil;
        _memoLab.hidden = NO;
    }
}

#pragma mark - 录制新视频
- (IBAction)recordVideoAction:(id)sender {
    
    if (_isPass && self.model){
        
        //播放视频
        [ZFPlayerView quickInitSuperView:_contentView title:@"" coverURL:_avModel.coverUrl video:_avModel.url];
        
        UIButton *btn = sender;
        btn.hidden = YES;
        _videoPlayImgV.hidden = YES;

        _videoBgView.hidden = YES;
    }
    else{
    
        __block NSString *qiniuVideoURL, *qiniuCoverImageURL;
        kWeakSelf(_videoBgView);
        @weakify(self);
        self.imagePickerCoordinator = [IDImagePickerCoordinator new];
        self.imagePickerCoordinator.cameraVC.videoMaximumDuration = 60;
        self.imagePickerCoordinator.cameraVC.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        [self.imagePickerCoordinator setFinishRecordBlock:^(NSURL *recordedVideoURL,  UIImage *coverImage) {
            
            //封面
            // _videoBgView.image = coverImage;
            //     [weak_videoBgView setImage:coverImage];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [weak_videoBgView setImage:coverImage];
                [weak_videoBgView autoAdjustWidth];
            });
            
            QiniuTool *tool = [QiniuTool shareTool];
            
            ShowLoading
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                __block NSString *imageUlr = nil;
                __block NSString *videoUlr = nil;
                dispatch_group_t group = dispatch_group_create();
                dispatch_queue_t queue = dispatch_queue_create("upload", nil);
                
                dispatch_group_enter(group);
                dispatch_group_enter(group);
                //上传视频
                dispatch_group_async(group, queue, ^{
                    
                    NSString *fileString = [recordedVideoURL absoluteString];
                    
                    NSURL *fileURL = [NSURL fileURLWithPath:fileString];
             
                    [tool uploadVideo:fileURL type:UploadTypeSpaceTypeAuth success:^(id value) {
                        
                        
                        dispatch_group_leave(group);
                        
                        videoUlr = value;
                    } failure:^(NSError *error) {
                        //   [SVProgressHUD dismiss];
                    }];
                    
                });
                //上传封面图
                
                dispatch_group_async(group, queue, ^{
                    
                    [tool uploadImages:@[coverImage] type:UploadTypeSpaceTypeAuth success:^(id value) {
                        
                        dispatch_group_leave(group);
                        
                        imageUlr = [value firstObject];
                        
                    } failure:^(NSError *error) {
                    }];
                    
                });
                
                dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
                dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                    
                    //上传NC服务器
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
                        
                        if (state.isSuccess){
                            
                            ShowSuccess(@"个人视频已提交，请等待审核");
                         //   ShowSucces(@"上传认证视频成功");
                            [self.navigationController popViewControllerAnimated:YES];
                           // [UserInfo shareUser].user.video_certification = YES;
                            //重新获取用户资料
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
}

#pragma mark - Request
#pragma mark 上传认证视频地址

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
