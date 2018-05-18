//
//  ReleaseDynamicViewModel.h
//  NightclubLive
//
//  Created by WanBo on 17/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MRCViewModel.h"

@interface ReleaseDynamicViewModel : MRCViewModel
@property (nonatomic, strong) NSArray *imageArr;

//@property (nonatomic,copy)NSString *content;

//发布内容
/** 发布文本内容 */
@property (nonatomic, copy) NSString *content;
/** 发布时候的城市 */
@property (nonatomic, copy) NSString *city;
/** 发布时候的省份 */
@property (nonatomic, copy) NSString *province;
/** 发布时候的区县 */
@property (nonatomic, copy) NSString *districe;
/** 发布具体的时间 */
@property (nonatomic, copy) NSString *address;
/** 纬度 */
@property (nonatomic, strong) NSNumber *latitude;
/** 经度 */
@property (nonatomic, strong) NSNumber *longitude;
/** 是否打开定位信息 */
@property (nonatomic,assign)BOOL isAddressOn;
@property (nonatomic, strong, readonly) RACCommand *commintReuqesCommand;

@end

