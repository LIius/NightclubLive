//
//  LoginAndRegistRequest.h
//  NightclubLive
//
//  Created by WanBo on 16/12/26.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "GJModelRequest.h"
#import "ObjectRequest.h"

@interface GetCodeRequest : ObjectRequest

@end

@interface RegisterRequest : GJModelRequest

@end
@interface LoginRequest : GJModelRequest

@end
@interface UserResetRequest : ObjectRequest

@end

@interface FolkLoginRequest : GJModelRequest

@end
