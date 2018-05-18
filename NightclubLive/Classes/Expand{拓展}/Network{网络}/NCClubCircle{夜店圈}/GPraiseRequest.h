//  PraiseRequest.h
//  NightclubLive
//
//  点赞接口
//
//  Created by RDP on 2017/3/3.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GJModelRequest.h"
#import "ObjectRequest.h"

/** 赞类型 */
typedef enum{
    PriaseAdd = 0,
    PriaseCancel,
}PraiseType;

@interface GPraiseRequest : ObjectRequest
/** 赞类型 */
@property (nonatomic, assign) PraiseType praiseType;
/** 分类类型 1-动态 2-心声 3-活动 4-拍拍 */
@property (nonatomic, assign) NSInteger subjectTypeId;
/** 点赞类型 1-主题 2-评论*/
@property (nonatomic, assign) NSInteger type;
/** 点赞ID */
@property (nonatomic, assign) NSString *subjectId;
/** 发布主题者的ID（如果点赞的是主题） */
@property (nonatomic, copy) NSString *receiverID;

@end
