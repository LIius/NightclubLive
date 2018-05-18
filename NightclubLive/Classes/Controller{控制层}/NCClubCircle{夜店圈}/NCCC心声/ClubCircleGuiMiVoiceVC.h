//
//  ClubCircleGuiMiVoiceVC.h
//  NightclubLive
//
//  Created by WanBo on 16/12/2.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseViewController.h"
#import "ObjectTableViewController.h"

@interface ClubCircleGuiMiVoiceSuperVC :BaseViewController

@end
@interface ClubCircleGuiMiVoiceVC : ObjectTableViewController

/**
 *  进行刷新但是不需要刷新动画
 */
- (void)getListButNotRefresh;

@end
