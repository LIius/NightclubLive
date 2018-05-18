//
//  RLLRequest.m
//  NightclubLive
//
//  Created by RDP on 2017/3/28.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "RLLRequest.h"

@implementation SignInRequest

- (NSString *)path{
    
    return @"user/userRegister.do";
}

@end


@implementation SignOnRequest

- (NSString *)path{
    
    return @"user/userLogin.do";
}

@end

@implementation BindPhoneRequest

- (NSString *)path{
    return @"user/thirdpartyRegister.do";
}
@end

@implementation ChangePawRequest

- (NSString *)path{
    
    return @"user/modifyPassWord.do";
}

@end
