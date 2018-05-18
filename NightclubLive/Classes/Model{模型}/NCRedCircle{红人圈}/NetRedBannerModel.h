//
//  NetRedBannerModel.h
//  NightclubLive
//
//  Created by WanBo on 17/1/14.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelObject.h"

@interface NetRedBannerModel : ModelObject

@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *bannerSort;
@property (nonatomic, copy)NSString *modifyTime;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *bannerStatus;
@property (nonatomic, copy)NSString *bannerTarget;
@property (nonatomic, copy)NSString *bannerTitle;
@property (nonatomic, copy)NSString *bannerType;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *bannerImage;
/* 详情页面**/
@property (nonatomic, strong) NSURL *show_url;
/** 活动详情页面 */
@property (nonatomic, strong) NSURL *jump_url;

@end

@interface NetRedBannerSuperModel : NSObject

@property (nonatomic, strong)NSArray<NetRedBannerModel*> *result;

@property (nonatomic, copy)NSString *state;

@end

@interface ActivityListModel : NSObject

@property (nonatomic, copy)NSString *femaleCount;
@property (nonatomic, copy)NSString *sellerId;
@property (nonatomic, copy)NSString *femalePrice;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *posterUrl;
@property (nonatomic, copy)NSString *type;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *detailsUrl;
@property (nonatomic, copy)NSString *endTime;
@property (nonatomic, copy)NSString *malePrice;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *modifyTime;
@property (nonatomic, copy)NSString *startTime;
@property (nonatomic, copy)NSString *place;
@property (nonatomic, copy)NSString *status;


@end


@interface ActivityListSuperModel : NSObject

@property (nonatomic, strong)NSArray<ActivityListModel*> *result;
@property (nonatomic, copy)NSString *state;

@end

@interface ListModel : NSObject

@property (nonatomic, copy)NSString *typeId;
@property (nonatomic, copy)NSString *bannerUrl;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *endTime;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *remark;
@property (nonatomic, copy)NSString *modifyTime;
@property (nonatomic, copy)NSString *showUrl;
@property (nonatomic, copy)NSString *startTime;
@property (nonatomic, copy)NSString *createTime;


@end


@interface ListSuperModel : NSObject

@property (nonatomic, strong)NSArray<ListModel*> *result;
@property (nonatomic, copy)NSString *state;

@end



