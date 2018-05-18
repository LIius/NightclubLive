//
//  PaiPaiModel.h
//  NightclubLive
//
//  Created by WanBo on 17/2/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ModelObject.h"
#import "User.h"

@interface PaiPaiModel : ModelObject

@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *modifyTime;
@property (nonatomic, copy)NSString *videoUrl;
@property (nonatomic, copy)NSString *coverUrl;
@property (nonatomic, strong)NSDate *createTime;
/** 时间相差 */
@property (nonatomic, copy) NSString *timeGap;

/** 城市 */
@property (nonatomic, copy) NSString *city;
@property (nonatomic, strong) DataUser *user;
/** 点赞数量 */
@property (nonatomic, assign) NSInteger praiseCount;
/** 自己是否点赞 */
@property (nonatomic, assign) NSInteger ispraise;
/** 回复数量 */
@property (nonatomic, assign) NSInteger dynamicCount;

@end

@interface PaiPaiSuperModel : NSObject

@property (nonatomic, strong)NSArray<PaiPaiModel*> *result;
@property (nonatomic, copy)NSString *state;

@end
