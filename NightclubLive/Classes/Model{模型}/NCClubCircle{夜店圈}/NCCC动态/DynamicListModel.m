//
//  DynamicListModel.m
//  NightclubLive
//
//  Created by WanBo on 17/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "DynamicListModel.h"

#import "NSURL+Utilities.h"


@implementation Vehicle

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

- (void)setSign:(id)sign{
    
    NSArray *urls = [sign componentsSeparatedByString:@","];
    
    _signArr = [NSURL urlStringsToURLS:urls];
}

@end
@implementation DynamicListUser

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",@"typeID":@"typeid"
             };
}

@end

@implementation DynamicListModel

+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"ID" : @"id",@"vehicle":@"vehicle", @"district" : @"distance",@"imagesStr":@"images"};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    
    return @{@"User":[User class],@"vehicle":[Vehicle class]};
}

- (void)setImagesStr:(NSString *)imagesStr{
    
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[imagesStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    
    _images = array;
}


- (void)setCreatetime:(NSDate *)createtime{
    
    _createtime = createtime;
    
    _timeGap = createtime.difftime;
}

- (void)setDistrict:(NSString *)district{
    
    //转换成千米
    if (district.length > 4){
        CGFloat gap = [district integerValue] % 1000;
        _district = [NSString stringWithFormat:@"%0.2fkm",gap];
        return;
    }
    
    if (!district){
        _district = @"未知距离";
        return;
    }
    
    _district = [NSString stringWithFormat:@"%@m",district];
}

@end

@implementation DynamicListSuperModel

+ (NSDictionary *)objectClassInArray{
    return @{@"result" : [DynamicListModel class]};
}

@end


@implementation DynamicListModelFrame

- (void)setModel:(DynamicListModel *)model{
    
    _model = model;
    
    NSInteger imgsCount = model.images.count;
    
    //先计算文本
    
    CGFloat cellHeight = 0;
    
    CGFloat curWidth = SCREEN_WIDTH - 14 * 2;
    
    CGFloat contentHeight =  [model.content getHeightWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(curWidth, CGFLOAT_MAX)];
    
    if (contentHeight > 40)
        contentHeight = 40;
    
    _contentHeight = contentHeight;
    
    cellHeight += 48.5 + 12.5 + 9.5 + 20.5 + 14 + 14 + 20 + 14 + contentHeight;
    
    //存在图片加上高度
    if (imgsCount > 0){
    
     //   _imageItemSize = CGSizeMake(width - 3, width - 3);
//        CGFloat imgWidth = SCREEN_WIDTH * 0.8;
//        CGFloat imgHeight = imgWidth * (221.5 / 312.0);
//        _imageItemSize = CGSizeMake(imgWidth, imgHeight);
//
//        _imageContenHieght = imgHeight + 5;
//        
//        cellHeight += imgHeight;
        if (imgsCount >= 3){
            _imageContenHieght = 0.44 *SCREEN_WIDTH * 0.84;
        }
        else{
            if (imgsCount == 1){
                _imageContenHieght = 0.58 * SCREEN_WIDTH;
            }
            else{
                _imageContenHieght = 0.32 * SCREEN_WIDTH;
            }
        }
        cellHeight += _imageContenHieght;
    }
    
    _cellHeight = cellHeight;
    
    
    if (model.content.length == 0 && model.voicelen){
        _cellHeight += 40;
    }
    
    if (model.content.length > 0 && model.voicelen)
        _cellHeight += 15;
    
}

+ (NSArray *)arrayObjectWithFrameObject:(NSArray *)datas{
    
    NSMutableArray *array = [NSMutableArray array];

    for (NSInteger i = 0 ; i < datas.count ; i ++){
        
        DynamicListModelFrame *frame = [DynamicListModelFrame new];
        frame.model = datas[i];
        
        [array addObject:frame];
    }
    
    return [array copy];
}

@end
