//
//  AddFriendView.h
//  NightclubLive
//
//  Created by RDP on 2017/4/10.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectView.h"

@interface AddFriendView : ObjectView
@property (weak, nonatomic) IBOutlet UITextField *yzTF;
/** 输完验证信息 */
@property (nonatomic, copy) CalkBackBlock finishBlock;
@end
