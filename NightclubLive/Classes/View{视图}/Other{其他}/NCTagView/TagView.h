//
//  TagView.h
//  NightclubLive
//
//  Created by SuperDanny on 2016/12/7.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TagViewAttribute) {
    ///左对齐
    TagView_AttributeLeft,
    ///右对齐
    TagView_AttributeRight
};

@interface TagView : UIView

- (instancetype)initWithTagArr:(NSArray<UIImage *> *)tagArr
              tagViewAttribute:(TagViewAttribute)attribute;

- (void)setTagArr:(NSArray<UIImage *> *)tagArr
 tagViewAttribute:(TagViewAttribute)attribute;

- (CGFloat)widthWithTagArr:(NSArray<UIImage *> *)tagArr;

@end
