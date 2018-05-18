//
//  ClubCircleModelList.h
//  NightclubLive
//
//  Created by RDP on 2017/7/13.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ModelObject.h"

/**
 *  商家座位封装对象
 */
@interface BarTableNoModel : ModelObject

@property (nonatomic, assign) NSInteger sortOrder;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NSInteger tableNoStart;

@property (nonatomic, assign) NSInteger merchantId;

@property (nonatomic, assign) NSInteger galleryful;

@property (nonatomic, copy) NSString *tableType;

@property (nonatomic, assign) NSInteger tableNoEnd;

@property (nonatomic, copy) NSString *createTime;
/** 台号 */
@property (nonatomic, strong) NSArray *seats;

@end

/**
 *  商家不可选座位
 */
@interface BarTableNoNoCanModel : ModelObject


@property (nonatomic, copy) NSString *tableName;

@property (nonatomic, assign) NSInteger bookType;

@property (nonatomic, assign) NSInteger tableState;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NSInteger merchantId;

@property (nonatomic, copy) NSString *bookTime;

@property (nonatomic, copy) NSString *createTime;

@end

@interface PackageDetailsListModel : ModelObject
/** id */
@property (nonatomic, copy) NSString *ID;
/** 名字 */
@property (nonatomic, copy) NSString *name;
/** 数量 */
@property (nonatomic, copy) NSString *number;




@end
