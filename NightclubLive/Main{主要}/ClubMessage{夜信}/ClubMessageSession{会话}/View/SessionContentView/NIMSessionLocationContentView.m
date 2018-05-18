//
//  NIMSessionLocationContentView.m
//  NIMKit
//
//  Created by chris on 15/2/28.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMSessionLocationContentView.h"
#import "NIMMessageModel.h"
#import "UIView+NIM.h"
#import "UIImage+NIM.h"
#import "NIMKitUIConfig.h"

@interface NIMSessionLocationContentView()

@property (nonatomic,strong) UIImageView * imageView;

@property (nonatomic,strong) UILabel * titleLabel;

@end

@implementation NIMSessionLocationContentView

- (instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        self.opaque = YES;
        UIImage *image = KGetImage(@"icon_maps");
        _imageView  = [[UIImageView alloc] initWithImage:image];
        
//        CALayer *maskLayer = [CALayer layer];
//        maskLayer.cornerRadius = 10;
//        maskLayer.backgroundColor = [UIColor blackColor].CGColor;
//        maskLayer.frame = _imageView.bounds;
//        _imageView.layer.mask = maskLayer;
        _imageView.layer.cornerRadius = 10;

        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        
     //   _titleLabel.backgroundColor = [UIColor grayColor]
        
      //  self.backgroundColor = [UIColor grayColor];
        
    }
    return self;
}

- (void)refresh:(NIMMessageModel *)data{
    [super refresh:data];
    NIMLocationObject * locationObject = (NIMLocationObject*)self.model.message.messageObject;
    self.titleLabel.text = locationObject.title;
    
    NIMKitBubbleConfig *config = [[NIMKitUIConfig sharedConfig] bubbleConfig:data.message];
    self.titleLabel.textColor  = RGBCOLOR(51, 51, 51);
    self.titleLabel.font       = config.contentTextFont;
}

- (void)onTouchUpInside:(id)sender
{
    NIMKitEvent *event = [[NIMKitEvent alloc] init];
    event.eventName = NIMKitEventLocation;
    event.messageModel = self.model;
    [self.delegate onCatchEvent:event];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    UIEdgeInsets contentInsets  = self.model.contentViewInsets;
    CGSize contentsize          = self.model.contentSize;
    CGRect imageViewFrame = CGRectMake(contentInsets.left, contentInsets.top, contentsize.width, contentsize.height);
    imageViewFrame.size.width = self.nim_width;
    self.imageView.frame  = imageViewFrame;
    
    //进行布局
    _titleLabel.nim_width  = imageViewFrame.size.width;
    _titleLabel.nim_height = 35.f;

    [_titleLabel sizeToFit];
    self.titleLabel.nim_centerY = 25;
    self.titleLabel.nim_centerX = self.nim_width * .5f;
    

    
   // self.backgroundColor = [UIColor blueColor];
}


@end
