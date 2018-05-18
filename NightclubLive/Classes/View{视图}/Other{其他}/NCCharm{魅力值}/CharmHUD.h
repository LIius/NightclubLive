//
//  CharmHUD.h
//  NightclubLive
//
//  Created by rdp on 2017/5/26.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectView.h"

@interface CharmHUD : ObjectView
@property (weak, nonatomic) IBOutlet UILabel *charmValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
/** 删除block */
@property (nonatomic, copy) CalkBackBlock removeBlock;

/**
 *  显示弹框
 *
 *  @param charmValue 魅力值
 */
+ (CharmHUD *)showCharHUDWithCharValue:(NSString *)charmValue;
@end
