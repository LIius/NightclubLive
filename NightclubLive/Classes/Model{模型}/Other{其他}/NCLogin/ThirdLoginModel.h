//
//  ThirdLoginModel.h
//  NightclubLive
//
//  Created by RDP on 2017/3/29.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ModelObject.h"

@interface ThirdLoginModel : ModelObject
/** 登录UID */
@property (nonatomic, copy) NSString *uid;
/** 用户昵称 */
@property (nonatomic, copy) NSString *userName;
/** 用户头像 */
@property (nonatomic, copy) NSString *userImg;
/** 性别 */
@property (nonatomic, assign) NSInteger sex;
/** 性别字符串 */
@property (nonatomic, copy) NSString *sexStr;
/** 城市 */
@property (nonatomic, copy) NSString *city;


@property (nonatomic, assign) NSInteger loginType;
@property (nonatomic, assign) id optional;
@end
