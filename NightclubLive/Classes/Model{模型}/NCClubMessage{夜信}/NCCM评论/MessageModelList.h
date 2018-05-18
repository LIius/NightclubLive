//
//  MessageModelList.h
//  NightclubLive
//
//  Created by RDP on 2017/7/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ModelObject.h"


@interface CommentModel : ModelObject
/** 类型  */
@property (nonatomic, assign) NSInteger typeId;
/** 主题 */
@property (nonatomic, copy) NSString *subjectId;
/** 回复内容 */
@property (nonatomic, copy) NSString *content;
/** 信息来源 */
@property (nonatomic, copy) NSString *From;
/** 时间  */
@property (nonatomic, copy) NSString *date;
/** 用户头像 */
@property (nonatomic, strong) NSURL *from_user_img;
/** 用户名字 */
@property (nonatomic, strong) NSString *from_user_name;
/** 模型对象 */
@property (nonatomic, strong) NSDictionary *map;

/** 模型对象 */
@property (nonatomic, strong) id m;


@end
