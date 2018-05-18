//
//  ConvertTool.h
//  NightclubLive
//
//  视频转换工具
//  Created by RDP on 2017/3/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConvertTool : NSObject

/**
 *  MOV转换MP4
 *
 *  @param sourceURL 源文件路径
 *
 *  @return 成功之后的路径
 */
- (NSURL *)convertMP4:(NSURL *)sourceUrl;
@end
