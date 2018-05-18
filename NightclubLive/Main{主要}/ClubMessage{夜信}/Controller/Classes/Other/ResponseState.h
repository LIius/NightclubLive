//
//  ResponseState.h
//  NightclubLive
//
//  服务器返回状态封装类
//  Created by RDP on 2017/3/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ModelObject.h"

@interface ResponseState : ModelObject
/** 版本号 */
@property (nonatomic, copy) NSString *version;
/** api名字 */
@property (nonatomic, copy) NSString *api;
/** 返回代码 */
@property (nonatomic, assign) NSInteger responseCode;
/** code */
@property (nonatomic, assign) NSInteger code;
/** 正确与否 */
@property (nonatomic, assign) BOOL isSuccess;
/** 提示内容 */
@property (nonatomic, copy) NSString *msg;
/** 数据集合 */
@property (nonatomic, strong) NSArray *datas;
/** 状态 */
@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) id seller_details;

/** 数据源 */
@property (nonatomic, strong) id result;

@property (nonatomic, strong) id data;
/** 可选 */
@property (nonatomic, strong) id optional;
/** 义务帮token */
@property (nonatomic, copy) NSString *token;
/** 提示魅力值 */
@property (nonatomic, copy) NSString *alert_msg;

@end
