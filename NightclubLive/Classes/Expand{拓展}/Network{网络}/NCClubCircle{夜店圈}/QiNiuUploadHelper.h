//
//  QiNiuUploadHelper.h
//  NightclubLive
//
//  Created by WanBo on 17/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QiNiuUploadHelper : NSObject
/**
 *  成功回调
 */
@property (copy, nonatomic) void (^singleSuccessBlock)(NSString *);

/**
 *  失败回调
 */
@property (copy, nonatomic) void (^singleFailureBlock)();

+ (instancetype)sharedInstance;

@end
