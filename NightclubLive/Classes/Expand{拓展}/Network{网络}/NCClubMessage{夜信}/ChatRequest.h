//
//  ChatRequest.h
//  NightclubLive
//
//  Created by RDP on 2017/4/11.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectRequest.h"

@interface FindUserRequest : ObjectRequest
/** 搜索关键词 */
@property (nonatomic, copy) NSString *searchValue;
/** 职业搜索 */
@property (nonatomic, copy) NSString *professionValue;
/** 当前页数 */
@property (nonatomic, assign) NSInteger pageNow;
@end
