//
//  NC3rdNetwork.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/10/9.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NC3rdNetwork.h"
#import "GJNetworkingConfig.h"
#import "MJModelMaker.h"

@implementation NC3rdNetwork

+ (void)configNetwork
{
    NSString *serverURL = nil;
    
#ifdef DEBUG
    serverURL = URL_DEV;
#else
    serverURL = URL_ONLINE;
#endif
    
    [GJNetworkingConfig setDefaultBaseUrl:serverURL
                   acceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil]
                 allowInvalidCertificates:YES
                      validatesDomainName:NO
                        maxOperationCount:4
                          timeOutInterval:20
                               modelMaker:[MJModelMaker class]];
    
    [GJNetworkingConfig setCacheDirectory:@"apiCache"];
}

@end
