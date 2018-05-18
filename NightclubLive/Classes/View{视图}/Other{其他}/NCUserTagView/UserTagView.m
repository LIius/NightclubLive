//
//  UserTagView.m
//  NightclubLive
//
//  Created by RDP on 2017/5/3.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "UserTagView.h"
#import "User.h"
#import "ModelObject.h"
#import "NetRedCircleListModel.h"
#import "PaiPaiModel.h"
#import "DynamicListModel.h"

@interface UserTagView()

@property (nonatomic, strong) NSMutableArray *tagImgs;
@property (nonatomic, assign) NSInteger carIndex;
@property (nonatomic, copy) NSURL *carLogoURL;
@property (nonatomic, strong) NSArray *carIndexs;/** 用户标志 */
@property (nonatomic, assign) BOOL isBar;/** 是否是酒吧绑定 */

@end

@implementation UserTagView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    _carIndex = -1;
}

- (void)setModel:(id)model
{
    [super setModel:model];

    _isBar = NO;
    [self.tagImgs removeAllObjects];
    
    //1.用户对象
    if ([model isKindOfClass:[User class]])
    {
        [self userModelImage];
    }
    else if ([model isKindOfClass:[FindUserModel class]])
    {
        // 找人
        [self findUserModel];
    }
    else if ([model isKindOfClass:[DynamicListModel class]])
    {
        [self dynamicModel];
    }
    else if ([model isKindOfClass:[PaiPaiModel class]])
    {
        [self paipaiModel];
    }
    else if ([model isKindOfClass:[DataUser class]])
    {
        [self dataUserModel];
    }
    
    // 添加图片到界面
    [self addUserTagToView];
    
    @try {
        // 异步加载车辆图片
        if ([model isKindOfClass:[User class]])
        {
            User *m =  model;
            for (NSInteger i = 0 ; i < m.carLogos.count ; i ++)
            {
                NSURL *url = m.carLogos[i];
                NSInteger subjectViewIndex = [_carIndexs[i] integerValue];
                UIImageView *iv = self.subviews[subjectViewIndex];
                iv.contentMode = UIViewContentModeScaleAspectFill;
                [iv sd_setImageWithURL:url placeholderImage:[UIImage picturePlaceholder]];
            }
            
        }else{
            if (_carIndex >= 0 && self.subviews.count > _carIndex){
                UIImageView *carIV = self.subviews[_carIndex];
                [carIV sd_setImageWithURL:_carLogoURL placeholderImage:[UIImage picturePlaceholder]];
            }
        }

    } @catch (NSException *exception) {
        
    } @finally {

    }


}

// 用户对象数据集合
- (void)userModelImage
{
    User *m = self.model;

    if (self.tag == 0)
    {
        // 判断企业认证
        if (m.company_certification)
        {
            [self.tagImgs addObject:KGetImage(@"icon_gongshi")];
        }
        
        // 性别
        [self.tagImgs addObject:m.sex == 1 ? KGetImage(@"icon_male-1") : KGetImage(@"icon_female-1")];
        
        // 等级
        NSString *imgName = [NSString stringFromeArray:@[@"icon_levelone",@"icon_levelyellowdiamond",@"icon_levelbluediamond",@"icon_levelpurplediamond"] index:m.charmRank];
        [self.tagImgs addObject:KGetImage(imgName)];
        
        // 土豪等级
        NSString *theRichImageName = [NSString stringFromeArray:@[@"icon_vipzero",@"icon_vipsample",@"icon_viptwo",@"icon_vipthree",@"icon_vipfour",@"icon_vipfive",@"icon_vipsix",@"icon_seven",@"icon_eight",@"icon_nine"] index:m.theRichNum];
        [self.tagImgs addObject:KGetImage(theRichImageName)];
        
        // 车辆
        if (m.vehicle_certification){
            /*[self.tagImgs addObject:[UIImage picturePlaceholder]];
            _carIndex = self.tagImgs.count - 1;
            _carLogoURL = [m.carLogos firstObject];*/
            
            NSMutableArray *array = [NSMutableArray array];
                    
            for (NSInteger i = 0 ; i < m.carLogos.count ; i ++){
                /** 占位 */
                [self.tagImgs addObject:[UIImage picturePlaceholder]];
                [array addObject:@(self.tagImgs.count - 1)];

            }
            
            _carIndexs = [array copy];
        }
        
        // 视频认证
        if (m.video_certification)
        {
            [self.tagImgs addObject:KGetImage(@"icon_videomini-1")];
        }

    }
    else{
        
        if (m.video_certification)
        {
            [self.tagImgs addObject:KGetImage(@"icon_videomini-1")];
        }
        
        // 车辆
        if (m.vehicle_certification)
        {
            NSMutableArray *array = [NSMutableArray array];
            
            for (NSInteger i = 0 ; i < 1 ; i ++){
                /** 占位 */
                [self.tagImgs addObject:[UIImage picturePlaceholder]];
                [array addObject:@(self.tagImgs.count - 1)];
                
            }
            
            _carIndexs = [array copy];
        }
    }
}

/**
 *  找人模型图片
 */
- (void)findUserModel
{
    FindUserModel *m = (FindUserModel *)self.model;
    //1.性别 icon_female
    [self.tagImgs addObject:m.sex == 1 ? KGetImage(@"icon_male") : KGetImage(@"icon_female")];
    
    //2.视频认证
    if (m.videoCertification)
        [self.tagImgs addObject:KGetImage(@"icon_videomini-1")];
    
    //3.第一个车辆车标
    if (m.carUrl.count > 0){
        [self.tagImgs addObject:[UIImage picturePlaceholder]];
        _carIndex = self.tagImgs.count - 1;
        _carLogoURL = [m.carUrl firstObject];
    }
}

- (void)dynamicModel
{
    DynamicListModel *m = self.model;
    
    // 判断是不是注册的商家,宽度是两倍
    if (m.user.isbound_bar){
        [self.tagImgs addObject:KGetImage(@"icon_pubpai")];
        _isBar = YES;
    }
    else{
    
        // 1.性别 icon_female
        [self.tagImgs addObject:m.user.sex == 1 ? KGetImage(@"icon_male-1") : KGetImage(@"icon_female-1")];
        // 2.视频认证
        if (m.user.videoCertification)
            [self.tagImgs addObject:KGetImage(@"icon_videomini-1")];
        
        // 3.第一个车辆车标
        if (m.vehicle){
            [self.tagImgs addObject:[UIImage picturePlaceholder]];
            _carIndex = self.tagImgs.count - 1;
            _carLogoURL = [m.vehicle.signArr firstObject];
        }
    }

}

- (void)paipaiModel{
    PaiPaiModel *m = self.model;
    
    if (m.user.isbound_bar){
        [self.tagImgs addObject:KGetImage(@"icon_pubpai")];
        _isBar = YES;

    }else{
        // 1.性别
        [self.tagImgs addObject:m.user.sex == 1 ? KGetImage(@"icon_male") : KGetImage(@"icon_female")];
    }

}

- (void)dataUserModel{
    
    DataUser *m = self.model;
    
    //1.性别
    [self.tagImgs addObject:m.sex == 1 ? KGetImage(@"icon_male") : KGetImage(@"icon_female")];
    
    //2.魅力等级
    //3.视频认证
    if (m.videoCertification)
        [self.tagImgs addObject:KGetImage(@"icon_videomini-1")];
    //4.车辆认证
}

- (void)addUserTagToView
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self layoutIfNeeded];

    // 图片之间的间隔
    CGFloat spaceWidth = 6.5;
    CGFloat height = self.height;
    CGFloat width = height;
    
    if (_isBar)
    {
        width *= 2;
    }
    
    // 开始位置
    CGFloat startX = 0 ;
    
    if (_contentAlignType == 0){
        startX = (self.width -  (self.tagImgs.count * width + (self.tagImgs.count - 1) * spaceWidth)) * 0.5;
    }
    else if (_contentAlignType == 1){
        startX = 0;
    }
    else if (_contentAlignType == 2){
        startX = self.width - (self.tagImgs.count * width);
    }
    
    [self.tagImgs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect frame = CGRectMake(idx * width + startX, 0, width, height);
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = obj;
        frame.origin.x += idx * spaceWidth;
        
        imageView.frame = frame;
      //  imageView.layer.cornerRadius = frame.size.width * 0.5;
    //    imageView.layer.masksToBounds = YES;

        [self addSubview:imageView];
    }];
}

#pragma mark - Getter

- (NSMutableArray *)tagImgs
{
    if (!_tagImgs){
        
        _tagImgs = [NSMutableArray array];
    }
    return _tagImgs;
}


@end
