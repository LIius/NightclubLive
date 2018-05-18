//
//  EmptyMiniView.h
//  NightclubLive
//
//  Created by RDP on 2017/6/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectView.h"

@interface EmptyMiniView : ObjectView
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
+ (EmptyMiniView *)viewWithTip:(NSString *)tip;
@end
