//
//  TipsView.h
//  NightclubLive
//
//  Created by WanBo on 16/11/27.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "CustomeAlterView.h"

@interface TipsView : CustomeAlterView
+ (instancetype)tipsView;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end
