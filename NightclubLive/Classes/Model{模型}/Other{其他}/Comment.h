//
//  Comment.h
//  NightclubLive
//
//  Created by RDP on 2017/3/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ModelObject.h"
#import "PaiPaiModel.h"
#import "User.h"


/**
 *  评论基本类
 */

@interface CommentObject : ModelObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, strong) NSDate *createtime;

@property (nonatomic, assign) NSInteger typeId;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) NSString *subjectId;

@property (nonatomic, copy) NSString *modifytime;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, assign) NSInteger toUserId;

@property (nonatomic, assign) NSInteger ispraise;

@property (nonatomic, assign) NSInteger praise;

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) DataUser *toUser;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) NSURL *from_user_img;
@property (nonatomic, copy) NSString *from_user_name;
/** 所选要的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
