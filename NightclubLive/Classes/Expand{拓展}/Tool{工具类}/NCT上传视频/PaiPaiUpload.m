//
//  PaiPaiUpload.m
//  NightclubLive
//
//  Created by RDP on 2017/8/26.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "PaiPaiUpload.h"
#import "VideoVC.h"
#import "VideoTool.h"
#import "ConvertTool.h"
#import "LocationPlayerVC.h"
#import "ObjectNavigationController.h"
#import "VideoVCPreview.h"
#import "FMLVideoCommand.h"
#import "UIAlertController+Factory.h"
#import "BlocksKit+UIKit.h"
static NSInteger PaiPaiVideLength = 30;

@interface PaiPaiUpload()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation PaiPaiUpload

- (void)selectVideoSourceWithType:(NSInteger)sourceType sourceVC:(UIViewController *)sourceVC
{
    @weakify(self);
    if (sourceType == 0)
    {
        // 拍拍视频
        VideoVC *vc = [VideoVC controllerWithViewModel:nil andSbName:@"CLVideoVCSB"];
        ObjectNavigationController *nav = [[ObjectNavigationController alloc] initWithRootViewController:vc];
        [sourceVC presentViewController:nav animated:YES completion:nil];
        // MP4格式
        vc.VideoBlock = ^(NSString *url)
        {
            // MP4路径
//            NSURL *VideoURL = [NSURL URLWithString:url];
//            if (self.completionBlock)
//                self.completionBlock(VideoURL);

        };
    }
    else if (sourceType == 1)
    {
        // 选择视频
        
        UIImagePickerController *pc = [[UIImagePickerController alloc] init];
        pc.delegate = self;
        pc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        pc.mediaTypes = @[(NSString*) kUTTypeMovie, (NSString*) kUTTypeVideo];
        
        [sourceVC presentViewController:pc animated:YES completion:nil];
        
        [pc setBk_didFinishPickingMediaBlock:^(UIImagePickerController * vc, NSDictionary * dic)
        {
            [vc dismissViewControllerAnimated:YES completion:nil];
            @strongify(self);
            // 判断视频长 需要转换
            NSURL *videoURL = dic[UIImagePickerControllerMediaURL];
            [self handelVideoURL:videoURL sourceVC:sourceVC];
            
            DLog(@"%@",dic);
        }];
        
    }
}

- (void)handelVideoURL:(NSURL *)videoURL sourceVC:(UIViewController *)sourceVC
{
    kWeakSelf(sourceVC);
    
    VideoTool *tool = [[VideoTool alloc] initWithURL:videoURL];
    BOOL canPush = tool.timeLength > PaiPaiVideLength;
    if (canPush)
    {
        @weakify(self);
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"视频超过30秒，将为您截取出前30秒的内容，是否继续" action:@[@"裁剪",@"取消"] calk:^(id param) {
            NSInteger selectIndex = [param integerValue];
            
            if (selectIndex == 0)
            {
                ShowLoading;
                [tool cropWithStart:0 end:30 completion:^(NSURL *outputURL, Float64 videoDuration, BOOL isSuccess)
                {
                    CloseLoading;
                    @strongify(self);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if(isSuccess)
                        {
                            [self handelAgainVideoURL:outputURL sourceVC:sourceVC];
                        }else{
                            ShowError(@"裁剪失败");
                        }
                    });
                }];
                
            }
        }];
        
        [weaksourceVC presentViewController:ac animated:YES completion:nil];
    }
    else{
        
        ConvertTool *tool = [[ConvertTool alloc] init];
        // 获取视频的URL
        NSURL *url = [tool convertMP4:videoURL];
        if (self.completionBlock){
            self.completionBlock(url);
        }
        
    }
}

- (void)handelAgainVideoURL:(NSURL *)outputURL sourceVC:(UIViewController *)sourceVC
{
    kWeakSelf(sourceVC);
    
    LocationPlayerVC *playVC = [[LocationPlayerVC alloc] init];
    playVC.playURL = outputURL;
    playVC.finishBlock = ^(id obj)
    {
        // 询问是否需要上传
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"是否上传该视频" action:@[@"上传",@"取消"] calk:^(NSNumber *selectNum) {
            NSInteger num = [selectNum integerValue];
            
            if (num == 0 && _completionBlock){
                _completionBlock(outputURL);
            }
            
        }];
        
        [weaksourceVC presentViewController:ac animated:YES completion:nil];
    };
    
    [weaksourceVC presentViewController:playVC animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
