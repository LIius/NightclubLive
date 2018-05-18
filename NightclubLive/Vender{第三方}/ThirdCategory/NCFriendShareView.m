//
//  NCFriendShareView.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/1.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NCFriendShareView.h"
#import "ShareView.h"

@implementation NCFriendShareView

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.type = MMPopupTypeSheet;
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
            make.height.mas_equalTo(105);

        }];
        
        ShareView *view = [ShareView shareView];
        [self addSubview:view];
        self.shareView = view;
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];

    
    }
    
    return self;
}


@end
