//
//  ClubCircleGuiMiVoiceCell.m
//  NightclubLive
//
//  Created by WanBo on 16/12/2.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "ClubCircleGuiMiVoiceCell.h"


#import "BlocksKit+UIKit.h"
@implementation ClubCircleGuiMiVoiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
    [_iconV bk_whenTapped:^{
        @strongify(self);
        if (self.logoBlock)
            self.logoBlock(self.indexPath);
    }];
}

- (void)setModel:(id)model{
    
    [super setModel:model];
    
    HeartsoundListModel *m = model;
    @weakify(self);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.voiceContentView addGestureRecognizer:tap];
    //self.model = m;
    _nameLable.text = m.user.userName;
    [_nameLable sizeToFit];
    
    NSString *address = [NSString stringWithFormat:@"%@",m.city];
    _addressLable.text = address.length>0?address:@"未知";
    _timeLable.text = m.createtime.difftime;
    _contentLable.text = m.content;
    
    [_praiseBtn setImage:[UIImage imageNamed:m.ispraise ? @"icon_support_press" : @"红人圈-点赞"] forState:UIControlStateNormal];
    
    [_praiseBtn setTitleColor:m.ispraise == 1 ? APPDefaultColor : [UIColor grayColor] forState:UIControlStateNormal];
    //   [_praiseBtn.titleLabel setText:[NSString stringWithFormat:@"点赞(%ld)",model.praise]];
    [_praiseBtn setTitle:[NSString stringWithFormat:@"点赞(%ld)",m.praise] forState:UIControlStateNormal];
    // [_praiseBtn.titleLabel sizeToFit];
    
    [_replayBtn setTitle:[NSString stringWithFormat:@"评论(%ld)",m.criticismCount] forState:UIControlStateNormal];
    if([m.messageType intValue]==1){
        _voiceCons.constant = 0;
    }else{
        _voiceCons.constant = 40;
        
    }
    
    
    /*[[_praiseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (_likeCallback) {
            _likeCallback(model);
        }
    }];*/
    
    [_praiseBtn bk_whenTapped:^{
        @strongify(self);
        if (_likeCallback)
            _likeCallback(self.indexPath);
    }];
    
    if ([m.anonymous integerValue]==1) {
        _anonymousView.hidden = NO;
        _addressLable.hidden = YES;
        _addressIV.hidden = YES;
        _nameLable.hidden = YES;
    }else{
        _anonymousView.hidden = YES;
        _addressLable.hidden = NO;
        _addressIV.hidden = NO;
        _nameLable.hidden = NO;
    }
    //秒    
    _voiceDurationLable.text = [m.duration getMMSS];
    
    [_iconV sd_setImageWithURL:URL(m.user.profilePhoto) placeholderImage:[UIImage userPlaceholder]];
}

+ (CGFloat)cellHeightWithObj:(id)obj{
    
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[HeartsoundListModel class]]) {
        HeartsoundListModel *model = (HeartsoundListModel *)obj;
        CGFloat curWidth = kScreenWidth-14-27;
        CGFloat voiceWidth;
        if ([model.messageType intValue]==2) {
            voiceWidth = 40;
        }else{
            voiceWidth = 0;

        }
        cellHeight +=   voiceWidth+80+31+15+17+ [model.content getHeightWithFont:[UIFont boldSystemFontOfSize:15] constrainedToSize:CGSizeMake(curWidth, CGFLOAT_MAX)];
        if ([model.anonymous integerValue]==1) {
            cellHeight -=15;
        }
        NSLog(@"%f",cellHeight);
    }
    return cellHeight;
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(voiceMessageTaped:)]) {
        [_delegate voiceMessageTaped:self];
    }
}

#pragma mark - Setters

- (void)setVoicePlayState:(LGVoicePlayState)voicePlayState {
    if (_voicePlayState != voicePlayState) {
        _voicePlayState = voicePlayState;
    }

    if (_voicePlayState == LGVoicePlayStatePlaying) {
        NSArray *animationImage = @[KGetImage(@"play1"),KGetImage(@"play2"),KGetImage(@"play3"),KGetImage(@"play4")];
        //启动动画
        [_playBtn.imageView setAnimationImages:animationImage];
        [_playBtn.imageView setAnimationRepeatCount:0];
        [_playBtn.imageView setAnimationDuration:1.5];
        [_playBtn.imageView startAnimating];
    }else if (_voicePlayState == LGVoicePlayStateDownloading) {
    }else if (_voicePlayState == LGVoicePlayStateNormal || _voicePlayState == LGVoicePlayStateCancel){
        [_playBtn.imageView stopAnimating];
        [_playBtn.imageView setImage:KGetImage(@"icon_voice")];
    }
}



@end
