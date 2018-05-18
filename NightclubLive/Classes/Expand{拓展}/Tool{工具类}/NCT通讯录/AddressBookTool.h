//
//  AddressBookTool.h
//  NightclubLive
//
//  通讯录工具 负责读取通讯录的工具
//  Created by RDP on 2017/4/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressBookModel.h"

@interface AddressBookTool : NSObject

/**
 *  获取通讯列表
 *
 *  @return 封装好的通讯信息
 */
- (NSArray *)getAddressBooks;
/**
 *  发短信
 *
 *  @param phone   电话
 *  @param content 短信内容
 *  @param calkBlock 发送之后的回调
 */
- (void)sendMessage:(NSArray <NSString *> *)phones content:(NSString *)content calkBlock:(CalkBackBlock)calkBlock;

@end
