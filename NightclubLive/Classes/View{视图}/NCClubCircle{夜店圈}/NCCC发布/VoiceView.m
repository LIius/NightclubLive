//
//  VoiceView.m
//  NightclubLive
//
//  Created by WanBo on 17/1/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "VoiceView.h"
#import <UIKit/UIKitDefines.h>

@interface VoiceView(){
    //状态
    int statues;

}

@end

@implementation VoiceView

- (UIProgressView *)progressView1{
    if (!_progressView1) {
        _progressView1 = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];//这里是设定progressView的模式为默认模式
        _progressView1.frame = CGRectMake(0, 46, SCREEN_WIDTH, 1);
        _progressView1.progressTintColor=[UIColor colorWithHexString:@"a803ff"];//设定progressView的显示颜色
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        _progressView1.transform = transform;//设定宽高
        //    self.progressView.trackImage = image4;
        _progressView1.contentMode = UIViewContentModeScaleAspectFill;
        //设定两端弧度
        _progressView1.layer.cornerRadius = 1.0;
        _progressView1.layer.masksToBounds = YES;
        //设定progressView的现实进度（一般情况下可以从后台获取到这个数字）
        [self addSubview:_progressView1];
    }
    return _progressView1;
}

- (UIProgressView *)progressView2{
    if (!_progressView2) {
        _progressView2 = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];//这里是设定progressView的模式为默认模式
        _progressView2.frame = CGRectMake(0, 46, SCREEN_WIDTH, 1);
        _progressView2.progressTintColor=[UIColor colorWithHexString:@"fe0034"];//设定progressView的显示颜色
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        _progressView2.transform = transform;//设定宽高
        //    self.progressView.trackImage = image4;
        _progressView2.contentMode = UIViewContentModeScaleAspectFill;
        //设定两端弧度
        _progressView2.layer.cornerRadius = 1.0;
        _progressView2.layer.masksToBounds = YES;
        //设定progressView的现实进度（一般情况下可以从后台获取到这个数字）
        [self addSubview:_progressView2];
    }
    return _progressView2;
}

+ (instancetype)voiceView{
    VoiceView *view = [[[NSBundle mainBundle]loadNibNamed:@"VoiceView" owner:self options:nil]lastObject];
    
    return view;
    
}

- (void)reloadView{
    
    //初开始状态
    if (statues==1) {
        [_recordButton setImage:[UIImage imageNamed:@"1voice"] forState:UIControlStateNormal];
        _startLable.hidden = NO;
        _TopslipCancelView.hidden = YES;
        self.progressView1.hidden = YES;
        self.progressView2.hidden = YES;
        
        //点击状态
    }else if(statues==2){
        [_recordButton setImage:[UIImage imageNamed:@"2voice"] forState:UIControlStateNormal];
        _startLable.hidden = YES;
        _TopslipCancelView.hidden = NO;
        _secondLable.hidden = NO;
        _titleLable.text = @"上滑取消";
        _titleLable.textColor = [UIColor colorWithHexString:@"b3b3b3"];
        //上滑状态
        self.progressView1.hidden = NO;
        self.progressView2.hidden = YES;
        
    }else{
        [_recordButton setImage:[UIImage imageNamed:@"3voice"] forState:UIControlStateNormal];
        _startLable.hidden = YES;
        _TopslipCancelView.hidden = NO;
        _secondLable.hidden = YES;
        _titleLable.text = @"松开取消";
        _titleLable.textColor = [UIColor colorWithHexString:@"fe0034"];
        self.progressView1.hidden = YES;
        self.progressView2.hidden = NO;
        
    }
}

- (void)setUP{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIButton *maskView = [[UIButton alloc]init];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.4;
    maskView.frame = CGRectMake(0, 0, window.bounds.size.width, window.bounds.size.height);
    [maskView addTarget:self action:@selector(dismissMaskView) forControlEvents:UIControlEventTouchUpInside];
    _maskView = maskView;
    [window addSubview:maskView];
    [self setUpVoice];
    [LGAudioPlayer sharePlayer].delegate = self;
    
    [[_keyBoardBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self dismissMaskView];
    }];
    statues = 1;
    [self reloadView];
    
    //匿名功能
    [[_anonymousBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *x) {
        x.selected = !x.selected;
        if (x.selected) {
            _anonymousBtn.backgroundColor = [UIColor whiteColor];
            [_anonymousBtn setTitleColor:[UIColor colorWithHexString:@"c34c9c"] forState:UIControlStateNormal];
    
        }else{
            _anonymousBtn.backgroundColor = [UIColor colorWithHexString:@"515151"];
            [_anonymousBtn setTitleColor:[UIColor colorWithHexString:@"888888"] forState:UIControlStateNormal];
     
        }
    }];
    

}
#pragma mark -      语音相关
- (void)setUpVoice{
    [_recordButton addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
    [_recordButton addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
    [_recordButton addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
    [_recordButton addTarget:self action:@selector(updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
    [_recordButton addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];

}
#pragma mark - Private Methods

/**
 *  开始录音
 */
- (void)startRecordVoice{
    __block BOOL isAllow = 0;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                isAllow = 1;
            } else {
                isAllow = 0;
            }
        }];
    }
    if (isAllow) {
        //		//停止播放
        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
        //		//开始录音
        //*****
        [[LGSoundRecorder shareInstance] startSoundRecord:self recordPath:[self recordPath]];
        statues = 2;
        [self reloadView];

        //开启定时器
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        _timerOf60Second = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sixtyTimeStopAndSendVedio) userInfo:nil repeats:YES];
    } else {
        
    }
}

/**
 *  录音结束
 */
- (void)confirmRecordVoice {
    NSLog(@"%f--",[[LGSoundRecorder shareInstance] soundRecordTime]);
    if ([[LGSoundRecorder shareInstance] soundRecordTime] == 0) {
        [self cancelRecordVoice];
        return;//60s自动发送后，松开手走这里
    }
    if ([[LGSoundRecorder shareInstance] soundRecordTime] < 1.0f) {
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        [self showShotTimeSign];
        return;
    }
    
    [self sendSound];
    //*****
    statues = 1;
    [self reloadView];
//    [[LGSoundRecorder shareInstance] stopSoundRecord:self];
    
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
}

/**
 *  更新录音显示状态,手指向上滑动后 提示松开取消录音
 */
- (void)updateCancelRecordVoice {
    statues = 3;
    [self reloadView];
//    [[LGSoundRecorder shareInstance] readyCancelSound];
}

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecordVoice {
    statues = 2;
    [self reloadView];
//    [[LGSoundRecorder shareInstance] resetNormalRecord];
}

/**
 *  取消录音
 */
- (void)cancelRecordVoice {
    //*****
//    [_recordButton setImage:[UIImage imageNamed:@"1voice"] forState:UIControlStateNormal];
    statues = 1;
    [self reloadView];
    
    _second = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.progressView1.progress = 0;
        self.progressView2.progress = 0;
        });
    //    [[LGSoundRecorder shareInstance] soundRecordFailed:self];
}

/**
 *  录音时间短
 */
- (void)showShotTimeSign {
    //*****
//    [[LGSoundRecorder shareInstance] showShotTimeSign:self];
    statues = 1;
    [self reloadView];
    [self makeToast:@"录音时间过短" duration:2 position:CSToastPositionCenter];
}

- (void)sixtyTimeStopAndSendVedio {
    
    int countDown = SOUND_RECORD_LIMIT - [[LGSoundRecorder shareInstance] soundRecordTime];
    _second++;
    _secondLable.text = [NSString stringWithFormat:@"%d''",(int)_second];
    NSLog(@"countDown is %d soundRecordTime is %f",countDown,[[LGSoundRecorder shareInstance] soundRecordTime]);
    CGFloat progress = _second / (SOUND_RECORD_LIMIT * 1.0);
    dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView1.progress = progress;
            self.progressView2.progress = progress;
    });


    if (countDown <= 10) {
        [[LGSoundRecorder shareInstance] showCountdown:countDown];
    }
    if ([[LGSoundRecorder shareInstance] soundRecordTime] >= SOUND_RECORD_LIMIT && [[LGSoundRecorder shareInstance] soundRecordTime] <= SOUND_RECORD_LIMIT + 1) {
        
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        [self.recordButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  语音文件存储路径
 *
 *  @return 路径
 */
- (NSString *)recordPath {
    NSString *filePath = [DocumentPath stringByAppendingPathComponent:@"SoundFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    return filePath;
}

- (void)sendSound {
    
    if(_sendCallback){
        if (_anonymousBtn.selected) {
            _sendCallback(@(1));
        }else{
            _sendCallback(@(0));

        }
    }

}

#pragma mark - LGSoundRecorderDelegate

- (void)showSoundRecordFailed{
    //	[[SoundRecorder shareInstance] soundRecordFailed:self];
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
}

- (void)didStopSoundRecord {
    
}

- (void)dismissMaskView{
    [_maskView removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        //480 是屏幕尺寸
        self.frame=CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 300);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
