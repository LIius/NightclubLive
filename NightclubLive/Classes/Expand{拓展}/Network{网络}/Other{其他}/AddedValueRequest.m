//
//  AddedValueRequest.m
//  NightclubLive
//
//  Created by RDP on 2017/4/13.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AddedValueRequest.h"
#import "RSATool.h"

@implementation GetPackageListRequest

- (GJRequestMethod)method{
    
    return GJRequestGET;
}

- (NSString *)path{
    
    return @"prepaid/list.do";
}

@end


@implementation VerifyReceiptRequest

- (NSString *)path{
    
    return @"ios_pay/verify.do";
}

- (NSDictionary *)parameters
{
//    NSString *encodeStr = [self.receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    NSString *str = [RSATool rsaEncryptString:encodeStr];
     NSString *str = [RSATool rsaEncryptString:[self getStoreWithReceipt]];
//    NSLog(@"encodeStr={%@}",encodeStr);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (str) {
        [params setValue:str forKey:@"receipt"];
    }
    NSString *strUserID = [RSATool rsaEncryptString:[UserInfo shareUser].userID];
    if (strUserID) {
        [params setValue:strUserID forKey:@"userId"];
    }
    
    NSString *strPhone = [RSATool rsaEncryptString:[UserInfo shareUser].lgPhone];
    if (strPhone) {
        [params setValue:strPhone forKey:@"phoneNum"];
    }
    
    return params.mutableCopy;
//    return @{@"receipt":str,
//             @"userId":[RSATool rsaEncryptString:[UserInfo shareUser].userID],
//             @"phoneNum":[RSATool rsaEncryptString:[UserInfo shareUser].lgPhone]};
}

- (NSString *)getStoreWithReceipt
{
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSString *receiptStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return receiptStr;
}

@end
