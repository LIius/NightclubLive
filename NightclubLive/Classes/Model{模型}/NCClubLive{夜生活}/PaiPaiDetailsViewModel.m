//
//  PaiPaiDetailsViewModel.m
//  NightclubLive
//
//  Created by RDP on 2017/3/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "PaiPaiDetailsViewModel.h"
#import "CommentRequest.h"
#import "PaiPaiModel.h"
#import "CommentRequest.h"
#import "CommentRequest.h"
#import "Comment.h"
#import "GPraiseRequest.h"

@interface PaiPaiDetailsViewModel(){
    
    NSMutableArray *p_datas;
}

@end

@implementation PaiPaiDetailsViewModel

- (instancetype)init{
    if (self = [super init]){
        p_datas = [NSMutableArray array];
        _cellHeights = [NSMutableArray array];
    }
    return self;
}

- (void)removeObjectAtIndex:(NSInteger)index{
    
    [p_datas removeObjectAtIndex:index];
}

- (RACCommand *)commentCommand{
    
    if (!_commentCommand){
        
        _commentCommand = [RACCommand createCommandWithDoBlock:^(id<RACSubscriber> subscriber)
        {
            
            CommentRequest *r = [CommentRequest new];
            r.typeId = 4;
            r.subjectId = self.subjectId;
            r.content = self.message;
            r.reply_type = self.replayType;

            r.toUser = self.toUser;
            
            [r startWithCompletedBlock:^(GJBaseRequest *request) {
                
                ResponseState *state = [ResponseState objectWithDic:request.responseObject];
                
                [subscriber sendNext:state];
                [subscriber sendCompleted];
            }];
            
        }];
    }
    
    return _commentCommand;
}

- (RACCommand *)getCommentListCommand{
    
    if (!_getCommentListCommand){
        
        _getCommentListCommand = [RACCommand createCommandWithDoBlock:^(id<RACSubscriber> subscriber) {
            
            CommentarygetListRequest *r = [CommentarygetListRequest new];
            r.pageNow = self.pageNow;
            r.typeId = 4;
            r.subjectId = self.model.ID;
            [r startWithCompletedBlock:^(GJBaseRequest *request) {
                
                ResponseState *state = [ResponseState objectWithDic:request.responseObject];
                
                if (state.isSuccess)
                {
                    if (self.refreshType == RefreshTypeLoad)
                        [p_datas removeAllObjects];
                    
                    [p_datas addObjectsFromArray:[CommentObject arrayObjectWithDS:state.data]];
                }
                
                [subscriber sendNext:state];
                [subscriber sendCompleted];
            }];

        }];
    }
    return _getCommentListCommand;
}

- (RACCommand *)praiseCommand{
    
    if (!_praiseCommand){
        
        _praiseCommand = [RACCommand createCommandWithDoBlock:^(id<RACSubscriber> subscriber) {
            
            GPraiseRequest *r = [GPraiseRequest new];
            r.praiseType = (PraiseType)self.praiseType;
            r.subjectId = self.subjectId;
            r.subjectTypeId = self.subjectTypeId;
            r.type = self.type;
            
            [r startWithCompletedBlock:^(GJBaseRequest *request) {
                
                ResponseState *state = [ResponseState objectWithDic:request.responseObject];
                
                [subscriber sendNext:state];
                [subscriber sendCompleted];
            }];
        }];
    }
    return _praiseCommand;
}


- (NSArray *)datas{
    
    return [p_datas copy];
}
@end
