//
//  NCEmpty.h
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCEmpty : NSObject

+ (CGRect)getEmtpyViewRectWithScrollView:(UIScrollView *)scrollView;

+ (void)showOrHideOn:(UIScrollView *)scrollView  customeView:(UIView *)customeView;

@end
