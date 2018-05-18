//
//  HeaderTagView.m
//  NightclubLive
//
//  Created by SuperDanny on 2016/12/7.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "HeaderTagView.h"
#import "HeaderItem.h"

#define kTagWidth   30
#define kEdge       12

@interface HeaderTagView ()

@property (nonatomic, strong) NSArray *models;

@end

@implementation HeaderTagView

- (instancetype)initWithModelArray:(NSArray<id> *)models {
    if (self = [super init]) {
        [self setModelArr:models];
    }
    return self;
}

- (void)setModelArr:(NSArray<id> *)models {
    self.models = models;
    [self setUp];
}

- (void)setUp {
    self.backgroundColor = [UIColor clearColor];
    for (NSUInteger i = 0, j = _models.count-1; i < _models.count; i++, j--) {
//        CGFloat left = i*kTagWidth+(i+1)*kEdge;
        CGFloat left = i*kTagWidth+(i)*kEdge;
        
        id model = _models[j];
//        HeaderItem *item = [[HeaderItem alloc] initWithFrame:CGRectMake(self.width-left-kTagWidth/2., (self.height-kTagWidth)/2., kTagWidth, kTagWidth) model:model];
        HeaderItem *item = [[HeaderItem alloc] initWithModel:model];
        [self addSubview:item];
        
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(kTagWidth);
            make.height.offset(kTagWidth);
            (void)make.centerY;
            make.right.offset(-left);
           // make.left.equalTo(self.view).offset;
        }];
    }
}

@end
