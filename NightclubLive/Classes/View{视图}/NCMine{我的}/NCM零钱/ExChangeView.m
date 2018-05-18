//
//  ExChangeView.m
//  NightclubLive
//
//  Created by RDP on 2017/7/25.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ExChangeView.h"
#import "UIView+ScottAlertView.h"
@implementation ExChangeView


- (void)setShowType:(ExChangeTipType)showType{

    _showType = showType;
    

    UIImage *logoImage;
    NSString *title;
    NSString *content;
    NSString *btnText;
    
    NSArray *strArray = @[@"icon_yeibiteduihuan",@"icon_duihuanshibai",@"icon_duihuanshibai"];
    NSString *str = [strArray stringAtIndex:showType];
    logoImage = KGetImage(str);
    
    NSArray *strArray2 = @[@"恭喜您~已经成功兑换",@"兑换失败",@"兑换失败"];
    NSString *str2 = [strArray2 stringAtIndex:showType];
    title = str2;
    
    NSArray *strArray3 = @[@"夜比特：",@"您兑换的夜比特可能超过了可兑换数量",@"请稍后再尝试"];
    NSString *str3 = [strArray3 stringAtIndex:showType];
    content = str3;
    
    NSArray *strArray4 = @[@"确定",@"好的，我知道了",@"好的，我知道了"];
    NSString *str4 = [strArray4 stringAtIndex:showType];
    btnText = str4;
    

    if (showType == ExChangeTipTypeSucess)
        content = [content stringByAppendingString:self.model];
    _logoIV.image = logoImage;
    _titleLabel.text = title;
    _contentLabel.text = content;
    [_okBtn setTitle:btnText forState:UIControlStateNormal];
}

- (IBAction)closeClick:(id)sender {
    
    [self dismiss];
    
    if (self.okBlock)
        self.okBlock(nil);
}


@end
