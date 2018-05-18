//
//  UserTagView.h
//  NightclubLive
//
/**
 *   用户个人标志信息 
 *   顺序按照 1,企业。2，商家。3，性。4，等级。5，视频
 *
 *   思路是根据用户对象继续设置图片
 */
//  Created by RDP on 2017/5/3.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectView.h"

@interface UserTagView : ObjectView
/** 对齐方式 0 - 居中 1 - 左边  2-右边*/
@property (nonatomic, assign) NSInteger contentAlignType;

@end
