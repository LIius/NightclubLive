//
//  CustomCardView.m
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/9.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//

#import "CustomCardView.h"
#import "User.h"

#import "UserTagView.h"

@interface CustomCardView ()

@end

@implementation CustomCardView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    [_imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_width).multipliedBy(0.9);
    }];
}

+ (instancetype)customCardView
{
    CustomCardView *view = [[[NSBundle mainBundle]loadNibNamed:@"CustomCardView" owner:self options:nil]lastObject];
    
    return view;
}

- (void)installData:(NSDictionary *)element
{
//    self.imageView.image  = [UIImage imageNamed:element[@"image"]];
//    self.titleLabel.text = [NSString stringWithFormat:@"开开大王%@",element[@"title"]];
}

- (void)setModel:(DataUser *)model
{
    _model = model;
    
    [_imageView sd_setImageWithURL:model.profilePhoto placeholderImage:[UIImage userPlaceholder] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
    {
        [self.imageView autoAdjustWidth];
    }];

    _titleLabel.text = model.userName;
    _cityLabel.text = model.city;
    _userTagView.contentAlignType  = 1;
    _userTagView.model = model;
}

@end
