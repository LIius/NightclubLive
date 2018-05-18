//
//  SuggestView.m
//  NightclubLive
//
//  Created by RDP on 2017/6/26.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "SuggestView.h"
#import "UITextView+WZB.h"
#import "UIView+ScottAlertView.h"

@implementation SuggestView


- (void)awakeFromNib{
    [super awakeFromNib];
    
    _textView.placeholder = @"请填写您的宝贵意见 (120字以内)";
}

- (IBAction)closeClick:(id)sender {
    [self dismiss];
}

- (IBAction)okClick:(id)sender {
    [self dismiss];
    
    if (_submitBlock)
        _submitBlock(_textView.text);
}
@end
