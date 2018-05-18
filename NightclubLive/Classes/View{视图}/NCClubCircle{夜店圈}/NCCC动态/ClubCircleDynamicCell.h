//
//  ClubCircleDynamicCell.h
//  NightclubLive
//
//  Created by WanBo on 16/12/2.
//  Copyright © 2016年 WanBo. All rights reserved.
//
#import "ObjectTableViewCell.h"
#import "DynamicListModel.h"

@class UserTagView;

@interface ClubCircleDynamicCell : ObjectTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (weak, nonatomic) IBOutlet UILabel *distanceLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *praiseLable;
@property (weak, nonatomic) IBOutlet UILabel *criticismLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *userlogoImageView;
@property (weak, nonatomic) IBOutlet UIView *praiseBackView;
@property (weak, nonatomic) IBOutlet UIButton *giftBtn;

@property (weak, nonatomic) IBOutlet UIImageView *sexIV;
@property (weak, nonatomic) IBOutlet UserTagView *userTagView;

@property (weak, nonatomic) IBOutlet UIButton *appointmentBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *dynamicCollectionView;
@property (nonatomic, copy) VoidBlock_id likeCallback;
@property (nonatomic, copy) CalkBackBlock logoClickBlock;
/** 点击了图片继续查看 */
@property (nonatomic, copy) CalkBackBlock imageClickBlock;
@property (nonatomic, copy) CalkBackBlock praiseBlock;
@property (nonatomic, copy) CalkBackBlock sendGiftBlock;
/** 约台回调 */
@property (nonatomic, copy) CalkBackBlock appointmentBlock;

@property (weak, nonatomic) IBOutlet UIImageView *playBtn;

/** 语音播放 */
@property (nonatomic, copy) CalkBackBlock voiceBlock;
@property (weak, nonatomic) IBOutlet UIView *voiceView;

@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UILabel *voicelenLabel;


- (void)bindModel:(DynamicListModelFrame *)modelFrame;
//+ (CGFloat)cellHeightWithObj:(id)obj;

- (void)setPlayStateImageWithTag:(NSInteger)tag;

/**
 *  切换布局模型
 *
 *  @param tag 0-普通布局 1-3D布局
 */
- (void)switchLayout:(NSInteger)tag imageCount:(NSInteger)count;
@end
