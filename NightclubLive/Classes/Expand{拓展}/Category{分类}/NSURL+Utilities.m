//
//  NSURL+Utilities.m
//  NightclubLive
//
//  Created by RDP on 2017/5/3.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NSURL+Utilities.h"

@implementation NSURL (Utilities)

+ (NSArray *)urlStringsToURLS:(NSArray *)urlStrings{
    
    NSMutableArray *imgs = [NSMutableArray arrayWithCapacity:urlStrings.count];
    for (NSString *urlStr in urlStrings){
        NSString *urlStrTemp = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [[NSURL alloc] initWithString:urlStrTemp];
        [imgs addObject:url];
    }
    
    return [imgs copy];
}
@end
