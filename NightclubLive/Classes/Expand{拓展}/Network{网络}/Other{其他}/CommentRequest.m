//
//  CommentRequest.m
//  NightclubLive
//
//  Created by RDP on 2017/3/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "CommentRequest.h"

@implementation CommentRequest

- (NSString *)path{
    return @"commentary/addCommentary.do";
}

- (NSDictionary *)parameters{
    
    if(self.param){
        return self.param;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_typeId) {
        [params setValue:@(_typeId) forKey:@"typeId"];
    }
    if (_subjectId) {
        [params setValue:_subjectId forKey:@"subjectId"];
    }
    if (_content) {
        [params setValue:_content forKey:@"content"];
    }
    if ([UserInfo shareUser].userID.length >0) {
        [params setValue:[UserInfo shareUser].userID forKey:@"userId"];
    }
    
    //NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:@{@"typeId":@(_typeId),@"subjectId":_subjectId,@"content":_content,@"userId":[UserInfo shareUser].userID}];
    
    if (_toUser) {
        [params setValue:_toUser forKey:@"toUserId"];
    }
    
    if (_reply_type) {
        [params setValue:@(_reply_type) forKey:@"Reply_type"];
    }
    
//    //回复主题
//    if (self.reply_type == 0){
//    }
//    else{//回复个人
//    }
//    if (self.toUser)
//        [paramDic setValue:_toUser forKey:@"toUserId"];
    
    return params.mutableCopy;
}

- (GJRequestMethod)method{
    return GJRequestPOST;
}

- (Class)modelClass{
    return nil;
}

- (GJAPICachePolicy)cachePolicy {
    return GJNotAPICachePolicy;
}

- (NSTimeInterval)cacheValidTime {
    return 10 * 60;
}


@end

@implementation CommentarygetListRequest

- (NSString *)path{
    
    return @"commentary/getList.do";
}

- (NSDictionary *)parameters{
    
    if (self.param){
        return self.param;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.pageNow) {
        [params setValue:@(self.pageNow) forKey:@"pageNow"];
    }
    if (self.typeId) {
        [params setValue:@(self.typeId) forKey:@"typeId"];
    }
    if (self.subjectId) {
        [params setValue:self.subjectId forKey:@"subjectId"];
    }
    if ([UserInfo shareUser].userID.length >0) {
        [params setValue:[UserInfo shareUser].userID forKey:@"userId"];
    }

    return params.mutableCopy;
    //return @{@"pageNow":@(self.pageNow),@"typeId":@(self.typeId),@"subjectId":self.subjectId,@"userId":[UserInfo shareUser].userID};
}

- (GJRequestMethod)method{
    return GJRequestPOST;
}

- (GJAPICachePolicy)cachePolicy {
    return GJNotAPICachePolicy;
}

- (NSTimeInterval)cacheValidTime {
    return 10 * 60;
}

@end
