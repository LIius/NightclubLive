//
//  SystemTool.m
//  NightclubLive
//
//  Created by RDP on 2017/3/21.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "SystemTool.h"


static const NSString * FirCheckUpdateURL = @"http://api.fir.im/apps/";

@interface SystemTool()<UIAlertViewDelegate>

/** 是否进行了判断 */
@property (nonatomic, assign) BOOL juge;
/** 版本更新链接 */
@property (nonatomic, copy) NSString *updateURL;

@end

@implementation SystemTool

#pragma mark - Private Method

+ (instancetype)share
{
    static SystemTool *shareClass;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        shareClass = [[SystemTool alloc] init];
    });
    
    return shareClass;
}

+ (BOOL)isOneOpen
{
    SystemTool *tool = [SystemTool share];
    
    return [tool isFirstLoad];
}

- (BOOL) isFirstLoad
{
    if (_juge)
        return _isOneOpen;
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [defaults objectForKey:USERDEFAULT_LAST_RUN_VERSION];
    
    if (!lastRunVersion) {
        [defaults setObject:currentVersion forKey:USERDEFAULT_LAST_RUN_VERSION];
        
        _isOneOpen = YES;
    }
    else if (![lastRunVersion isEqualToString:currentVersion])
    {
        [defaults setObject:currentVersion forKey:USERDEFAULT_LAST_RUN_VERSION];
        
        _isOneOpen = YES;
    }
    
    _juge = YES;
    
    return _isOneOpen;
}

#pragma mark - Public Method
+ (void)clearCacheWithCompletion:(void (^)(void))completion
{
    NSString *directoryPath =  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    // 获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    if (!isExist || !isDirectory) {
        // 抛异常
        // name:异常名称
        // reason:报错原因
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"需要传入的是文件夹路径,并且路径要存在" userInfo:nil];
        [excp raise];
        
    }
    
    // 获取cache文件夹下所有文件,不包括子路径的子路径
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
    
    for (NSString *subPath in subPaths) {
        // 拼接完成全路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        
        // 删除路径
        [mgr removeItemAtPath:filePath error:nil];
        
        
    }
    
    if (completion)
        completion();
}

// 计算缓存
+ (void)getFileSizeWithCompletion:(void (^)(NSString *))completion
{
    NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    // 获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    if (!isExist || !isDirectory) {
        // 抛异常
        // name:异常名称
        // reason:报错原因
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"笨蛋 需要传入的是文件夹路径,并且路径要存在" userInfo:nil];
        [excp raise];
        
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 获取文件夹下所有的子路径,包含子路径的子路径
        NSArray *subPaths = [mgr subpathsAtPath:directoryPath];
        
        NSInteger totalSize = 0;
        
        for (NSString *subPath in subPaths) {
            // 获取文件全路径
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            
            // 判断隐藏文件
            if ([filePath containsString:@".DS"]) continue;
            
            // 判断是否文件夹
            BOOL isDirectory;
            // 判断文件是否存在,并且判断是否是文件夹
            BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (!isExist || isDirectory) continue;
            
            // 获取文件属性
            // attributesOfItemAtPath:只能获取文件尺寸,获取文件夹不对,
            NSDictionary *attr = [mgr attributesOfItemAtPath:filePath error:nil];
            
            // 获取文件尺寸
            NSInteger fileSize = [attr fileSize];
            
            totalSize += fileSize;
        }
        
        // 计算完成回调(为了避免计算大的文件夹,比较耗时,如果直接返回结果,控制器跳转的时候回产生卡顿,所以采用block回调的方式)
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) {
                
                NSString *sizeStr = @"";
                // MB KB B
                if (totalSize > 1000 * 1000) {
                    // MB
                    CGFloat sizeF = totalSize / 1000.0 / 1000.0;
                    sizeStr = [NSString stringWithFormat:@"%@%.1fMB",sizeStr,sizeF];
                } else if (totalSize > 1000) {
                    // KB
                    CGFloat sizeF = totalSize / 1000.0;
                    sizeStr = [NSString stringWithFormat:@"%@%.1fKB",sizeStr,sizeF];
                } else if (totalSize > 0) {
                    // B
                    sizeStr = [NSString stringWithFormat:@"%@%.ldB",sizeStr,totalSize];
                }
                
                completion(sizeStr);
            }
        });
        
    });
}


- (void)checkFirVersionCompletion:(CheckUpdateCompletion)completion
{
    // 判断apitoke是否输入
    NSAssert(self.firToken, @"请设置firtoken的值");
    NSAssert(self.firID, @"请设置fir app ID");
    
    NSMutableURLRequest *r = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.fir.im/apps/?api_token=%@&latest=%@",self.firToken,self.firID]]];
    [NSURLConnection sendAsynchronousRequest:r queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSData *returnData = data;
        
        if (!data)
            return;
        
        //获取当前版本
        NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
        
        //获取本地版本号
        NSString *lappVersionStr = appInfo[@"CFBundleShortVersionString"];
        //获取本地build号
        NSString *lbuildVersionStr = appInfo[@"CFBundleVersion"];
        //总版本号string
        NSString *lVersionStr = [NSString stringWithFormat:@"%@.%@",lappVersionStr,lbuildVersionStr];
        NSInteger lVersionInt = [self versionArrayConvertVersionIntWithArr:[lVersionStr componentsSeparatedByString:@"."]];
        
        
        //获取fir 服务器版本号
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:nil];
        
        for (NSDictionary *firDic in jsonDic[@"items"]){
            
            NSString *firID = firDic[@"id"];
            if ([firID isEqual:self.firID]){
                NSDictionary *firReleaseDic = firDic[@"master_release"];
                NSString *sappVersionStr = firReleaseDic[@"version"];
                NSString *sbuildVersionStr = firReleaseDic[@"build"];
                NSString *sVersionStr = [NSString stringWithFormat:@"%@.%@",sappVersionStr,sbuildVersionStr];
                NSInteger sVersionInt = [self versionArrayConvertVersionIntWithArr:[sVersionStr componentsSeparatedByString:@"."]];
                
                NSString *updateURL = [NSString stringWithFormat:@"https://fir.im/%@",firDic[@"short"]];
                
                _updateURL = updateURL;
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(sappVersionStr,lappVersionStr,sVersionInt > lVersionInt);
                });
                break;
            }
        }
        
    }];
    
}

- (void)checkVersionCompletion:(void (^)(NSString *, NSString *, BOOL))completion
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",_appID]]];
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        
        NSData *returnData = data;
        
        if (!data)
            return;
        
        // 获取应用当前的版本号
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
        
        NSDictionary *releaseInfo = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
        NSArray *resultArr = releaseInfo[@"results"];
        
        if (resultArr.count == 0){
            // 主线程回调
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(nil,nil,NO);
            });
            
            return;
        }
        
        NSDictionary *resultDict = resultArr[0];
        //获取需要的version,trackViewUrl(更新应用的地址),trackName
        NSString *latestVersion = [resultDict objectForKey:@"version"];
        NSString *trackViewUrl1 = [resultDict objectForKey:@"trackViewUrl"];//地址trackViewUrl
        _updateURL = trackViewUrl1;
        //        //获取应用当前的版本号
        //        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
        
        
        //对比版本
        
        NSArray *currentVersionArr = [currentVersion componentsSeparatedByString:@"."];
        NSArray *storeVersionArr = [latestVersion componentsSeparatedByString:@"."];
        
        NSInteger currentInt = 0;
        NSInteger storeInt = 0;
        
        for (NSInteger i = 0 ; i < currentVersionArr.count ; i ++){
            
            NSInteger m = i == 0 ? 1 : 10;
            currentInt = currentInt * m  + [currentVersionArr[i] integerValue];
            storeInt = storeInt * m + [storeVersionArr[i] integerValue];
        }
        
        
        //主线程回调
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(latestVersion,currentVersion,storeInt > currentInt);
            
        });
    }];
    
}

- (void)autoCheckVersion
{
    [self checkVersionCompletion:^(NSString *storeVersion, NSString *currentVersion, BOOL canUpdate) {
        if (canUpdate){
            
            
            UIAlertView *ac  = [[UIAlertView alloc] initWithTitle:@"版本更新" message:@"检测到新版本是否要更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
            
            [ac show];
        }
    }];
}

- (void)autoCheckFirVersion
{
    [self checkFirVersionCompletion:^(NSString *storeVersion, NSString *currentVersion, BOOL canUpdate)
    {
        if (canUpdate)
        {
            UIAlertView *ac  = [[UIAlertView alloc] initWithTitle:@"版本更新" message:@"检测到新版本是否要更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
            
            [ac show];
        }
    }];
}

- (void)beginUpdateApp
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_updateURL]];
}

- (NSInteger)versionArrayConvertVersionIntWithArr:(NSArray <NSString *> *)arr
{
    NSInteger versionInt = 0;
    
    for (NSInteger i = 0 ; i < arr.count ; i ++){
        
        NSInteger m = [arr[i] integerValue];
        
        versionInt = versionInt * 10 + m;
    }
    
    return versionInt;
}

+ (void)setToolConfigWithAppID:(NSString *)appID
{
    [SystemTool share].appID = appID;
}

#pragma mark - Getter

- (NSString *)appStoreVersion{
    
    if (!_appStoreVersion){
        
        NSString *ver = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _appStoreVersion = ver;
    }
    return _appStoreVersion;
}


#pragma mark - UIAlert

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1)
        [self beginUpdateApp];
}
@end
