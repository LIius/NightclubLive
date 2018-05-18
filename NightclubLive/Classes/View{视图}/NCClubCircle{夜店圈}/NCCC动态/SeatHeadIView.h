//
//  SeatHeadIView.h
//  NightclubLive
//
//  Created by RDP on 2017/7/3.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *SeatHeadIViewReuseID = @"SeatHeadIView";

@interface SeatHeadIView : UICollectionReusableView
/** 标题 */
@property (nonatomic, strong) UILabel *titleLabel;
@end
