//
//  ReportRequest.h
//  NightclubLive
//
//  举报
//  Created by RDP on 2017/4/11.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectRequest.h"

@interface ReportRequest : ObjectRequest
/** 分类ID */
@property (nonatomic, assign) NSInteger subjectTypeId;
/** 主题ID */
@property (nonatomic, copy) NSString *subjectId;
/** 举报内容 */
@property (nonatomic, copy) NSString *content;
/** 举报编号 */
@property (nonatomic, assign) NSInteger reportType;


@end
