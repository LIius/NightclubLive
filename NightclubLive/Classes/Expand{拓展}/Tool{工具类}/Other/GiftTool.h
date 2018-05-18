//
//  GiftTool.h
//  NightclubLive
//
// 礼物工具类
// 包括礼物的获取，购买，礼物view的展示
//  Created by RDP on 2017/4/5.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GiftTool : NSObject


+ (instancetype)defaultGiftTool;
/** 接受礼物ID */
@property (nonatomic, copy) NSString *receiverID;
/** 送礼物类型 1动态，2心声，3活动，4拍拍     5.大转盘抽奖,6聊天送礼 7-偶遇送礼*/
@property (nonatomic, assign) NSInteger giftType;
/** 送礼物对象的ID */
@property (nonatomic, copy) NSString *projectID;
/** 送礼对象的手机号码 */
@property (nonatomic, copy) NSString *phoneNum;
/** 当前打开的视图 */
//@property (nonatomic, weak) UIViewController *pushVC;
/** 送礼的回调 */
@property (nonatomic, copy) CalkBackBlock giftBlock;
/** 关闭回掉 */
@property (nonatomic, copy) CalkBackBlock closeBlock;
/**
 *  获取礼物列表
 */
- (void)startGetGiftList;

/**
 *  购买礼物按照ID
 *
 *  @param giftID 礼物ID
 */
- (void)buyByGiftID:(NSString *)giftID;

#pragma mark - View 部分

/**
 *  显示礼物视图
 */
- (void)showGiftView;

@end
