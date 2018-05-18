//
//  DynamicListModel.h
//  NightclubLive
//
//  Created by WanBo on 17/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelObject.h"

@interface Vehicle : NSObject

@property (nonatomic, copy)NSString *carBrand;
@property (nonatomic, copy)NSString *createtime;
@property (nonatomic, copy)NSString *drivingLicense;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *modifytime;
@property (nonatomic, copy)NSString *remark;
@property (nonatomic, copy)NSString *sign;
@property (nonatomic, strong) NSArray *signArr;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *userId;
@end


@interface DynamicListUser : NSObject

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

@interface DynamicListModel : ModelObject

@property (nonatomic, copy)NSString *ID;
@property (nonatomic, strong)NSDate *createtime;
@property (nonatomic, copy)NSString *longitude;
@property (nonatomic, copy)NSString *modifytime;
@property (nonatomic, copy)NSString *latitude;
@property (nonatomic, copy)NSString *provice;
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, assign)int praise;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, strong)NSArray *images;
@property (nonatomic, copy) NSString *imagesStr;
@property (nonatomic, copy) NSString *criticismCount;
@property (nonatomic, copy)NSString *district;
@property (nonatomic, strong) DataUser *user;
@property (nonatomic, strong)Vehicle *vehicle;

@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *content;

//subjectId
@property (nonatomic, copy)NSString *subjectId;

//心声评论
//@property (nonatomic, copy)NSString *voicelen;
//@property (nonatomic, copy)NSString *duration;
@property (nonatomic, copy)NSString *messageType;
/** 时间差 */
@property (nonatomic, copy) NSString *timeGap;

//是否点赞
@property (nonatomic, assign) BOOL ispraise;

/** 语音文件 */
@property (nonatomic, strong) NSURL *voicelen;
/** 语音长度 */
@property (nonatomic, copy) NSString *duration;

@end


@interface DynamicListSuperModel : NSObject

@property (nonatomic, strong)NSArray<DynamicListModel*> *result;

@property (nonatomic, copy)NSString *state;

@end


/**
 *  计算动态frame
 *  为了height高度缓存
 */
@interface DynamicListModelFrame : ModelObject
/**
 *  模型
 */
@property (nonatomic, strong) DynamicListModel *model;
/**
 *  高度
 */
@property (nonatomic, assign) CGFloat cellHeight;
/**
 *  图片view高度
 */
@property (nonatomic, assign) CGFloat imageContenHieght;
/**
 *  每一张图片大小
 */
@property (nonatomic, assign) CGSize imageItemSize;
/** 文本高度 */
@property (nonatomic, assign) CGFloat contentHeight;

+ (NSArray *)arrayObjectWithFrameObject:(NSArray *)datas;
@end



