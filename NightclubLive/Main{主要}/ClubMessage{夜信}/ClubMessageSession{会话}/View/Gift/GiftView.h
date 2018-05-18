//
//  GiftView.h
//  NightclubLive
//
//  Created by RDP on 2017/3/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//
#import "ObjectView.h"

@interface GiftView : ObjectView
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
@property (weak, nonatomic) IBOutlet UIButton *countBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UICollectionView *giftCollectionView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


/** 选择数字的回调 */
@property (nonatomic, copy) CalkBackBlock selectNumBlock;
/** 发送的回调 */
@property (nonatomic, copy) CalkBackBlock sendBlock;
/** 关闭回掉 */
@property (nonatomic, copy) CalkBackBlock closeBlock;

- (void)show;
- (void)close;
@end
