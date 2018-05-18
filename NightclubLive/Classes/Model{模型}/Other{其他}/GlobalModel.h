//
//  GlobalModel.h
//  NightclubLive
//
//  通用模型封装类
//  Created by RDP on 2017/3/10.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ModelObject.h"

@interface JobModel : ModelObject
//ID
@property (nonatomic, copy) NSString *ID;
//名字
@property (nonatomic, copy) NSString *name;
@end

@interface CarModel : ModelObject
/** 车辆ID */
@property (nonatomic, copy) NSString *ID;
/** 车辆名字 */
@property (nonatomic, copy) NSString *car_name;
/** 车辆图片logo */
@property (nonatomic, copy) NSURL *logo_url;
/** 车辆制造商 */
@property (nonatomic, copy) NSString *make_in;

@end

@interface AddedValuePackageModel : ModelObject
/** 套餐ID */
@property (nonatomic, copy) NSString *ID;
/** 套餐名字 */
@property (nonatomic, copy) NSString *packageName;
/** 夜比特值 */
@property (nonatomic, copy) NSString *nightBitValue;
/** 人民币值 */
@property (nonatomic, copy) NSString *rmbValue;

@end



/**
 *  礼物对象
 */
@interface GiftModel : ModelObject

@property (nonatomic, copy) NSString *night_bit;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NSInteger gift_type;

@property (nonatomic, assign) NSInteger gift_state;

@property (nonatomic, copy) NSString *gift_name;

@property (nonatomic, strong) NSURL *gift_img_url;

@property (nonatomic, strong) NSURL *gift_icon_url;

@property (nonatomic, copy) NSString *gift_create_time;

@end
