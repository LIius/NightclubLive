//
//  VoiceView.h
//  NightclubLive
//
//  Created by WanBo on 17/1/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGAudioKit.h"

#define SOUND_RECORD_LIMIT 60
@interface VoiceView : UIView<LGSoundRecorderDelegate,LGAudioPlayerDelegate>

{
    UIButton *_maskView;
}
@property (nonatomic, weak) NSTimer *timerOf60Second;

@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (nonatomic, copy) VoidBlock_id sendCallback;
@property (nonatomic, assign) int second;

@property (weak, nonatomic) IBOutlet UIButton *keyBoardBtn;
@property (weak, nonatomic) IBOutlet UILabel *startLable;
@property (weak, nonatomic) IBOutlet UIView *TopslipCancelView;
@property (weak, nonatomic) IBOutlet UILabel *secondLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *anonymousBtn;
@property (strong, nonatomic) UIProgressView *progressView1;
@property (strong, nonatomic) UIProgressView *progressView2;



+ (instancetype)voiceView;
- (void)dismissMaskView;
- (void)setUP;

@end

