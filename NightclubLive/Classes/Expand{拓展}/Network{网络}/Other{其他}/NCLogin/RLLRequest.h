//
//  RLLRequest.h
//  NightclubLive
//
//  注册 登录 忘记密码
//  Created by RDP on 2017/3/28.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectRequest.h"

/**
 *  注册
 */
@interface SignInRequest : ObjectRequest

@end

/**
 *  登录
 */
@interface SignOnRequest : ObjectRequest

@end

/**
 *  第三方绑定
 */
@interface BindPhoneRequest : ObjectRequest

@end


/**
 *  修改密码
 */
@interface ChangePawRequest : ObjectRequest

@end
