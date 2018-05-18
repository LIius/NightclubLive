//
//  PraiseRequest.m
//  NightclubLive
//
//  Created by RDP on 2017/3/3.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GPraiseRequest.h"

@implementation GPraiseRequest


- (NSString *)path{
    
    NSString *url = nil;
    
    if (self.praiseType == PriaseAdd)
        url = @"praise/addPraise.do";
    else
        url = @"praise/cancelPraise.do";
    
    return url;
}

- (GJRequestMethod)method{
        
    return GJRequestPOST;
}

- (NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.type) {
        [params setValue:@(self.type) forKey:@"typeId"];
    }
    if (self.subjectTypeId) {
        [params setValue:@(self.subjectTypeId) forKey:@"subjectTypeId"];
    }
    if (self.subjectId.length >0 ) {
        [params setValue:self.subjectId forKey:@"subjectId"];
    }
    if ([UserInfo shareUser].userID.length >0) {
        [params setValue:[UserInfo shareUser].userID forKey:@"userId"];
    }
    
   // NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:@{@"typeId":@(self.type),@"subjectTypeId":@(self.subjectTypeId),@"subjectId":self.subjectId,@"userId":[UserInfo shareUser].userID}];
    
    if (self.type == 1){
        if (_receiverID) {
            [params setValue:_receiverID forKey:@"receiver_id"];
        }
        
    }
    
    
    return params.mutableCopy;
}

@end
