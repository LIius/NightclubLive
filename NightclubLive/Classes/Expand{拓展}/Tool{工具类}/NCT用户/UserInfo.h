//
//  UserInfo.h
//  NightclubLive
//
//  用户单例模式 ()
//  Created by RDP on 2017/2/28.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ModelObject.h"
#import "User.h"
#import "Location.h"
#import "MineModelList.h"

@class ResponseState;

typedef void (^CalkBackBlock)(id param);

/**
 *  用户当前状态
 */
typedef enum{
    CurrentUserStatusSignOut,//未登录
    CurrentUserStatusLoginIn,//已经登录
}CurrentUserStatus;

@interface UserInfo : NSObject
//---------------------------------------------
/** 登录的手机号码 */
@property (nonatomic, copy) NSString  *lgPhone;
/** 登录的密码 */
@property (nonatomic, copy) NSString *lgPaw;
/** 第三方登录的UID */
@property (nonatomic, copy) NSString *thirdUID;
/** 第三方登录类型 */
@property (nonatomic, assign) NSInteger thirdType;

/** 用户ID 检测用户是否登录*/
@property (nonatomic, copy, readonly) NSString *userID;
/** 运行Token */
@property (nonatomic, copy) NSString *yunxinToken;
/** 用户信息 */
@property (nonatomic, strong, readonly) User *user;
/** 用户账号信息 */
@property (nonatomic, strong, readonly) AccountModel *account;
/** 定位信息 */
@property (nonatomic, strong, readonly) Location *location;
/** 是否是第三方登录 */
@property (nonatomic, assign, readonly) BOOL isThirdLogin;
/**  */
@property (nonatomic, assign) CurrentUserStatus status;
/** 用户token */
@property (nonatomic, copy) NSString *token;

/** 是否要显示弹框 */
@property (nonatomic, assign) BOOL isShowLoginAlert;

//----------------------------------------------

/**
 *  获取单例登录类
 *
 *  @return 对象
 */
+ (instancetype)shareUser;

/**
 *  需要重新登录
 */
+ (void)needLogin;
/**
 *  登录有改变,当前账号有其他账号在登录
 */
+ (void)loginChange;

/**
 *  自动登录,从本地获取资料
 */
+ (void)autoLogin;
/**
 *  自动登录,用户服务器登录
 */
+ (void)autoLoginServer;
/**
 *  登录,必须要与云信一起登录成功才算
 */
- (void)loginWithCompletion:(void (^)(ResponseState *state))completion;
/**
 *  修改密码之后需要重新登录账号
 */
- (void)changePawNeedLogin;
/**
 *  登出
 */
- (void)loginOut;

/**
 *  重新设置User对象
 *
 *  @param user 新的用户对象
 */
- (void)reSetUserData:(User *)user;
/**
 *  获取用户信息
 *
 *  @param completion 获取成功回调
 */
- (void)updateUserDataCompletion:(CalkBackBlock)completion;
/**
 *  更新用户资料更账号信息
 *
 *  @param completion 完成之后的回调
 */
- (void)updateUserDataAndAccountCompletion:(CalkBackBlock)completion;
/**
 *  单单更新用户账号信息
 *
 *  @param completion 回调
 */
- (void)updateUserAccountCompletion:(CalkBackBlock)completion;

/**
 *  获取业务邦token
 *
 *  服务器是需要30分钟更新一次,我这里设置成每一次都请求
 *  @param completionBlock 回调
 */
- (void)getYWBToken:(CalkBackBlock)completionBlock;
/**
 清除用户登录信息
 */
- (void)clearData;

@end
