

//
//  DownloadAudioService.h
//  NightclubLive
//
//  Created by WanBo on 17/1/5.
//  Copyright © 2017年 WanBo. All rights reserved.
//

typedef void(^FinishBlock)(NSString *filePath);
typedef void(^Failed)();

@interface DownloadAudioService : NSObject
/*
 * url                  音频网址
 * directoryPath  存放的地址
 * fileName         要存的名字
 */
+ (void)downloadAudioWithUrl:(NSString *)url
saveDirectoryPath:(NSString *)directoryPath
fileName:(NSString *)fileName
finish:(FinishBlock )finishBlock
failed:(Failed)failed;

@end
