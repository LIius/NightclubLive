//
//  CommentRequest.h
//  NightclubLive
//
//  Created by RDP on 2017/3/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GJModelRequest.h"


@interface CommentRequest : GJModelRequest
/** 回复分类 */
@property (nonatomic, assign) NSInteger subjectTypeId;
/** 回复类型*/
@property (nonatomic, assign) NSInteger typeId;
/** 评论的ID */
@property (nonatomic, copy) NSString *subjectId;
/** 回复内容 */
@property (nonatomic, copy) NSString *content;
/** 回复对象 */
@property (nonatomic, copy) NSString *toUser;
/** 回复类型 */
@property (nonatomic, assign) NSInteger reply_type;

@end


@interface CommentarygetListRequest : CommentRequest
@property (nonatomic, assign) NSInteger pageNow;

@end
