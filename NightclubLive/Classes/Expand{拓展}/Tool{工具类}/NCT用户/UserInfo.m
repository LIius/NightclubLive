//
//  UserInfo.m
//  NightclubLive
//
//  Created by RDP on 2017/2/28.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "UserInfo.h"
#import "LocationTool.h"
#import "BaseTabBarController.h"
#import "NCLoginVC.h"
#import "UIAlertController+Factory.h"
#import "RLLRequest.h"
#import "MineRequest.h"
#import "MineModelList.h"
#import "UserDetailRequest.h"
#import "GlobalRequest.h"
#import <SAMKeychain.h>
#import "UIWindow+CurrentViewController.h"
#import "ObjectNavigationController.h"


@interface UserInfo()<NIMLoginManagerDelegate>
{
    NSString *_lgUserID;
}
/** 网络请求返回数据集合 */
@property (nonatomic, strong) NSDictionary *sourceDic;


@end

@implementation UserInfo

#pragma mark - Realm

+ (NSArray<NSString *> *)ignoredProperties
{
    return @[@"user",@"location",@"sourceDic"];
}

+ (NSString *)primaryKey
{
    return @"lgPhone";
}

#pragma mark - Init

static UserInfo *shareUser;

+ (instancetype)shareUser{
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        shareUser = [[UserInfo alloc] init];
        

        [shareUser getLocation];
        
    });
    
    return shareUser;
}

#pragma mark - Public Method

/**
 *  设置用户资料
 *
 *  @param userDataDic1 用户资料字典1
 *  @param userDataDic2 用户资料字典2
 *  @param userToken   用户token
 
 */
- (void)settingUserData:(NSDictionary *)userDataDic1 withUserData:(NSDictionary *)userDataDic2 withToken:(NSString *)userToken
{
    _yunxinToken = userDataDic2[@"yiyun_token"];
    _lgUserID = [NSString stringWithFormat:@"%@",userDataDic2[@"id"]];
    _token = userToken;
    _user = [[User alloc] initWithDic:userDataDic1];
    
    // 保存资料
    [SAMKeychain setPassword:_lgPhone forService:USERDEFAULT_KEYCHAIN_SERVERNAME account:USERDEFAULT_PHONE];
    [SAMKeychain setPassword:_lgPaw forService:USERDEFAULT_KEYCHAIN_SERVERNAME account:USERDEFAULT_PASSWORD];
    [SAMKeychain setPassword:_thirdUID forService:USERDEFAULT_KEYCHAIN_SERVERNAME account:USERDEFAULT_THIRDUID];

    
    // 保存用户资料
    NSString *jsonDataStr1 = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:userDataDic1 options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    NSString *jsonDataStr2 = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:userDataDic2 options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];

    [defaults setValue:jsonDataStr1 forKey:USERDEFAULT_USERDATAKEY1];
    [defaults setValue:jsonDataStr2 forKey:USERDEFAULT_USERDATAKEY2];
    [defaults setValue:_yunxinToken forKey:USERDEFAULT_YUNXINTOKEN];
    [defaults setValue:_token forKey:USERDEFAULT_USERTOKEN];
    [defaults synchronize];

    _status = CurrentUserStatusLoginIn;
    
    // 获取用户账号信息 and 账号信息
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINFINISH object:nil];
}

- (void)loginSuccessWithData:(ResponseState *)responseData
{
    NSDictionary *loginData = responseData.optional;
    
    // 保存用户资料 /用户账号密码云信token
    _yunxinToken = loginData[@"yiyun_token"];
    _lgUserID = [NSString stringWithFormat:@"%@",loginData[@"id"]];
    _token = responseData.data[@"user_token"];

    // 使用钥匙串保存账号密码
    [SAMKeychain setPassword:_lgPhone forService:USERDEFAULT_KEYCHAIN_SERVERNAME account:USERDEFAULT_PHONE];
    [SAMKeychain setPassword:_lgPaw forService:USERDEFAULT_KEYCHAIN_SERVERNAME account:USERDEFAULT_PASSWORD];
    [SAMKeychain setPassword:_thirdUID forService:USERDEFAULT_KEYCHAIN_SERVERNAME account:USERDEFAULT_THIRDUID];
    _status = CurrentUserStatusLoginIn;
    
    // 保存其他用户资料
//    NSString *jsonDataStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:loginData options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
//    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    //保存用户资料
    //[defaults setValue:jsonDataStr forKey:UserDataKey];
    // 更新用户资料
    [self updateUserDataCompletion:^(id param) {
        
    }];
    
   // [self loginYunxin];
}

+ (void)autoLogin
{
    // 先获取本地数据
    UserInfo *user =  [UserInfo shareUser];
    
    NSString *name = [SAMKeychain passwordForService:USERDEFAULT_KEYCHAIN_SERVERNAME account:USERDEFAULT_PHONE];
    NSString *paw = [SAMKeychain passwordForService:USERDEFAULT_KEYCHAIN_SERVERNAME account:USERDEFAULT_PASSWORD];
    NSString *thirduid = [SAMKeychain passwordForService:USERDEFAULT_KEYCHAIN_SERVERNAME account:USERDEFAULT_THIRDUID];
    
    // 自动读取用户资料
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    // 保存用户资料
    NSString *userDataJSONString1 = [defaults valueForKey:USERDEFAULT_USERDATAKEY1];
    NSString *userDataJSONString2 = [defaults valueForKey:USERDEFAULT_USERDATAKEY2];

    user.lgPhone = name;
    user.lgPaw = paw;
    user.thirdUID = thirduid;

    if (userDataJSONString1 && userDataJSONString2)
    {
        NSDictionary *userDataDict1 = [NSJSONSerialization JSONObjectWithData:[userDataJSONString1 dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *userDataDict2 = [NSJSONSerialization JSONObjectWithData:[userDataJSONString2 dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *yunxin = [defaults valueForKey:USERDEFAULT_YUNXINTOKEN];
        NSString *token = [defaults valueForKey:USERDEFAULT_USERTOKEN];
        
        user.yunxinToken = yunxin;
        user.token = token;
        NSLog(@"[yunxinToken=%@]--%@",yunxin,token);
        
        [user settingUserData:userDataDict1 withUserData:userDataDict2 withToken:token];
        
        // 自动登录云信{会读取云信缓存信息}
        NIMAutoLoginData *loginData = [[NIMAutoLoginData alloc] init];
        loginData.account = user.lgPhone;
        loginData.token = user.yunxinToken;
        [[NIMSDK sharedSDK].loginManager autoLogin:loginData];
#warning 更改登录token为运行token，之前写的是user.token
//        [[NIMSDK sharedSDK].loginManager login:user.lgPhone token:user.yunxinToken completion:^(NSError * _Nullable error) {
//
//        }];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINFINISH object:nil];
}

+ (void)autoLoginServer
{
    // 如果存在手机号码或者第三方资料就执行登录
    if ((CurrentUser.lgPhone && CurrentUser.lgPaw ) || CurrentUser.thirdUID)
    {
        [CurrentUser loginWithCompletion:^(ResponseState *state)
        {
            if(state.responseCode == 2)
            {
                [CurrentUser clearData];
                [UserInfo needLogin];
            }
        }];
    }
}

- (void)loginWithCompletion:(void (^)(ResponseState *))completion
{
    SignOnRequest *r = [SignOnRequest new];
    
    if (_lgPhone && _lgPaw){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (self.lgPhone.length >0) {
            [params setValue:self.lgPhone forKey:@"phoneNum"];
        }
        if (self.lgPaw.length > 0) {
            [params setValue:self.lgPaw forKey:@"passWord"];
        }
        r.param = params;
        //r.param = @{@"phoneNum":self.lgPhone,@"passWord":self.lgPaw};
    }
    else{
        NSArray *typeArray = @[@"",@"weixin_uid",@"qq_uid",@"weibo_uid"];
        NSString *key = [typeArray stringAtIndex:self.thirdType];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (_thirdUID) {
            [params setValue:_thirdUID forKey:key];
        }
        r.param = params;
        //r.param = @{key:_thirdUID};
    }
    
    /**
     *  这里需要登录两个才能算成功。1，登录自家服务器成。2，登录云信服务器成功。
     *  二者缺一不可
     */
    
    @weakify(self);
    [r startRequestWithCompleted:^(ResponseState *state) {
        @strongify(self);
        if (!state){
            ShowError(@"网络错误");
            
            if (completion)
                completion(state);

        }
        else{
            // 登录成功
            if (state.isSuccess){
                
                [[NIMSDK sharedSDK].loginManager login:state.data[@"phoneNum"] token:state.optional[@"yiyun_token"] completion:^(NSError * _Nullable error) {
                    
                    if (error){
                      //  ShowError(@"登录聊天服务器失败");
                    }
                }];
                
                // 设置对应用户的信息
                [self settingUserData:[state.result firstObject] withUserData:state.data withToken:state.data[@"user_token"]];

                // 更新用户资料
                [self updateUserDataCompletion:^(id param) {
                    
                }];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_LOGINFINISH object:nil];
                
                if (completion)
                    completion(state);
                
            }
            else{
                // 登录失败
                ShowError(state.message);
                completion(state);
            }

        }
    }];

}

- (void)loginOut
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要退出登录?" preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 清除用户资料
        [self clearData];

        [ShareWindow.rootViewController presentViewController:[[ObjectNavigationController alloc] initWithRootViewController:[[NCLoginVC alloc]init]] animated:YES completion:nil];
        
        // 发送通知
        [KNotificationCenter postNotificationName:NOTIFICATION_LOGINOUT object:nil];
    }]];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    
    _status = CurrentUserStatusSignOut;
    
    [SharedAppDelegate.window.rootViewController presentViewController:ac animated:YES completion:nil];
}

- (void)changePawNeedLogin
{
    [CurrentUser clearData];
    
    /*UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" withMessage:@"修改密码成功，请重新登录" calk:^(id param) {
        [ShareWindow.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:[LoginVC initSBWithSBName:@"RegisterAndLogin"]] animated:YES completion:nil];
        
    }];
    
    [SharedAppDelegate.window.rootViewController presentViewController:ac animated:YES completion:nil];*/
}

#pragma mark - Private
- (void)clearData
{
    // 退出云信
    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError * _Nullable error) {
        
    }];
    
    // 清除登录用户信息
    // self.lgPhone = nil;
    // self.userID  = nil;
    self.lgPaw   = nil;
    _lgUserID = nil;
    _user    = nil;
    _yunxinToken = nil;
    _user = nil;
    _account = nil;
    
    // 清除保存的密码
    // 使用钥匙串保存账号密码
    [SAMKeychain deletePasswordForService:USERDEFAULT_KEYCHAIN_SERVERNAME account:USERDEFAULT_PASSWORD];
    [SAMKeychain deletePasswordForService:USERDEFAULT_KEYCHAIN_SERVERNAME account:USERDEFAULT_THIRDUID];
    
    NSUserDefaults *defaults =  [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:USERDEFAULT_USERDATAKEY1];
    [defaults removeObjectForKey:USERDEFAULT_USERDATAKEY2];
    [defaults removeObjectForKey:USERDEFAULT_YUNXINTOKEN];
    [defaults removeObjectForKey:USERDEFAULT_USERTOKEN];
    [defaults synchronize];
    
    _status = CurrentUserStatusSignOut;
}

- (void)loginYunxinWithCompletion:(CalkBackBlock)completionBlock
{
    [[NIMSDK sharedSDK].loginManager login:_lgPhone token:_yunxinToken completion:^(NSError * _Nullable error) {
        
    }];
}

#pragma mark - 获取资料
- (void)updateUserAccountCompletion:(CalkBackBlock)completion
{
    MyAccountRequest *r = [MyAccountRequest new];
    
    [r startRequestWithCompleted:^(ResponseState *state) {
        
        AccountModel *m = [[AccountModel arrayObjectWithDS:state.data] firstObject];
        
        _account = m;
        
        if (completion)
        {
           completion(@(state.isSuccess));
        }
        
    }];
}

#pragma mark - 获取用户详细资料
- (void)updateUserDataCompletion:(CalkBackBlock)completion
{
    UserDetailRequest *r = [UserDetailRequest new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.userID.length >0)
    {
        [params setValue:self.userID forKey:@"userId"];
    }
    r.param = params;
    //r.param = @{@"userId":self.userID};
    [r startRequestWithCompleted:^(ResponseState *state) {
   
        if (state.isSuccess)
        {
            User *user = [[User arrayObjectWithDS:state.data] firstObject];
            
            _user = user;
        }
        
        if (completion)
        {
            completion(@(state.isSuccess));
        }
    
    }];
    
    // 获取用户土豪等级
    PersonRankListRequest *rankR = [PersonRankListRequest new];
    rankR.model = self.userID;
    [rankR startRequestWithCompleted:^(ResponseState *state)
    {
        TheRichModel *m = [[TheRichModel alloc] initWithDic:[state.datas firstObject]];
        _user.theRichNum = m.rankNum;
    }];
}

- (void)updateUserDataAndAccountCompletion:(CalkBackBlock)completion
{
    __block BOOL isSuccuess = YES;
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        // 更新用户信息
        dispatch_group_enter(group);
        [self updateUserDataCompletion:^(id param) {
            dispatch_group_leave(group);
            isSuccuess = [param boolValue];
        }];
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        
        // 更新用户账号
        dispatch_group_enter(group);
        [self updateUserAccountCompletion:^(id param) {
            dispatch_group_leave(group);
            isSuccuess = [param boolValue];
        }];
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 通知
        if (completion)
            completion(@(isSuccuess));
    });
    
}


/**
 *  获取定位信息
 */
- (void)getLocation
{
    Location *l = [Location new];
    _location = l;
    // 获取定位信息(异步)
    [[LocationTool shareTool] startLocationFinish:^(NSDictionary *locations) {
                l.lclongitude = locations[LocationLongitude];
        l.lclatitude  = locations[LocationLatitude];
        l.lccity      = locations[LocationCity];
        l.lcprovince  = locations[LocationProvince];
        l.lcaddress   = locations[LocationAddress];
        l.district   = locations[LocationDistrict];
        _location = l;
        
    } withErrorBlock:^(NSString *error) {
        
    }];
}

+ (void)needLogin
{
    BOOL isShowLoginAlert = CurrentUser.isShowLoginAlert;
    
    if (!isShowLoginAlert)
    {
        // 进来就表示已经显示
        CurrentUser.isShowLoginAlert = YES;

        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"登录提示" withMessage:@"此操作需要先登录" calk:^(id param)
        {
            // 点了后就没显示
            CurrentUser.isShowLoginAlert = NO;

            [[ShareWindow zf_currentViewController] presentViewController:[[ObjectNavigationController alloc] initWithRootViewController:[[NCLoginVC alloc]init]] animated:YES completion:nil];

        }];

        
        
        
        UIViewController *pushVC = [ShareWindow zf_currentViewController];
        if ([pushVC isKindOfClass:[NCLoginVC class]])
        {
            pushVC = ShareWindow.rootViewController;
        }
        // 展示弹出框
        [pushVC presentViewController:ac animated:YES completion:^
        {
            [CurrentUser clearData];
        }];
    }
}

+ (void)loginChange
{
    [CurrentUser clearData];
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" withMessage:@"当前账号已经在其他端登录" calk:^(id param) {

        [ShareWindow.rootViewController presentViewController:[[ObjectNavigationController alloc] initWithRootViewController:[[NCLoginVC alloc]init]] animated:YES completion:nil];
        
    }];
    
    [SharedAppDelegate.window.rootViewController presentViewController:ac animated:YES completion:nil];
}

#pragma mark - Getter
- (NSString *)userID
{
    if (!_lgUserID){
        
        return @"-1";
    }
    
    return _lgUserID;
}

#pragma mark - Setter
- (void)setSourceDic:(NSDictionary *)sourceDic
{
    _sourceDic = sourceDic;
    
    _user = [[User alloc] initWithDic:sourceDic];
    
    if (!_lgPhone)
        _lgPhone = sourceDic[@"phoneNum"];
    
    if (!sourceDic)
        return;
    
    _lgUserID = [NSString stringWithFormat:@"%@",sourceDic[@"id"]];
    _yunxinToken = sourceDic[@"yiyun_token"];
  //  _user.profile_photo = URL(_user.userDetail.profile_photo);
}

- (void)reSetUserData:(User *)user
{
    _user = user;
}

#pragma mark - 获取夜务帮token
- (void)getYWBToken:(CalkBackBlock)completionBlock
{
    GetYWBTokenReqeuest *tokenR = [GetYWBTokenReqeuest new];
    
    [tokenR startRequestWithCompleted:^(ResponseState *state) {
        
        // 判断是否绑定，如果没有绑定就先绑定然后再一次获取
        if (!state.token)
        {
            // 没有绑定小程序
            // 先绑定再获取
            BindMiniProgramRequest *bindR = [BindMiniProgramRequest new];
            [bindR startRequestWithCompleted:^(ResponseState *state) {
                // 绑定成功
                if (state.responseCode == 0){
                    
                    GetYWBTokenReqeuest *tokenRAgain = [GetYWBTokenReqeuest new];
                    
                    [tokenRAgain startRequestWithCompleted:^(ResponseState *state) {
                        completionBlock(state.token);
                    }];
                }
                else{
                    ShowError(state.message);
                }
            }];
            
        }
        else{
            completionBlock(state.token);
        }
    }];
}

@end

