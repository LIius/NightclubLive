//
//  UIAlertController+Factory.m
//  NightclubLive
//
//  Created by RDP on 2017/3/7.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "UIAlertController+Factory.h"

@implementation UIAlertController (Factory)

+ (instancetype)alertControllerWithTitle:(NSString *)title withMessage:(NSString *)message calk:(CalkBackBlock)calkBlock{
    
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (calkBlock)
            calkBlock(nil);
    }];
    
    [ac addAction:okAction];
    
    //设置颜色
    [okAction setValue:APPDefaultColor forKey:@"titleTextColor"];
    
    return ac;

}

+ (instancetype)alertCancelAndOKWithTitle:(NSString *)title message:(NSString *)message okCalk:(CalkBackBlock)okBlock{
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    //改变取消按键内容

    
    [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (okBlock)
            okBlock(nil);
    }]];
    
    return ac;

}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message action:(NSArray *)actionTitles calk:(CalkBackBlock)calkBlock{
    
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //更改字体颜色
    UIColor *color = RGBCOLOR(205, 79, 161) ;
    
    for (NSInteger i = 0 ; i < actionTitles.count - 1 ; i ++){
        
        NSString *content = actionTitles[i];
        
        UIAlertAction *a = [UIAlertAction actionWithTitle:content style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (calkBlock)
                calkBlock(@(i));
        }];
        [a setValue:color forKey:@"titleTextColor"];
        
        [ac addAction:a];
    }
    
    NSString *content = actionTitles[actionTitles.count - 1];
     UIAlertAction *a = [UIAlertAction actionWithTitle:content style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (calkBlock)
            calkBlock(@(actionTitles.count - 1));
    }];
    
    [a setValue:RGBCOLOR(51, 51, 51) forKey:@"titleTextColor"];
    
    [ac addAction:a];

    return ac;

}

+ (instancetype)alertControllerWithTitle:(NSString *)title okBlock:(CalkBackBlock)okBlock{
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:title];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(51, 51, 51) range:NSMakeRange(0, title.length)];
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, title.length)];
    

    [ac setValue:alertControllerStr forKey:@"attributedTitle"];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textAlignment = NSTextAlignmentCenter;
    }];
    
    UIAlertAction *cancelA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertAction *okA = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (okBlock){
            UITextField *field = [ac.textFields firstObject];
            okBlock(field.text);
        }
    }];
    
    [cancelA setValue:RGBCOLOR(51,51,51) forKey:@"titleTextColor"];
    [okA setValue:RGBCOLOR(205, 79, 161) forKey:@"titleTextColor"];
    [ac addAction:cancelA];
    [ac addAction:okA];
    
    return ac;
    
}


@end
