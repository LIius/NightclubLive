//
//  LRUserInfoViewController.h
//  NightclubLive
//
//  用户资料填写
//  Created by RDP on 2017/3/28.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectViewController.h"

@interface LRUserInfoViewController : ObjectViewController
@property (nonatomic, copy) NSString *authCode;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *paw;
@property (nonatomic, copy) NSString *invitationCode;
@end
