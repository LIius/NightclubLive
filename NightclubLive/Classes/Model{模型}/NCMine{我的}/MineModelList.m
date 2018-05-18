//
//  MineModelList.m
//  NightclubLive
//
//  Created by RDP on 2017/4/21.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MineModelList.h"
#import "NSDate+Utilities.h"

#import "NSDate+LSCore.h"


@implementation PhotoAlbumList

- (instancetype)init{
    
    if (self = [super init]){
        self.selectAll = NO;
    }
    return self;
}
+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"};
}

- (void)setImg_url:(NSString *)img_url{
    
    _img_url = img_url;
    
    id value = [NSJSONSerialization JSONObjectWithData:[img_url dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    self.images = value;
    
    [self setSelectWithBool:0];
}


- (void)setSelectWithBool:(NSInteger)select{
    
    [_selects removeAllObjects];
    //添加可选项
    NSMutableArray *arr = [NSMutableArray array];
    
    for (NSInteger i = 0 ; i < self.images.count ; i ++){
        
        [arr addObject:[NSNumber numberWithBool:select]];
    }
    
    _selects = arr;
    
}

@end


@implementation AccountModel


- (void)setCharm_value:(NSString *)charm_value{
    
    _charm_value = [RSATool rsaDecryptString:charm_value];
    
    double charm = [_charm_value doubleValue];
    if (charm >= 0 && charm < 2 * 10000) _rank = 0;
    else if (charm >= 2 * 10000 && charm < 4 * 10000) _rank = 1;
    else if (charm  >=4 * 10000 && charm  < 8 * 10000) _rank = 2;
    else if (charm  >= 8 * 10000) _rank = 3;
    
    _rankName = [NSString stringFromeArray:@[@"夜店小米",@"夜店少年",@"夜店青年",@"夜店大神"] index:_rank];
}

- (void)setNight_bit:(NSString *)night_bit{
    
    _night_bit = [RSATool rsaDecryptString:night_bit];
}

- (void)setCharm_code:(NSString *)charm_code{
    
    _charm_code = [RSATool rsaDecryptString:charm_code];
}

-(void)setNight_code:(NSString *)night_code{
    
    _night_code = [RSATool rsaDecryptString:night_code];
}

- (void)setSaya_currency:(NSString *)saya_currency{
    
    _saya_currency = RSADecryptString(saya_currency);
}

- (void)setSaya_code:(NSString *)saya_code{
    
    _saya_code = [RSATool rsaDecryptString:saya_code];
}

- (void)setOut_status:(NSString *)out_status{
    
    _out_status = [RSATool rsaDecryptString:out_status];
}

- (void)setUser_rmb:(NSString *)user_rmb{
    
    _user_rmb = [RSATool rsaDecryptString:user_rmb];
}

- (void)setRmb:(NSString *)rmb{
    
    _rmb = [RSATool rsaDecryptString:rmb];
}

- (void)updateNCValue:(NSString *)nvValue{
    
    _night_bit = nvValue;
}

@end



@implementation FenGZModel

@end



@implementation PrizeListModel
+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"};
}

- (void)setPrize_img:(NSString *)prize_img{
    
    _prizeImgs = [NSJSONSerialization JSONObjectWithData:[prize_img dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
}

- (void)setDetails_img:(NSString *)details_img{
    
    _detailsImgs = [NSJSONSerialization JSONObjectWithData:[details_img dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
}

@end

@implementation MyNextListModel



@end


@implementation MyGiftListModel


@end

@implementation BarModel

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id",@"address":@"_address",@"address2":@"_address"};
}

- (void)setImage:(id)image{

    NSString *url = [NSString stringWithFormat:@"%@/%@",URL_TTPBASE,image];
    
    _image = URL(url);
}

- (NSString *)address{
    if (_address)
        return _address;
    return _address2;
}

- (void)onlySetLogoWithURL:(NSURL *)url{
    
    _image = url;
}


- (NSArray *)dobusinessArray{
    
    if (!_dobusinessArray){
        NSArray *newTimeStrs = [self.businessHours componentsSeparatedByString:@"~"];
        
        NSMutableArray *times = [NSMutableArray array];
        
        //判断是不是同一天
        NSInteger startHour = [[[[newTimeStrs firstObject] componentsSeparatedByString:@":"] firstObject] integerValue];
        NSInteger endHour = [[[[newTimeStrs lastObject] componentsSeparatedByString:@":"] firstObject] integerValue];
        
        BOOL thesameDay = startHour < endHour;
        
        //组装时间
        NSDate *startDate = [[[newTimeStrs firstObject] stringConvertDateWithFormat:@"HH:mm"] aimDay:1];
        NSDate *endDate = [[[newTimeStrs lastObject] stringConvertDateWithFormat:@"HH:mm"] aimDay:1];
        
        if (!thesameDay){
            endDate = [endDate aimDay:1];
        }
        
        while ([endDate timeIntervalSinceDate:startDate] >= 0) {
            
            [times addObject:startDate.HHmmString];
            
            startDate = [startDate aimHour:0.5];
            
            DLog(@"%@",startDate);
            
            //判断是不是最后一个
            if ([endDate timeIntervalSinceDate:startDate] < 0){
                [times addObject:endDate.HHmmString];
                break;
            }
        }
        
        _dobusinessArray = [times copy];
    }
    return _dobusinessArray;
}
@end




@implementation BarBindModel

@end




@implementation BarPackageModel

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"};
}

- (void)setImage:(NSString *)image{
    
    NSString *fullImageString = [NSString stringWithFormat:@"%@/%@",URL_TTPBASE,image];
    _imageURL = URL(fullImageString);
}

@end



@implementation DownOrderModel

@end



@implementation OrderListModel

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"};
}

- (void)setImage:(NSURL *)image{
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",URL_TTPBASE,image.absoluteString];
    
    _image = URL(url);
}
@end


@implementation AccountLogModel
@end


@implementation RechargeLogModel

@end


@implementation TheRichModel


- (void)setDaifug_value:(NSString *)daifug_value{
    
    //计算等级
    NSInteger rank = 0;
    switch ([daifug_value integerValue]) {
        case 0:{
            rank = 0;
        }break;
        case 100:{
            rank = 1;
        }break;
        case 500:{
            rank = 2;
        }break;
        case 1000:{
            rank = 3;
        }break;
        case 3000:{
            rank = 4;
        }break;
        case 6000:{
            rank  = 5;
        }break;
        case 10000:{
            rank = 6;
        }break;
        case 15000:{
            rank = 7;
        }break;
        case 20000:{
            rank = 8;
        }break;
        case 30000:{
            rank = 9;
        }break;
        case 50000:{
            rank = 10;
        }break;
    }
    
    _rankNum = rank;


    
}

@end
