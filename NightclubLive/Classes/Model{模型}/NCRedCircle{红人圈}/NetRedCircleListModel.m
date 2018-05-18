//
//  NetRedCircleListModel.m
//  NightclubLive
//
//  红人圈模型
//  Created by RDP on 2017/5/5.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NetRedCircleListModel.h"
#import "NSURL+Utilities.h"


@implementation FindUserModel

+ (NSDictionary *)modelCustomPropertyMapper{
    
    return @{@"ID":@"id"};
}

- (void)setCar_logo_url:(NSString *)car_logo_url{
    
    NSArray *urls = [car_logo_url componentsSeparatedByString:@","];
    _carUrl = [NSURL urlStringsToURLS:urls];
}
@end

@implementation Professionname

@end

@implementation RankListModel

@end


@implementation NetRedCircleBarModel

- (void)setSeller_logo:(NSString *)seller_logo{

    NSString *url = [NSString stringWithFormat:@"%@/%@",URL_TTPBASE,seller_logo];
    
    _logoURL = URL(url);
}

- (void)setIs_hot:(NSString *)is_hot{
    
    _isHot = [is_hot isEqualToString:@"Yes"];
}

- (void)setBar_type:(NSString *)bar_type{
    
    if ([bar_type isEqualToString:@"清吧"])
        _barType = 0;//清吧
    else if ([bar_type isEqualToString:@"酒吧"])
        _barType = 1;//酒吧
    else
        _barType = 2;//KTV
}

- (void)setDistance:(NSString *)distance{
    
    //转换成千米
    if (distance.length > 4){
        CGFloat gap = [distance integerValue] % 1000;
        _distance = [NSString stringWithFormat:@"%0.0fkm",gap];
        return;
    }
    
    _distance = [NSString stringWithFormat:@"%@m",distance];
}

- (void)setSeller_name:(NSString *)seller_name{
    
    _seller_name = seller_name;
    //计算长度
    //先计算距离的宽度
    CGFloat distance = [_distance getWidthWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(SCREEN_WIDTH, 16)] + 45;
    
    CGFloat nameMaxWidth = SCREEN_WIDTH - 80 - distance - 25 - 10;

    _nameWidth =   [_seller_name getWidthWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(nameMaxWidth, 20)] + 20;
}
@end


@implementation BarActivityModel

- (void)setCover_image:(NSString *)cover_image{
    
    
    cover_image = [NSString stringWithFormat:@"%@/%@",URL_TTPBASE,cover_image];
    _coverImage = URL(cover_image);
}

- (void)setParty_details:(NSString *)party_details{
    
    NSString *str = [NSString stringWithFormat:@"%@/%@",URL_TTPBASE,party_details];
    
    _party_details_url = URL(str);
}


@end

@implementation BarPersonRankModel



@end

@implementation NetRedCircleBarDetailModel

- (void)setParty:(NSString *)party{
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",URL_TTPBASE,party];
    
    _parytyImage = URL(url);
}

- (void)setBanner:(NSString *)banner{
    
    NSMutableArray *banners  = [NSMutableArray array];
    
    NSArray *array = [banner componentsSeparatedByString:@","];
   
    for (NSString *imStr in array){
        NSString *imageUrl = [NSString stringWithFormat:@"%@/%@",URL_TTPBASE,imStr];
        [banners addObject:URL(imageUrl)];
    }
    
    _banners = [banners copy];
    
    
}


- (void)setParty_details:(NSString *)party_details{
    
    NSString *str = [NSString stringWithFormat:@"%@/%@",URL_TTPBASE,party_details];
    
    _party_details_url = URL(str);
}

- (void)setSeat_img:(NSString *)seat_img{
    
    NSString *str = [NSString stringWithFormat:@"%@%@",URL_TTPBASE,seat_img];
    
    _seatImageURL = URL(str);
}
@end
