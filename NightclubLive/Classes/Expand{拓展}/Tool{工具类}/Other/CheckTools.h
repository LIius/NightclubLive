//
//  CheckTools.h
//
//  Created by SuperDanny on 14/12/8.
//  Copyright (c) 2014年 SuperDanny. All rights reserved.
//
//  逻辑检查工具

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//相机、相册、麦克风、通讯录
typedef enum : NSUInteger {
    ///相机权限
    CameraPermissions,
    ///相册权限
    PhotoPermissions,
    ///麦克风权限
    MicrophonePermissions,
    ///通讯录权限
    AddressBookPermissions,
} PermissionsType;

@interface CheckTools : NSObject
/**
 *  检查网络
 *
 *  @return yes==网络畅通。no=网络不可用
 */
+ (BOOL)checkNetWork;

/**
 *  只能输入数字
 *
 *  @param number 数字
 */
+ (BOOL)isNumber:(NSString *)number;

/**
 *  只能输入数字小数点
 *
 *  @param str sf
 *
 *  @return asdf
 */
+ (BOOL)isCountNumber:(NSString *)str;

/**
 *  检查字符串是否是身份证号
 *
 *  @param identityCard 身份证
 *
 */
+ (BOOL)isValidateIdentityCard:(NSString *)identityCard;

/**
 *  检查密碼格式(字符和数字)
 *
 *  @param key 密碼
 */
+ (BOOL)isValidateKeyNum:(NSString *)key;

/**
 *  @author LvChanghui, 15-06-18 10:06:51
 *
 *  检查密码位数判断
 *
 *  @param pwd 密码
 */
+ (BOOL)isCheckPassword:(NSString *)pwd;

/**
 *  检测邮箱是否合法
 *
 *  @param candidate 邮箱
 */
+ (BOOL)isValidateEmail:(NSString *)candidate;

/**
 *  检测网址是否合法
 *
 *  @param url 网址
 *
 */
+ (BOOL)isValidateURL:(NSString *)url;

/**
 *  检测手机号是否合法
 *
 *  @param mobileNum 手机号
 */
+ (BOOL)isValidateMobileNumber:(NSString *)mobileNum;

/**
 *  检测登陆用户名是否合法
 *
 *  @param account 用户名
 */
+ (BOOL)isLoginAccount:(NSString *)account;

/**
 *  真实姓名，汉字
 *
 *  @param realname 姓名
 */
+ (BOOL)isRealName:(NSString *)realname;

/**
 *  判断是否为整型
 */
+ (BOOL)isPureInt:(NSString*)string;

/**
 *  判断是否为浮点型
 */
+ (BOOL)isPureFloat:(NSString*)string;

/**
 *  判断手机权限（相机、相册、麦克风、通讯录）
 *
 *  @param type 权限类型
 *
 *  @return 是否开启权限
 */
+ (BOOL)isPermissionsWithType:(NSUInteger)type;

///避免使用数据的时候出现空或者其他的，导致闪退
+ (NSString *)filterNULLValue: (NSString *)string;

@end
