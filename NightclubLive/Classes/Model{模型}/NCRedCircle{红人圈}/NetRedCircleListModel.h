//
//  NetRedCircleListModel.h
//  NightclubLive
//
//  Created by RDP on 2017/5/5.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ModelObject.h"

/**
 *  找人接口
 */
@class Professionname;
@interface FindUserModel : ModelObject

@property (nonatomic, assign) NSInteger typeId;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger from_user;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *autograph;

@property (nonatomic, strong) Professionname *professionName;

@property (nonatomic, assign) BOOL company_certification;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, assign) BOOL videoCertification;

@property (nonatomic, assign) BOOL vehicleCertification;

@property (nonatomic, copy) NSString *userInvitationCode;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, assign) NSInteger sellerId;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NSInteger occupation;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, assign) NSInteger appUserRole;

@property (nonatomic, assign) NSInteger distance;

@property (nonatomic, copy) NSString *passWord;

@property (nonatomic, strong) NSURL *profilePhoto;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) BOOL sellerCertification;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *phoneNum;

@property (nonatomic, assign) NSInteger income;

@property (nonatomic, assign) BOOL profeCertification;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) NSInteger emotion;

@property (nonatomic, copy) NSString *car_logo_url;
@property (nonatomic, strong) NSArray *carUrl;
/** 邀约次数 */
@property (nonatomic, copy) NSString *order_count;

@end

@interface Professionname : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *name;



@end


/**
 *  排行榜对象
 */
@interface RankListModel : ModelObject

@property (nonatomic, copy) NSString *daifug_value;

@property (nonatomic, copy) NSString *charm_value;

@property (nonatomic, copy) NSString *autograph;

@property (nonatomic, copy) NSString  *user_id;

@property (nonatomic, copy) NSString *contribution_value;

/** 头像 */
@property (nonatomic, strong) NSURL *profile_photo;
/** 姓名 */
@property (nonatomic, copy) NSString *user_name;


@end


/**
 *  酒吧封装对象
 */
@interface NetRedCircleBarModel : ModelObject

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *seller_id;

@property (nonatomic, copy) NSString *distance;

@property (nonatomic, copy) NSString *seller_name;

@property (nonatomic, copy) NSString *seller_logo;

@property (nonatomic, copy) NSString *tel;

/** 是否是热门 */
@property (nonatomic, assign) BOOL isHot;
/** 是否是热门 */
@property (nonatomic, copy) NSString *is_hot;
/** 酒吧类型 */
@property (nonatomic, copy) NSString *bar_type;
/** 酒吧类型int */
@property (nonatomic, assign) NSInteger barType;

/** 酒吧连接 */
@property (nonatomic, strong) NSURL *logoURL;
//酒吧名字所需要的长度
@property (nonatomic, assign) CGFloat  nameWidth;
@end

/**
 *  酒吧详情
 */
@interface NetRedCircleBarDetailModel : ModelObject


@property (nonatomic, copy) NSString *business_hours_start;

@property (nonatomic, copy) NSString *banner;

@property (nonatomic, copy) NSString *party_id;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) NSInteger distance;

@property (nonatomic, copy) NSString *party;
/** 活动图片 图片 */
@property (nonatomic, strong) NSURL *parytyImage;


@property (nonatomic, copy) NSString *business_hours_end;

@property (nonatomic, copy) NSString *tel;

@property (nonatomic, copy) NSString *bar_type;

/** 酒吧描述 */
@property (nonatomic, copy) NSString *introduction;

/** 轮播 */
@property (nonatomic, strong) NSArray *banners;

/** 已经申请加入酒吧 */
@property (nonatomic, assign) BOOL is_bang;

/** 纬度 */
@property (nonatomic, assign) CGFloat latitude;

/** 经度 */
@property (nonatomic, assign) CGFloat longitude;

/** 活动详情string */
@property (nonatomic, copy) NSString *party_details;

/** 活动详情url */
@property (nonatomic, strong) NSURL *party_details_url;

/** 座位表 */
@property (nonatomic, copy) NSString *seat_img;
/** 座位表image */
@property (nonatomic, strong) NSURL *seatImageURL;


@end

@interface BarActivityModel : ModelObject

@property (nonatomic, copy) NSString *party_name;

@property (nonatomic, copy) NSString *party_id;

@property (nonatomic, copy) NSString *start_time;

@property (nonatomic, copy) NSString *end_time;

@property (nonatomic, copy) NSString *cover_image;
/** 活动方面 */
@property (nonatomic, strong) NSURL *coverImage;

/** 活动链接 */
@property (nonatomic, copy) NSString *party_details;

/** 活动详情url */
@property (nonatomic, strong) NSURL *party_details_url;
@end


/**
 *  酒吧人排行榜
 */
@interface BarPersonRankModel : ModelObject

@property (nonatomic, assign) NSInteger order_count;

@property (nonatomic, assign) NSInteger charm_value;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *autograph;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, copy) NSString  *contribute_value;
/** 头像 */
@property (nonatomic, strong) NSURL *profile_photo;

@end
