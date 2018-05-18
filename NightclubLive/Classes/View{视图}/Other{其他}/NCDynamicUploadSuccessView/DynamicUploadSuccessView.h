//
//  MyRoleView.h
//  NightclubLive
//
//  Created by WanBo on 16/11/27.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "CustomeAlterView.h"

@interface DynamicUploadSuccessView : CustomeAlterView

+ (instancetype)dynamicUploadSuccessView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
/** 按键会带 */
@property (nonatomic, copy) CalkBackBlock okBlock;

@end
