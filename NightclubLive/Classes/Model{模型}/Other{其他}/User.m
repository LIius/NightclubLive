//
//  User.m
//  NightclubLive
//
//  Created by RDP on 2017/3/7.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "User.h"
#import "NSURL+Utilities.h"
#import "NSDate+Utilities.h"


@interface User()<NSCopying>

@end
@implementation User

-(id)copyWithZone:(NSZone *)zone{
    
    User *newClass = [[[self class] allocWithZone:zone] init];
    
    return newClass;
}

- (void)setPhoto_imges:(NSString *)photo_imges{
    
    _photos = [NSURL urlStringsToURLS:JSONToObject(photo_imges)];
}


- (void)setDynamic_imges:(NSString *)dynamic_imges{
    
    _dynamicImages = [NSURL urlStringsToURLS:JSONToObject(dynamic_imges)];
}

- (void)setCharm_value:(NSString *)charm_value{
    
    _charm_value = RSADecryptString(charm_value);
    
    double charm = [_charm_value doubleValue];
    
    NSInteger rank = 0;
    
    if (charm >= 0 && charm < 2 * 10000) rank = 0;
    else if (charm >= 2 * 10000 && charm < 4 * 10000) rank = 1;
    else if (charm  >=4 * 10000 && charm  < 8 * 10000) rank = 2;
    else if (charm  >= 8 * 10000) rank = 3;
    
    _charmRank = rank;
}

- (void)setBirth_day:(NSDate *)birth_day{
    
    _birth_day = birth_day;
    
    _age = [NSString stringWithFormat:@"%ld",([NSDate date].year - birth_day.year) + 1];
}

- (void)setCar_logo_url:(NSString *)car_logo_url{
    
    NSArray *imgs = [car_logo_url componentsSeparatedByString:@","];
    
    _carLogos = [NSURL urlStringsToURLS:imgs];
}


- (void)setPaipai_createTime:(NSDate *)paipai_createTime{
    
    _paiapiGap = paipai_createTime.difftime;
}

- (void)setDynamic_create_time:(NSDate *)dynamic_create_time{
    
    _dynamicTimeGap = dynamic_create_time.difftime;
}
@end


@implementation UserDetail

- (void)setDynamic_imges:(NSString *)dynamic_imges{
    
    _dynamic_imges = dynamic_imges;
    
    _dynamicImages  = [self imageJsonStrinConvertArr:dynamic_imges];
}

- (void)setPhoto_imges:(NSString *)photo_imges{
    
    _photo_imges = photo_imges;
    
    _photos =  [self imageJsonStrinConvertArr:photo_imges];
}

- (NSArray *)imageJsonStrinConvertArr:(NSString *)imageJson{
    
    NSData *jsonData = [imageJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *array = (NSArray *)[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    NSMutableArray *urls = [NSMutableArray array];
    
    for (NSString *imageUrl in array){
        
        [urls addObject:URL(imageUrl)];
    }
    
    return [array copy];

}
@end

@implementation DataUser

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"};
}

@end
