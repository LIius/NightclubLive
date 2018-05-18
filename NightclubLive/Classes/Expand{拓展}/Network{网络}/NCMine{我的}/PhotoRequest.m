//
//  PhotoRequest.m
//  NightclubLive
//
//  Created by RDP on 2017/4/17.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "PhotoRequest.h"

@implementation UploadPotoRequest

- (NSString *)path{
    
    return @"photo/add.do";
}

- (NSDictionary *)parameters
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (self.img.count >0  )
    {

        NSData *imageData = [NSJSONSerialization dataWithJSONObject:self.img options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
        
        DLog(@"{imageData=%@----{jsonStr=%@",imageData,jsonStr);
        [params setObject:jsonStr forKey:@"img_url"];
    }
    
    
    if ([UserInfo shareUser].userID.length > 0)
    {
        [params setObject:[UserInfo shareUser].userID forKey:@"user_id"];
    }

    return params.mutableCopy;
}

@end
