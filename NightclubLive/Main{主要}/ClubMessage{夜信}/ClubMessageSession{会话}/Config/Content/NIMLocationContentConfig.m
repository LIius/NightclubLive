//
//  NIMLocationContentConfig.m
//  NIMKit
//
//  Created by amao on 9/15/15.
//  Copyright (c) 2015 NetEase. All rights reserved.
//

#import "NIMLocationContentConfig.h"
#import "NIMKitUIConfig.h"

@implementation NIMLocationContentConfig

- (CGSize)contentSize:(CGFloat)cellWidth message:(NIMMessage *)message
{
    
    CGFloat contentWidth = cellWidth * 0.618;
    CGFloat contentHeight = contentWidth * 0.517;
    
    return CGSizeMake(contentWidth, contentHeight);
}

- (NSString *)cellContent:(NIMMessage *)message
{
    return @"NIMSessionLocationContentView";
}

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message
{
    NIMKitBubbleConfig *config = [[NIMKitUIConfig sharedConfig] bubbleConfig:message];
    return config.contentInset;
}

@end
