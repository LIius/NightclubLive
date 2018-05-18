//
//  NetRedCircleFiltrateView.h
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectView.h"

@interface NetRedCircleFiltrateView : ObjectView
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *jiubaBtn;
@property (weak, nonatomic) IBOutlet UIButton *qingbaBtn;
@property (weak, nonatomic) IBOutlet UIButton *ktvBtn;
- (IBAction)okBtn:(id)sender;
/** 颜色 */
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) UIColor *color;
/** 状态 0-隐藏 1-显示 */
@property (nonatomic, assign) NSInteger hiddeStatue;
/** 选中状态 */
@property (nonatomic, assign) NSInteger selectRow;
/** 搜索ok */
@property (nonatomic, copy) CalkBackBlock okBlock;


- (void)show;
- (void)close;
@end
