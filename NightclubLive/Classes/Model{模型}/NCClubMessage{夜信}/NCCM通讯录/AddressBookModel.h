//
//  AddressBookModel.h
//  NightclubLive
//
//  通讯录封装模式
//  Created by RDP on 2017/4/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ModelObject.h"

@interface AddressBookModel : ModelObject

/** 用户姓名 */
@property (nonatomic, copy) NSString *name;
/** 用户电话号码 */
@property (nonatomic, copy) NSString *phoneNum;

@property (nonatomic, strong) NSNumber  *isChoose;

@end
