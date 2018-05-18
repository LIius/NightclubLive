//
//  Comment.m
//  NightclubLive
//
//  Created by RDP on 2017/3/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "Comment.h"


@implementation CommentObject

+ (NSDictionary *)modelCustomPropertyMapper{

    return @{@"ID":@"id"};
}


+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    
    return @{@"user":[User class],@"toUser":[User class]};
}


- (void)setContent:(NSString *)content{
    
    _content = content;
    
    CGFloat cellHeight = 0;
    CGFloat curWidth = kScreenWidth-68;
    cellHeight += 50+8+ [content getHeightWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:CGSizeMake(curWidth, CGFLOAT_MAX)];
    
    _cellHeight = cellHeight;
}
@end

