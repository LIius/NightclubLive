//
//  NCPlayVideoViewController.h
//  NightclubLive
//
//  Created by CodeRiding on 2017/10/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface NCPlayVideoViewController : ObjectViewController

@property (nonatomic , strong) AVPlayerItem* playerItem;

@end
