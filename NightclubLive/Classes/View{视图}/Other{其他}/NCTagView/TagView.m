//
//  TagView.m
//  NightclubLive
//
//  Created by SuperDanny on 2016/12/7.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "TagView.h"

#define kTagWidth   15
#define kEdge       5

@interface TagView ()

@property (nonatomic, strong) NSArray<UIImage *> *tagArray;
@property (nonatomic, assign) TagViewAttribute attribute;

@end

@implementation TagView

- (void)setTagArr:(NSArray<UIImage *> *)tagArr tagViewAttribute:(TagViewAttribute)attribute {
    self.tagArray = tagArr;
    self.attribute = attribute;
    [self setUp];
}

- (instancetype)initWithTagArr:(NSArray<UIImage *> *)tagArr tagViewAttribute:(TagViewAttribute)attribute {
    if (self = [super init]) {
        [self setTagArr:tagArr tagViewAttribute:attribute];
    }
    return self;
}

- (void)setUp {
    self.backgroundColor = [UIColor clearColor];
    for (NSUInteger i = 0; i < _tagArray.count; i++) {
        UIImage *image = _tagArray[i];
        UIImageView *tagV = [[UIImageView alloc] initWithImage:image];
        tagV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:tagV];
        
        CGFloat left = i*kTagWidth+(i+1)*kEdge;
        [tagV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(kTagWidth);
            make.width.offset(kTagWidth);
            if (_attribute == TagView_AttributeLeft) {
                make.left.offset(left);
            } else {
                make.right.offset(-left);
            }
            (void)make.top;
        }];
    }
}

- (CGFloat)widthWithTagArr:(NSArray<UIImage *> *)tagArr {
    if (tagArr.count>1) {
        return tagArr.count*(kTagWidth+kEdge)+kEdge;
    }
    return 0;
}

@end
