//
//  ChangeRemarkView.m
//  NightclubLive
//
//  Created by RDP on 2017/3/27.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ChangeRemarkView.h"
#import "ScottAlertController.h"
@interface ChangeRemarkView ()<UITextFieldDelegate>

@end


@implementation ChangeRemarkView

+ (instancetype)initFromXIB{
    
    ChangeRemarkView *view = [[[NSBundle mainBundle] loadNibNamed:@"ChangeRemarkView" owner:nil options:nil] firstObject];
    view.size = CGSizeMake(270, 160);
    view.layer.cornerRadius  = 10;
    return view;
}

- (IBAction)cancelClick:(id)sender {
    
    [self close];
  //  [self dismiss];
}

- (IBAction)okClick:(id)sender {
    
    //[self endEditing:YES];
    //if (_remarkTF.text.length == 0){
   //     [SVProgressHUD showErrorWithStatus:@"输入备注"];
 //   }
    
    if (self.calkBackBlock)
        self.calkBackBlock(self.remarkTF.text);
    
    [self close];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

@end
