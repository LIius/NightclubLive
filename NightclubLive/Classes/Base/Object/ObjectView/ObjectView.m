//
//  ObjectView.m
//  NightclubLive
//
//  Created by RDP on 2017/4/13.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectView.h"

@implementation ObjectView

+ (instancetype)initFromXIB{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    
}

- (void)setModel:(id)model{
    
    
    if (model == _model)
        return;
    
    _model = model;
}
@end
