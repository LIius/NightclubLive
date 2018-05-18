//
//  AddressBookHeaderView.h
//  NightclubLive
//
//  Created by SuperDanny on 2017/1/17.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressBookHeaderView : UIView
/** 是否已经展示 */
@property (nonatomic, assign) BOOL isShow;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
/** 邀请回调 */
@property (nonatomic, copy) CalkBackBlock invitionBlock;


- (instancetype)initWithTitle:(NSString *)title
                       status:(BOOL)isOpen;
- (void)setSelectBlock:(void(^)(BOOL isOpen))block;

@end
