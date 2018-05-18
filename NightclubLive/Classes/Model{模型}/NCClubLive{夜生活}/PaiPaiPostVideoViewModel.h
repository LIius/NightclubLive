//
//  PaiPaiPostVideoViewModel.h
//  NightclubLive
//
//  Created by WanBo on 17/2/7.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MRCViewModel.h"

@interface PaiPaiPostVideoViewModel : MRCViewModel
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic,strong) NSURL *videoUrl;
@property (nonatomic,copy)NSString *content;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, strong, readonly) RACCommand *commintReuqesCommand;

@end
