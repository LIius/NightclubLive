//
//  DynamicCommentListModel.m
//  NightclubLive
//
//  Created by WanBo on 17/1/9.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "DynamicCommentListModel.h"
#import "Comment.h"


@implementation CommentVehicle : NSObject

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"
             };
}

@end

@implementation ToUser

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",@"typeID":@"typeid"
             };
}

@end

@implementation DynamicCommentListUser

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID" : @"id",@"typeID":@"typeid"};
}

@end


@implementation DynamicCommentListModel

+ (NSDictionary *)modelCustomPropertyMapper{
   
    return @{@"ID" : @"id"};
}

- (void)setContent:(NSString *)content{
    _content = content;
    
    CGFloat cellHeight = 0;
    CGFloat curWidth = kScreenWidth-68;
    cellHeight += 50+8+ [content getHeightWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:CGSizeMake(curWidth, CGFLOAT_MAX)];
    
    _cellHeight = cellHeight;
}

@end


@implementation DynamicCommentListSuperModel

+ (NSDictionary *)objectClassInArray{
    return @{@"result" : [DynamicCommentListModel class]};
}

@end
