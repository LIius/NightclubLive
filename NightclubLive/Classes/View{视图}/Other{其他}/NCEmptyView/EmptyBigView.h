//
//  EmptyBigView.h
//  NightclubLive
//
//  Created by RDP on 2017/6/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectView.h"

@interface EmptyBigView : ObjectView

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipIV;
+ (EmptyBigView *)viewWithTip:(NSString *)tip;
@end
