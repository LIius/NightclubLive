//
//  AuthModel.m
//  NightclubLive
//
//  Created by RDP on 2017/3/15.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AuthModel.h"

@implementation AuthJobModel

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"};
}

- (void)setIdimageUrl:(NSString *)idimageUrl{
    
    
    _idiImageDic = [NSJSONSerialization JSONObjectWithData:[idimageUrl dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
}

@end


@implementation AuthVideoModel

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"};
}

@end


@implementation CarAuthModel

@end
