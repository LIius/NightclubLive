//
//  SuccessInfoViewController.h
//  NightclubLive
//
//  Created by SuperDanny on 2016/12/14.
//  Copyright © 2016年 WanBo. All rights reserved.
//
//  成功提示

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, SuccessType) {
    ///充值成功
    SuccessType_Recharge,
    ///提现成功
    SuccessType_WithdrawCash,
    ///付款成功
    SuccessType_Pay,
};

@interface SuccessInfoViewController : BaseViewController

@property (nonatomic, assign) SuccessType viewType;

@end
