//
//  XLPhotoImp.m
//  NightclubLive
//
//  Created by RDP on 2017/5/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "XLPhotoImp.h"

@implementation XLPhotoImp

- (void)photoBrowser:(XLPhotoBrowser *)browser clickActionSheetIndex:(NSInteger)actionSheetindex currentImageIndex:(NSInteger)currentImageIndex{

    if (currentImageIndex == 0 )
    {
        // 保存
        id object = self.imgs[currentImageIndex];
        NSURL *url ;
        
        if ([object isKindOfClass:[NSURL class]])
        {
            url = (NSURL *)object;
        }else if ([object isKindOfClass:[NSString class]] ){
            
            NSString *urlString = (NSString *)object;
            if (iOS9)
            {
                url = [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            }else{
                url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }
  
        if (url)
        {
           
            [[SDWebImageManager sharedManager] downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                // 下载完毕
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:),  (__bridge void *)self);
                
                if (error){
                    ShowError(@"保存失败");
                }
                else{
                    ShowSuccess(@"保存成功");
                }
            }];
        }
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    ShowSuccess(@"保存图片成功");
}

@end
