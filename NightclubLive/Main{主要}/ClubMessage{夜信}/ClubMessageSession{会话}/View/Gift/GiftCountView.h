//
//  GiftCountView.h
//  NightclubLive
//
//  Created by RDP on 2017/7/21.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectView.h"

@interface GiftCountView : ObjectView
@property (weak, nonatomic) IBOutlet UITextField *countTF;
/** 确定 */
@property (nonatomic, copy) CalkBackBlock okBlock;
/** 数量 */
@property (nonatomic, assign) NSInteger count;

@end
