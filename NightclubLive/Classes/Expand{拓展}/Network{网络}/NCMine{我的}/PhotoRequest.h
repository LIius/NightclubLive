//
//  PhotoRequest.h
//  NightclubLive
//
//  Created by RDP on 2017/4/17.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectRequest.h"


@interface UploadPotoRequest : ObjectRequest
@property (nonatomic, weak) NSArray <NSString *>*img;
@end
