//
//  VoiceCommentModel.m
//  NightclubLive
//
//  Created by WanBo on 17/1/9.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "VoiceCommentModel.h"
#import "Comment.h"


@implementation VoiceCommentUser
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",@"typeID":@"typeid"
             };
}
@end

@implementation VoiceCommentListModel
+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID" : @"id",@"typeID":@"typeid"
             };
}

- (void)setContent:(NSString *)content{
    _content = content;
    
    
    CGFloat cellHeight = 0;
    CGFloat curWidth = kScreenWidth-68;
    cellHeight += 50+8+ [content getHeightWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:CGSizeMake(curWidth, CGFLOAT_MAX)];
    
    _cellHeight = cellHeight;

}
@end

@implementation VoiceCommentModel

+ (NSDictionary *)objectClassInArray{
    
    return @{@"result" : [VoiceCommentListModel class]};
}
@end
