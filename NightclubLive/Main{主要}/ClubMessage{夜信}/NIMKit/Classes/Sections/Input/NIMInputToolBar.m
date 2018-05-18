//
//  NIMInputToolBar.m
//  NIMKit
//
//  Created by chris
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "NIMInputToolBar.h"
#import "NIMInputTextView.h"
#import "UIView+NIM.h"
#import "UIImage+NIM.h"
#import "NIMInputBarItemType.h"

@interface NIMInputToolBar()

@property (nonatomic,copy)  NSArray<NSNumber *> *types;

@property (nonatomic,strong) UIView *sep;

@property (nonatomic,copy)  NSDictionary *dict;

@end

@implementation NIMInputToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
                
        _voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBtn setImage:KGetImage(@"icon_speeker") forState:UIControlStateNormal];
        [_voiceBtn setImage:KGetImage(@"icon_speeker") forState:UIControlStateHighlighted];
        [_voiceBtn sizeToFit];
      //  _voiceBtn.backgroundColor = [UIColor blueColor];
       // _voiceBtn
        
        
        _emoticonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emoticonBtn setImage:KGetImage(@"icon_face") forState:UIControlStateNormal];
        [_emoticonBtn setImage:KGetImage(@"icon_face") forState:UIControlStateHighlighted];
        [_emoticonBtn sizeToFit];
    //    _emoticonBtn.backgroundColor = [UIColor blueColor];
        
        _moreMediaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreMediaBtn setImage:KGetImage(@"icon_bigplus") forState:UIControlStateNormal];
        [_moreMediaBtn setImage:KGetImage(@"icon_bigplus") forState:UIControlStateHighlighted];
        [_moreMediaBtn sizeToFit];
        
    //    _moreMediaBtn.backgroundColor = [UIColor blueColor];
        
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_recordButton.titleLabel setFont:[UIFont systemFontOfSize:14.f]];
        [_recordButton setBackgroundImage:[[UIImage nim_imageInKit:@"icon_input_text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,80,15,80) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [_recordButton sizeToFit];
        
        _inputTextBkgImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_inputTextBkgImage setImage:[[UIImage nim_imageInKit:@"icon_input_text_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(15,80,15,80) resizingMode:UIImageResizingModeStretch]];
        
        _inputTextView = [[NIMInputTextView alloc] initWithFrame:CGRectZero];
        
        _sep = [[UIView alloc] initWithFrame:CGRectZero];
        _sep.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_sep];
        
        self.types = @[
                         @(NIMInputBarItemTypeVoice),
                         @(NIMInputBarItemTypeTextAndRecord),
                         @(NIMInputBarItemTypeEmoticon),
                         @(NIMInputBarItemTypeMore),
                       ];
        
        _voiceBtn.size = _emoticonBtn.size;
        _moreMediaBtn.size = _emoticonBtn.size;
    }
    return self;
}



- (void)setInputBarItemTypes:(NSArray<NSNumber *> *)types{
    self.types = types;
    [self setNeedsLayout];
}


- (CGSize)sizeThatFits:(CGSize)size{
    CGFloat height = 46.f;
    return CGSizeMake(size.width,height);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if ([self.types containsObject:@(NIMInputBarItemTypeTextAndRecord)]) {
        //先把文本输入框的宽度计算出来
        [self resetInputTextView];
    }
    CGFloat left = 0;
    for (NSNumber *type in self.types) {
        UIView *view  = [self subViewForType:type.integerValue];
        [self addSubview:view];
        view.nim_left = left + self.spacing;
        view.nim_centerY = self.nim_height * .5f;
        left = view.nim_right;
    }
    
    [self adjustTextAndRecordView];
    
    //底部分割线
    CGFloat sepHeight = .5f;
    _sep.nim_size     = CGSizeMake(self.nim_width, sepHeight);
    _sep.nim_bottom   = self.nim_height - sepHeight;
}

- (void)resetInputTextView{
    self.inputTextBkgImage.nim_width = 0;
    CGFloat width = 0;
    for (NSNumber *type in self.types) {
        UIView *view = [self subViewForType:type.integerValue];
        width += view.nim_width;
    }
    width += (self.spacing * (self.types.count + 1));
    self.inputTextBkgImage.nim_width  = self.nim_width  - width;
    self.inputTextBkgImage.nim_height = self.nim_height - self.spacing * 2;
}

- (void)adjustTextAndRecordView{
    if (self.inputTextBkgImage.superview) {
        CGFloat textViewMargin        = 2.f;
        //输入框
        self.inputTextView.frame  = CGRectInset(self.inputTextBkgImage.frame, textViewMargin, textViewMargin);
        [self addSubview:self.inputTextView];
        //中间点击录音按钮
        self.recordButton.frame  = self.inputTextBkgImage.frame;
        [self addSubview:self.recordButton];
    }
}


#pragma mark - Get
- (UIView *)subViewForType:(NIMInputBarItemType)type{
    if (!_dict) {
        _dict = @{
                  @(NIMInputBarItemTypeVoice) : self.voiceBtn,
                  @(NIMInputBarItemTypeTextAndRecord)  : self.inputTextBkgImage,
                  @(NIMInputBarItemTypeEmoticon) : self.emoticonBtn,
                  @(NIMInputBarItemTypeMore)     : self.moreMediaBtn
                  };
    }
    return _dict[@(type)];
}

- (CGFloat)spacing{
    return 6.f;
}


@end
