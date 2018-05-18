//
//  HeaderItem.m
//  NightclubLive
//
//  Created by SuperDanny on 2016/12/7.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "HeaderItem.h"

#define kTagWidth   30

@interface HeaderItem ()

@property (nonatomic, strong) id model;

@end

@implementation HeaderItem

- (instancetype)initWithModel:(id)model {
    if (self = [super init]) {
        self.model = model;
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame model:(id)model {
    if (self = [super initWithFrame:frame]) {
        self.model = model;
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.5;
    self.layer.borderColor = UIColorFromRGB(0xe0a8ce).CGColor;
    self.layer.cornerRadius = kTagWidth/2.;
    
    [self setImage:[UIImage imageNamed:_model] forState:UIControlStateNormal];

}

@end
