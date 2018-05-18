//
//  LiveRequest.h
//  NightclubLive
//
//  Created by WanBo on 17/2/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectRequest.h"
#import "GJModelRequest.h"
/**
 *  获取自己的拍拍列表
 */
@interface PaiPaiGetListRequest : ObjectRequest
@end

/**
 *  获取别人的拍拍列表
 */
@interface PaiPaiUserListRequest : ObjectRequest

@end

@interface PaiPaiPostVideoRequest : GJModelRequest

@end
