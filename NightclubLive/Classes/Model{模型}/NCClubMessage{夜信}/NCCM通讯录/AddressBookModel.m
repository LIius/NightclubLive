//
//  AddressBookModel.m
//  NightclubLive
//
//  Created by RDP on 2017/4/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AddressBookModel.h"

@implementation AddressBookModel


- (NSString *)name{
    
    if (!_name){
        
        _name = @"";
    
    }
    return _name;
}

@end
