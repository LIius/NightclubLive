//
//  AuthModel.h
//  NightclubLive
//
//  Created by RDP on 2017/3/15.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ModelObject.h"

static NSString *handheldImageKey = @"handheldImage";
static NSString *positiveImageKey = @"positiveImage";
static NSString *backImageKey     = @"backImage";

/**
 *  职业认证封装类
 */
@class User;
@interface AuthJobModel : ModelObject

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *modifyTime;

@property (nonatomic, copy) NSString *idnumber;

@property (nonatomic, copy) NSString *occupation;

@property (nonatomic, copy) NSString *idimageUrl;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSDictionary *idiImageDic;

@end


/**
 *  视频认证
 */
@interface AuthVideoModel : ModelObject

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *modifyTime;

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) NSURL *coverUrl;

@property (nonatomic, copy) NSString *createTime;


@end


@interface CarAuthModel : ModelObject

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, assign) NSInteger carBrand;

@property (nonatomic, strong) NSURL *license;

@property (nonatomic, copy) NSString *brand;

@property (nonatomic, strong) NSURL *sign;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *car_name;
@end





