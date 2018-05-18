//
//  ExChangeView.h
//  NightclubLive
//
//  Created by RDP on 2017/7/25.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectView.h"


typedef NS_ENUM(NSUInteger,ExChangeTipType){
    ExChangeTipTypeSucess,
    ExChangeTipTypeFail,
    ExChangeTipTypeNoNetWork,
};

@interface ExChangeView : ObjectView
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/** 类型 */
@property (nonatomic, assign) ExChangeTipType showType;
/** okBlock */
@property (nonatomic, copy) CalkBackBlock okBlock;

@end
