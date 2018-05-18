//
//  SystemTool.h
//  NightclubLive
//
//  系统工具
//  Created by RDP on 2017/3/21.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  检查更新之后的回调
 *
 *  @param storeVersion   商店(或者fir)版本号
 *  @param currentVersion 当前版本号
 *  @param canUpdate      能否进行更新
 */
typedef void (^CheckUpdateCompletion)(NSString *storeVersion,NSString *currentVersion,BOOL canUpdate);

@interface SystemTool : NSObject
/** 当前软件版本号 */
@property (nonatomic, copy) NSString *currentVersion;
/** 服务器版本号 */
@property (nonatomic, copy) NSString *appStoreVersion;
/** 服务器ID */
@property (nonatomic, copy) NSString *appID;
/** 是否有新版本 */
@property (nonatomic, assign) BOOL isNewVersion;
@property (nonatomic, assign) BOOL isOneOpen;

/** fir im api token */
@property (nonatomic, copy) NSString *firToken;
/** fir app id */
@property (nonatomic, copy) NSString *firID;


/** 未上架检查自动更新 */
+ (instancetype)share;

/**
 *  配置APPID
 *
 *  @param appID APPID
 */
+ (void)setToolConfigWithAppID:(NSString *)appID;
/**
 *  判断是否是第一次打开
 *
 *  @return YES or NO
 */
+ (BOOL)isOneOpen;

/**
 *
 * 获取缓存大小
 */
+ (void)getFileSizeWithCompletion:(void(^)(NSString*))completion;

/**
 * 清除缓存
 */
+ (void)clearCacheWithCompletion:(void (^)(void))completion;

/**
 *  检测本地与服务器版本号
 *
 *  @param completion 完成调用的回调
 */
- (void)checkVersionCompletion:(CheckUpdateCompletion)completion;
/**
 *  检测fir版本号
 *
 *  @param completion 完成的回调
 */
- (void)checkFirVersionCompletion:(CheckUpdateCompletion)completion;
/**
 *  自动检查版本（软件启动时候）
 */
- (void)autoCheckVersion;
/**
 *  自动检查fir版本号
 */
- (void)autoCheckFirVersion;
/**
 *  开始更新APP
 */
- (void)beginUpdateApp;
@end
