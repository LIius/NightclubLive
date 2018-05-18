//
//  HeartsoundListModel.h
//  NightclubLive
//
//  Created by WanBo on 17/1/9.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeartsoundVehicle : NSObject

@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *remark;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *drivingLicense;
@property (nonatomic, copy)NSString *carBrand;
@property (nonatomic, copy)NSString *sign;
@property (nonatomic, copy)NSString *createtime;
@property (nonatomic, copy)NSString *modifytime;

@end
@interface HeartsoundUser : NSObject

@property (nonatomic, copy)NSString *typeID;
@property (nonatomic, copy)NSString *remark;
@property (nonatomic, copy)NSString *modifytime;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *autograph;
@property (nonatomic, copy)NSString *sex;
@property (nonatomic, copy)NSString *videoCertification;
@property (nonatomic, copy)NSString *constellation;
@property (nonatomic, copy)NSString *vehicleCertification;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *sign;
@property (nonatomic, copy)NSString *passWord;
@property (nonatomic, copy)NSString *profilePhoto;
@property (nonatomic, copy)NSString *age;
@property (nonatomic, copy)NSString *sellerCertification;
@property (nonatomic, copy)NSString *userName;
@property (nonatomic, copy)NSString *phoneNum;
@property (nonatomic, copy)NSString *emotion;
@property (nonatomic, copy)NSString *profeCertification;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *createtime;

@end


@interface HeartsoundListModel : ModelObject

@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *content;

@property (nonatomic, strong)NSDate *createtime;
@property (nonatomic, copy)NSString *anonymous;
@property (nonatomic, copy)NSString *messageType;
@property (nonatomic, copy)NSString *longitude;
@property (nonatomic, copy)NSString *modifytime;
@property (nonatomic, copy)NSString *latitude;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *provice;
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *voicelen;
@property (nonatomic, copy)NSString *address;

@property (nonatomic, assign)NSInteger praise;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *district;
@property (nonatomic, copy)NSString *duration;
@property (nonatomic, assign) NSInteger criticismCount;
@property (nonatomic, strong)HeartsoundUser *user;
@property (nonatomic, strong)HeartsoundVehicle *vehicle;
/** 是否点赞 */
@property (nonatomic, assign) NSInteger ispraise;


@end

@interface HeartsoundListSuperModel : NSObject

@property (nonatomic, strong)NSArray<HeartsoundListModel*> *result;

@property (nonatomic, copy)NSString *state;

@end
