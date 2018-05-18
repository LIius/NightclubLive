//
//  AddFriendView.m
//  NightclubLive
//
//  Created by RDP on 2017/4/10.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AddFriendView.h"

@interface AddFriendView()<UITextFieldDelegate>

@end

@implementation AddFriendView


#pragma mark - Text Field

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (_finishBlock)
        _finishBlock(textField.text);
    return [textField resignFirstResponder];
}
@end
