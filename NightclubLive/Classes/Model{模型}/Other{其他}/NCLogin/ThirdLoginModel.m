//
//  ThirdLoginModel.m
//  NightclubLive
//
//  Created by RDP on 2017/3/29.
//  Copyright © 2017年 WanBo. All rights reserved.
//


/*
 
 * 登录UID 
@property (nonatomic, copy) NSString *uid;
* 用户昵称 
@property (nonatomic, copy) NSString *userName;
* 用户头像 
@property (nonatomic, copy) NSString *userImg;
* 性别 
@property (nonatomic, assign) NSInteger sex;
* 性别字符串 
@property (nonatomic, copy) NSString *sexStr;
* 城市 
@property (nonatomic, copy) NSString *city;

 */
#import "ThirdLoginModel.h"

@implementation ThirdLoginModel

- (void)setOptional:(id)optional{
    
    _uid = optional[@"uid"];
     _userName = optional[@"nickname"];
    
    //QQ
    if (_loginType == 2){
        _userImg  = optional[@"figureurl_qq_2"];
        _sex      = [optional[@"gender"] isEqualToString:@"男"] ? 1 : 0;
     //   _city     = optional[@"province"];
    }
    else if (_loginType == 1){//微信
        _userImg = optional[@"headimgurl"];
        _sex     = [optional[@"sex"] integerValue];
       // _city =
    }
    else{//微博
        _userName = optional[@"name"];
        _userImg = optional[@"avatar_large"];
        _sex = [optional[@"gender"] isEqualToString:@"m"] ? 1 : 0;
      //  _city = [[optional[@"location"] componentsSeparatedByString:@" "] lastObject];
    }
    
}

@end
