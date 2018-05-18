//
//  VoiceListModel.h
//  NightclubLive
//
//  Created by WanBo on 17/1/3.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceListModel : ModelObject

@property (nonatomic, copy)NSString *status;

@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *createtime;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *modifytime;
@property (nonatomic, copy) NSString *memberNum;
/** 自己是否已经点赞 */
@property (nonatomic, assign) NSInteger ispraise;
/** 点赞熟 */
@property (nonatomic, assign) NSInteger praise;
@end

@interface VoiceListModelSuperModel : NSObject

@property (nonatomic, strong)NSArray<VoiceListModel*> *result;

@property (nonatomic, copy)NSString *state;

@end
