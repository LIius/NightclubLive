//
//  PaiPaiViewModel.h
//  NightclubLive
//
//  Created by WanBo on 17/2/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MRCViewModel.h"
#import "UIViewController+Category.h"
@interface PaiPaiViewModel : MRCViewModel

@property (nonatomic, copy, readonly) NSArray *datas;
/** 类型 */
@property (nonatomic, assign) NSInteger tag;
/** 用户对象莫德兴 */
@property (nonatomic, copy) NSString *userid;


/** 视频连接 */
@property (nonatomic, strong) NSURL *videURL;
/** 视频格式类型 MP4 or MOV*/
@property (nonatomic, copy) NSString *videType;
@property (nonatomic, strong, readonly) RACCommand *getPaipaiListCommand;
/** 上传视频 */
@property (nonatomic, strong) RACCommand *uploadVideCommand;
/** 转换command */
@property (nonatomic, strong) RACCommand *convertCommad;
@property (nonatomic, assign) NSInteger pageNow;
@property (nonatomic, assign) RefreshType refreshType;

- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page;

@end
