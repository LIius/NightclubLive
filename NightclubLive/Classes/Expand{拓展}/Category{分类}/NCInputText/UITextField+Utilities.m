//
//  UITextField+Utilities.m
//  NightclubLive
//
//  Created by RDP on 2017/5/27.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "UITextField+Utilities.h"

@implementation UITextField (Utilities)
@dynamic placeholderColor;


- (void)setPlaceholderColor:(UIColor *)placeholderColor{

    
    [self setValue:placeholderColor forKeyPath:@"_placeholderLabel.textColor"];
}
@end
