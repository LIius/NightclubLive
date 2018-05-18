//
//  VoiceListModel.m
//  NightclubLive
//
//  Created by WanBo on 17/1/3.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "VoiceListModel.h"


//@property (nonatomic, copy)NSString *ID;
//@property (nonatomic, copy)NSString *title;
//@property (nonatomic, copy)NSString *createtime;
//@property (nonatomic, copy)NSString *url;
//@property (nonatomic, copy)NSString *modifytime;

@implementation VoiceListModel

//+ (NSDictionary *)mj_replacedKeyFromPropertyName
//{
//    return @{@"ID" : @"id",@"memberNum": @"menber_num"};
//}
+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{
             @"ID":@"id",
      //       @"title":@"",
             @"createTime":@"createTime",
       //      @"url":@"",
       //      @"modifytime"
             @"memberNum":@"member_num"
             };
}

@end

@implementation VoiceListModelSuperModel

+ (NSDictionary *)objectClassInArray{
    return @{@"result" : [VoiceListModel class]};
}
@end
