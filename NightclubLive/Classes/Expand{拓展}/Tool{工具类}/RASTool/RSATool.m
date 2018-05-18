//
//  RSATool.m
//  NightclubLive
//
//  Created by RDP on 2017/4/14.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "RSATool.h"
#import "RSAEncryptor.h"

static NSString *KeyPaw = @"wanbo2019";

@interface RSATool()
@property (nonatomic, strong) RSAEncryptor *rsaEncryptor;
@end

@implementation RSATool

+ (instancetype)share
{
    static dispatch_once_t token;
    
    static RSATool  *shareClass;
    dispatch_once(&token, ^{
        shareClass = [[RSATool alloc] init];
    });
    
    return shareClass;
}

- (RSAEncryptor *)rsaEncryptor
{
    if (!_rsaEncryptor)
    {
        RSAEncryptor* rsaEncryptor = [[RSAEncryptor alloc] init];
        NSString* publicKeyPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
        NSString* privateKeyPath = [[NSBundle mainBundle] pathForResource:@"private_key" ofType:@"p12"];
        [rsaEncryptor loadPublicKeyFromFile: publicKeyPath];
        [rsaEncryptor loadPrivateKeyFromFile: privateKeyPath password:KeyPaw];
        
        _rsaEncryptor = rsaEncryptor;
    }
    return _rsaEncryptor;
}

+ (NSString *)rsaEncryptString:(NSString *)string
{
    return [[RSATool share].rsaEncryptor  rsaEncryptString:string];
}

+ (NSString *)rsaDecryptString:(NSString *)string
{
    return [[RSATool share].rsaEncryptor rsaDecryptString:string];
}
@end
