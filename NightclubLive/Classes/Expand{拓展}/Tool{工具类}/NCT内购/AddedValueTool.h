//
//  AddedValueTool.h
//  NightclubLive
//
//  增值业务封装类
//
//  特别说明下 我们服务器获取套餐的ID 与 app 服务器ID 有差别
//  apple_product_id = package_selfID 
//  Created by RDP on 2017/4/13.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalModel.h"

@interface AddedValueTool : NSObject
/** 购买套餐列表 */
@property (nonatomic, strong) NSArray *packageList;

+ (instancetype)shareTool;


- (void)getIOSPackageListCompletion:(void (^)(NSArray *list))completion;

- (void)buyPackageWithID:(NSString *)packageID completion:(void (^)(id value))completion;
@end
