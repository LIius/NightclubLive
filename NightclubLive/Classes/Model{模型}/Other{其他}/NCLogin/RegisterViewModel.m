//
//  RegisterViewModel.m
//  NightclubLive
//
//  Created by WanBo on 16/12/26.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "RegisterViewModel.h"



@interface  RegisterViewModel()

@property (nonatomic, strong, readwrite) RACSignal *nextEnableSignal;

@end

@implementation RegisterViewModel
- (void)initialize {
    
    [super initialize];
    
    self.nextEnableSignal = [[RACSignal combineLatest:@[ RACObserve(self, password), RACObserve(self, phone),RACObserve(self,invationCode)]reduce:^(NSString *password,NSString *phone,NSString *invationCode){
        if (![self isValidPhone:phone]) {
            //请输入正确的手机号码
            return @(1);
        }else if(![self isValidPassword:password]){
            //请输入正确的注册密码
            return @(2);
        }
        else if(![self isValidInvationCode:invationCode]){
            
            //请输入正确的验证码
            return @(3);
        }
        else  if([self isValidPhone:phone]&&[self isValidPassword:password]){
            return @(666);

        }else{
            return @(0);
        }
    }]distinctUntilChanged];
    
    
}

// 这两个判断都属于逻辑范畴，和UI无关
- (BOOL)isValidPhone:(NSString *)phone {
    return phone.length == 11&&[self isPureInt:phone];
}

- (BOOL)isValidPassword:(NSString *)password {
    
    if (password.length >= 6 && password.length <= 20)
        return YES;
    else
        return NO;
}

- (BOOL)isValidInvationCode:(NSString *)invationCode{
    
    if (invationCode.length <=0 )
        return YES;
    
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:InvationRegularString options: NSRegularExpressionCaseInsensitive error:nil];
    
    NSTextCheckingResult *resutl = [regular firstMatchInString:invationCode options:0 range:NSMakeRange(0, invationCode.length)];
    
     NSRange resultRang = resutl.range;
    return (resultRang.location != resultRang.length && resultRang.length == InvationLength) && invationCode.length == InvationLength;
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

@end
