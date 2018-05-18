//
//  User.h
//  NightclubLive
//
//  Created by RDP on 2017/3/7.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ModelObject.h"

typedef enum{
    RoleTypeNo = -1,
    RoleTypeGeneral = 1,
    RoleTypeSeller,
    RoleTypeComapny,
}RoleType;


@interface UserDetail : ModelObject
@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *profile_photo;

@property (nonatomic, copy) NSString *autograph;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, copy) NSString *list_title;

@property (nonatomic, copy) NSString *constellation;

@property (nonatomic, assign) BOOL vehicle_certification;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *list_details;

@property (nonatomic, strong) NSURL *list_picture_url;

@property (nonatomic, assign) NSInteger usercp;

@property (nonatomic, copy) NSString *appUserRole;

@property (nonatomic, copy) NSString *dynamic_imges;

/** 动态发布时间 */
@property (nonatomic, strong) NSDate *dynamic_create_time;

/** 动态图片集合 */
@property (nonatomic, strong) NSArray *dynamicImages;

@property (nonatomic, strong) NSURL *list_video_url;

@property (nonatomic, assign) BOOL profe_certification;

@property (nonatomic, assign) BOOL seller_certification;



@property (nonatomic, copy) NSString *dynamic_city;

@property (nonatomic, assign) BOOL video_certification;

@property (nonatomic, copy) NSString *emotion;

@property (nonatomic, copy) NSString *election_capaign_id;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger userId;

/** 许愿 */
@property (nonatomic, copy) NSString *user_wish;

/** 相册图片 */
@property (nonatomic, copy) NSString *photo_imges;
/** 相册图片集合 */
@property (nonatomic, strong) NSArray *photos;

/** 职业 */
@property (nonatomic, copy) NSString *job_name;

/** 收入 */
@property (nonatomic, copy) NSString *income;

/** 认证车辆牌子 */
@property (nonatomic, copy) NSString *car_brand;
/** 关注数量 */
@property (nonatomic, copy) NSString *gzNum;
/** 粉丝数量 */
@property (nonatomic, copy) NSString *fanNum;
@end


@interface User : ModelObject
@property (nonatomic, strong) NSDate *birth_day;

@property (nonatomic, copy) NSString *userInvitationCode;

@property (nonatomic, copy) NSString *dynamic_city;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, strong) NSURL *profile_photo;

@property (nonatomic, copy) NSString *autograph;

@property (nonatomic, assign) NSInteger usercp;

@property (nonatomic, copy) NSString *appUserRole;

@property (nonatomic, assign) BOOL profe_certification;

@property (nonatomic, copy) NSString *fanNum;

@property (nonatomic, copy) NSString *income;

@property (nonatomic, copy) NSString *list_details;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, assign) BOOL vehicle_certification;

@property (nonatomic, assign) BOOL video_certification;

@property (nonatomic, copy) NSString *job_name;

@property (nonatomic, copy) NSString *gzNum;

@property (nonatomic, assign) NSInteger company_status;

@property (nonatomic, assign) BOOL company_certification;

@property (nonatomic, copy) NSString *city;


@property (nonatomic, copy) NSString *election_capaign_id;

@property (nonatomic, assign) BOOL seller_certification;

@property (nonatomic, copy) NSString *emotion;

@property (nonatomic, copy) NSString *photo_imges;
/** 相册图片 */
@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *charm_value;
/** 魅力等级 */
@property (nonatomic, assign) NSInteger charmRank;

@property (nonatomic, strong) NSURL *list_picture_url;
/** 竞选活动集合 */
@property (nonatomic, strong) NSArray *listPictureImages;

@property (nonatomic, copy) NSString *phone_num;

@property (nonatomic, copy) NSString *night_bit;

@property (nonatomic, strong) NSURL *list_video_url;

@property (nonatomic, copy) NSString *list_title;

@property (nonatomic, copy) NSString *saya_currency;

@property (nonatomic, copy) NSString *rmb;

@property (nonatomic, copy) NSString *dynamic_imges;
/** 动态图片集合 */
@property (nonatomic, strong) NSArray *dynamicImages;

@property (nonatomic, copy) NSString *constellation;

@property (nonatomic, assign) NSInteger seller_status;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *age;
/**
 *  动态创建时间
 */
@property (nonatomic, strong) NSDate *dynamic_create_time;
/** 动态创建时间 */
@property (nonatomic, copy) NSString *dynamicTimeGap;

//车辆认证URL
@property (nonatomic, copy) NSString *car_logo_url;
/** 认证的车辆 */
@property (nonatomic, copy) NSString *car_brand;
//车辆认证LOGO
@property (nonatomic, strong) NSArray *carLogos;
/** 是否关注 0-未关注 1-已经关注 */
@property (nonatomic, assign) NSInteger follow;

/** 拍拍部分 */
/** 拍拍播放视频 */
@property (nonatomic, strong) NSURL *videoUrl;
/** 拍拍封面图片 */
@property (nonatomic, strong) NSURL *coverUrl;
/** 拍拍内容 */
@property (nonatomic, copy) NSString *paipai_content;
/** 拍拍城市 */
@property (nonatomic, copy) NSString *paipai_city;
/** 拍拍创建时间 */
@property (nonatomic, strong) NSDate *paipai_createTime;
/** 拍拍创建时间差距 */
@property (nonatomic, copy) NSString *paiapiGap;
/** 土豪等级 */
@property (nonatomic, assign) NSInteger theRichNum;

// 心声部分
@property (nonatomic, copy) NSString  *heart_city;
@property (nonatomic, assign) NSInteger heart_message_type;
@property (nonatomic, copy) NSString  *heart_duration;
@property (nonatomic, strong) NSURL *heart_voicelen;
@property (nonatomic, copy) NSString  *heart_content;

@end



/**
 *  数据列表中的用户对象
 */
@interface DataUser : ModelObject


@property (nonatomic, copy) NSString *createtime;

@property (nonatomic, assign) NSInteger typeId;

@property (nonatomic, copy) NSString *modifytime;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *autograph;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) NSInteger from_user;

@property (nonatomic, assign) BOOL company_certification;

@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, assign) BOOL videoCertification;

@property (nonatomic, assign) BOOL vehicleCertification;

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

/** 是否绑定酒吧 */
@property (nonatomic, assign) BOOL isbound_bar;



@end
