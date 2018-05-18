//
//  PaPaDetailVC.h
//  NightclubLive
//
//  Created by WanBo on 16/12/8.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "BaseViewController.h"
#import "PaiPaiModel.h"

@interface PaPaDetailVC : BaseViewController

@property (nonatomic, strong)PaiPaiModel *model;

/**
 *  回复某一个用户的回调
 */
@property (nonatomic, copy) CalkBackBlock commentUserBlock;
@end
