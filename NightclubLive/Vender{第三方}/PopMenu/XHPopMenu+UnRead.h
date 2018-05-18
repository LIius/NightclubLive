//
//  XHPopMenu+UnRead.h
//  NightclubLive
//
//  Created by RDP on 2017/4/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "XHPopMenu.h"

@interface XHPopMenu (UnRead)
/** 未读红点 序号  */
@property (nonatomic, assign) NSInteger unReadRow;
/** 是否未读 */
@property (nonatomic, assign) BOOL isUnRead;
@end
