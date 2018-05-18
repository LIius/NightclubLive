//
//  Campaign.m
//  NightclubLive
//
//  Created by RDP on 2017/2/28.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "CampaignModel.h"

@implementation CampaignModel

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"};
}
@end


@implementation CampaignJoinListModel

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    
    return @{@"user":[User class]};
}

- (void)setList_img_url:(NSString *)list_img_url{
    
    _list_img_url = list_img_url;
        
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[list_img_url dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    
    NSMutableArray *contents = [NSMutableArray array];
    for (NSString *url in array){
        [contents addObject:URL(url)];
    }
    
    _contentImages = [contents copy];
}

@end


@implementation CampaignJoinGiftListModel

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"};
}

@end

