//
//  ReportRequest.m
//  NightclubLive
//
//  Created by RDP on 2017/4/11.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ReportRequest.h"

@implementation ReportRequest

- (NSString *)path{
    
    return @"report/addReport.do";
}

- (NSDictionary *)parameters{

    if (!_content){
        _content = @"report";
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([UserInfo shareUser].userID.length >0) {
        [params setValue:[UserInfo shareUser].userID forKey:@"userId"];
    }
    if (_subjectTypeId) {
        [params setValue:@(_subjectTypeId) forKey:@"subjectTypeId"];
    }
    if (_subjectId) {
        [params setValue:_subjectId forKey:@"subjectId"];
    }
    if (_content) {
        [params setValue:_content forKey:@"content"];
    }
    if (_reportType) {
        [params setValue:@(_reportType) forKey:@"reportType"];
    }
    
    return params.mutableCopy;
    //return @{@"userId":[UserInfo shareUser].userID,@"subjectTypeId":@(_subjectTypeId),@"subjectId":_subjectId,@"content":_content,@"reportType":@(_reportType)};
}

@end
