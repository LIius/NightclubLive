//
//  CheckTools.m
//
//  Created by SuperDanny on 14/12/8.
//  Copyright (c) 2014年 SuperDanny. All rights reserved.
//

#import "CheckTools.h"
#import <SystemConfiguration/SCNetworkReachability.h>
#import <netdb.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

#import <AddressBook/AddressBook.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation CheckTools

+ (BOOL)checkNetWork {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    return (isReachable && !needsConnection) ? YES : NO;
}

#pragma mark - 只能输入数字
+ (BOOL)isNumber:(NSString *)number {
    //[0-9]{1,10000}
    NSString *keyRegex = @"[1-9]\\d*";
    NSPredicate *keyTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", keyRegex];
    return [keyTest evaluateWithObject:number];
}

#pragma mark - 只能输入数字小数点
+ (BOOL)isCountNumber:(NSString *)str {
    NSString *countRegex = @"^\\d+\\.{0,1}\\d*$";
    NSPredicate *countTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", countRegex];
    return [countTest evaluateWithObject:str];
}

#pragma mark - 身份证
+ (BOOL)isValidateIdentityCard:(NSString *)identityCard {
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    //\d{17}[\d|x]|\d{15}
    NSString *regex2 = @"^(\\d{6})(\\d{4})(\\d{2})(\\d{2})(\\d{3})([0-9]|X)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark - 密码
+ (BOOL)isValidateKeyNum:(NSString *)key {
    NSString *keyRegex = @"[A-Z0-9a-z]{6,20}";
    NSPredicate *keyTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", keyRegex];
    if (![keyTest evaluateWithObject:key]) {
        ShowError(@"密碼格式不正確");
        //        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"密碼格式不正確", nil) maskType:SVProgressHUDMaskTypeBlack];
    }
    return [keyTest evaluateWithObject:key];
}


+ (BOOL)isCheckPassword:(NSString *)pwd {
    if (pwd.length < 6) {
     //   [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"密碼不少於6位", nil)];
        //        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"密碼不少於6位", nil) maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    else if (pwd.length > 16) {
     //   [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"密碼超過20位", nil)];
        //        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"密碼超過20位", nil) maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    return YES;
}

#pragma mark - 邮箱
+ (BOOL)isValidateEmail:(NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

#pragma mark - 网址
+ (BOOL)isValidateURL:(NSString *)url {
    NSString *urlRegex = @"^((https|http|ftp|rtsp|mms)?:\\/\\/)[^\\s]+";
    NSPredicate *urlPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    
    NSString *urlRegex1 = @"([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?";
    NSPredicate *urlPre1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex1];
    
    return ([urlPre evaluateWithObject:url] || [urlPre1 evaluateWithObject:url]);
}

#pragma mark - 手机号码
+ (BOOL)isValidateMobileNumber: (NSString *)mobileNum {
    NSString *number=@"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [numberPre evaluateWithObject:mobileNum];
}

+ (BOOL)isLoginAccount:(NSString *)account
{
    //    NSString *countRegex = @"[[A-Z0-9a-z._%]@[A-Za-z0-9]]{0,20}";
    NSString *countRegex = @"[[A-Z0-9a-z]@[A-Za-z0-9]]{0,20}";
    NSPredicate *countTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", countRegex];
    return [countTest evaluateWithObject:account];
}

#pragma mark - 真实姓名，汉字
+ (BOOL)isRealName:(NSString *)realname {
    NSString *countRegex = @"[\u4e00-\u9fa5.]{2,20}$";
    NSPredicate *countTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", countRegex];
    return [countTest evaluateWithObject:realname];
}

#pragma mark - 判断是否为整型
+ (BOOL)isPureInt:(NSString*)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - 判断是否为浮点型
+ (BOOL)isPureFloat:(NSString*)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

#pragma mark - 判断手机权限
+ (BOOL)isPermissionsWithType:(NSUInteger)type {
    BOOL isPermit = NO;
    switch (type) {
        case CameraPermissions:
            isPermit = [self cameraPermissions];
            break;
        case PhotoPermissions:
            isPermit = [self photoPermissions];
            break;
        case MicrophonePermissions:
            isPermit = [self microphonePermissions];
            break;
        case AddressBookPermissions:
            isPermit = [self addressBookPermissions];
            break;
        default:
            break;
    }
    return isPermit;
}

+ (BOOL)cameraPermissions {
    __block BOOL isPermit = YES;
    if (iOS7) {
        AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorizationStatus == AVAuthorizationStatusAuthorized) {
            isPermit = YES;
        }
        else if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
            isPermit = NO;
        }
        else {
            isPermit = YES;
        }
    }
    return isPermit;
}

+ (BOOL)photoPermissions {
    BOOL isPermit = YES;
    if (iOS7) {
        ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
        if (authorizationStatus == ALAuthorizationStatusAuthorized) {
            isPermit = YES;
        }
        else if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
            isPermit = NO;
        }
        else {
            isPermit = YES;
        }
    }
    return isPermit;
}

+ (BOOL)microphonePermissions {
    __block BOOL isPermit = YES;
    if (iOS7) {
        AVAudioSession *session = [[AVAudioSession alloc] init];
        if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
            [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    isPermit = YES;
                } else {
                    isPermit = NO;
                }
            }];
        }
    }
    return isPermit;
}

+ (BOOL)addressBookPermissions {
    __block BOOL isPermit = YES;
    //用户拒绝访问通讯录,给用户提示设置应用访问通讯录
    ABAuthorizationStatus authorizationStatus = ABAddressBookGetAuthorizationStatus();
    
    if (authorizationStatus == ALAuthorizationStatusAuthorized) {
        isPermit = YES;
    }
    else if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        isPermit = NO;
    }
    else {
        isPermit = YES;
    }
    return isPermit;
}

#pragma mark 避免使用数据的时候出现空或者其他的，导致闪退
+ (NSString *)filterNULLValue: (NSString *)string {
    NSString * newStr = [NSString stringWithFormat:@"%@",string];
    if ([newStr isKindOfClass:[NSNull class]] ||
        newStr == nil ||
        [newStr isEqualToString:@"(null)"]||
        [newStr isEqualToString:@""] ||
        [newStr isEqualToString:@"null"] ||
        [newStr isEqualToString:@"<null>"]) {
        newStr = @"";
    }
    return newStr;
}

@end
