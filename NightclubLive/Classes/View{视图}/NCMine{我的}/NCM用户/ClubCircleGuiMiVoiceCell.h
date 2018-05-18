//
//  ClubCircleGuiMiVoiceCell.h
//  NightclubLive
//
//  Created by WanBo on 16/12/2.
//  Copyright © 2016年 WanBo. All rights reserved.
//
#import "HeartsoundListModel.h"
#import "ObjectTableViewCell.h"

typedef NS_ENUM(NSUInteger, LGVoicePlayState){
    LGVoicePlayStateNormal,/**< 未播放状态 */
    LGVoicePlayStateDownloading,/**< 正在下载中 */
    LGVoicePlayStatePlaying,/**< 正在播放 */
    LGVoicePlayStateCancel,/**< 播放被取消 */
};
@class ClubCircleGuiMiVoiceCell;

@protocol ClubCircleGuiMiVoiceCellDelegate <NSObject>

- (void)voiceMessageTaped:(ClubCircleGuiMiVoiceCell *)cell;

@end
@interface ClubCircleGuiMiVoiceCell : ObjectTableViewCell
//匿名view
@property (weak, nonatomic) IBOutlet UIView *anonymousView;
@property (weak, nonatomic) IBOutlet UIImageView *addressIV;


@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *addressLable;
@property (nonatomic, copy) VoidBlock_id likeCallback;
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
@property (weak, nonatomic) IBOutlet UIButton *replayBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voiceCons;
@property (nonatomic, weak) id<ClubCircleGuiMiVoiceCellDelegate>delegate;
@property (nonatomic, assign) NSInteger soundSeconds;
@property (nonatomic, assign) LGVoicePlayState voicePlayState;
@property (weak, nonatomic) IBOutlet UIView *voiceContentView;
@property (weak, nonatomic) IBOutlet UILabel *likeLable;
@property (weak, nonatomic) IBOutlet UILabel *voiceDurationLable;
@property (weak, nonatomic) IBOutlet UILabel *criticismCountLabel;
@property (nonatomic, copy) CalkBackBlock logoBlock;
@property (weak, nonatomic) IBOutlet UIImageView *playIV;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;


//@property (nonatomic, strong) HeartsoundListModel *model;

//- (void)bindModel:(HeartsoundListModel *)model;
+ (CGFloat)cellHeightWithObj:(id)obj;

@end
