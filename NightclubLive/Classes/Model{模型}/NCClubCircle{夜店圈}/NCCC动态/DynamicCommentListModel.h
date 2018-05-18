//
//  DynamicCommentListModel.h
//  NightclubLive
//
//  Created by WanBo on 17/1/9.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentVehicle : NSObject

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

@interface ToUser : NSObject

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

@interface DynamicCommentListUser : ModelObject

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

@interface DynamicCommentListModel : ModelObject

@property (nonatomic, copy)NSString *typeId;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *count;
@property (nonatomic, copy)NSString *subjectId;
@property (nonatomic, strong)NSDate *createtime;
@property (nonatomic, copy)NSString *toUserId;
@property (nonatomic, copy)NSString *modifytime;
//是否点赞
@property (nonatomic, assign) NSInteger ispraise;
//点赞数量
@property (nonatomic, assign) NSInteger praise;
@property (nonatomic, strong)ToUser *toUser;
@property (nonatomic, strong)DynamicCommentListUser *user;
@property (nonatomic, strong)CommentVehicle *vehicle;
@property (nonatomic, copy) NSString *from_user_name;
@property (nonatomic, strong) NSURL *from_user_img;
/** cell高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end

@interface DynamicCommentListSuperModel : NSObject

@property (nonatomic, strong)NSArray<DynamicCommentListModel*> *result;

@property (nonatomic, copy)NSString *state;

@end


