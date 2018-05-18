//
//  ReportViewController.h
//  NightclubLive
//
//  Created by SuperDanny on 2017/1/5.
//  Copyright © 2017年 WanBo. All rights reserved.
//
//  举报

#import "ObjectViewController.h"

@interface ReportViewController : ObjectViewController

/** 分类ID */
@property (nonatomic, assign) NSInteger subjectTypeId;
/** 主题ID */
@property (nonatomic, copy) NSString *subjectId;
/** 举报内容 */
@property (nonatomic, copy) NSString *content;
/** 举报编号 */
@property (nonatomic, assign) NSInteger reportType;

@end
