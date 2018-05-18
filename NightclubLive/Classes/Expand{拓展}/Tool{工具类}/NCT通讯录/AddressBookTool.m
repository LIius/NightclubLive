//
//  AddressBookTool.m
//  NightclubLive
//
//  Created by RDP on 2017/4/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AddressBookTool.h"
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import "UIWindow+CurrentViewController.h"

@interface AddressBookTool()<MFMessageComposeViewControllerDelegate>
/** 是否允许读取通讯 */
@property (nonatomic, assign) BOOL isPermission;
@property (nonatomic, copy)  CalkBackBlock messageBlock;
/** 短信控制器 */
@property (nonatomic, strong) MFMessageComposeViewController *messageVC;

@end

@implementation AddressBookTool


#pragma mark - Publuc Method

- (NSArray *)getAddressBooks{
    
    if (self.isPermission){
        return [self copyAddressBoooks];
    }
    
    return nil;
}

#pragma mark - Private Method
- (NSArray *)copyAddressBoooks
{
    NSMutableArray *array = [NSMutableArray array];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    //拿到所有联系人
    CFArrayRef peopleArray = ABAddressBookCopyArrayOfAllPeople(addressBook);
    //数组数量
    CFIndex peopleCount = CFArrayGetCount(peopleArray);
    for (int i = 0; i < peopleCount; i++)
    {
        AddressBookModel *m = [AddressBookModel new];
        m.isChoose = @0;

        // 拿到一个人
        ABRecordRef person = CFArrayGetValueAtIndex(peopleArray, i);
        // 拿到姓名
        // 姓
        NSString *lastNameValue = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
        // 名
        NSString *firstNameValue = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);

        if (lastNameValue){
            m.name = [m.name stringByAppendingString:lastNameValue];
        }
        
        if (firstNameValue){
            m.name = [m.name stringByAppendingString:firstNameValue];
        }
        
        //拿到多值电话
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        //多值数量
        CFIndex phoneCount = ABMultiValueGetCount(phones);
        
        for (int j = 0 ; j < phoneCount ; j++)
        {
            // 拿到标签下对应的电话号码
            NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, j);
            
            m.phoneNum = phoneValue;
        }
        
        [array addObject:m];
        CFRelease(phones);
    }
    
    CFRelease(addressBook);
    CFRelease(peopleArray);


    return [array copy];
}


- (void)sendMessage:(NSArray<NSString *> *)phones content:(NSString *)content calkBlock:(CalkBackBlock)calkBlock
{
    _messageBlock = calkBlock;
    
//    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil]];
//    [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil].tintColor = [UIColor redColor];

    // 导航控制器不能push
    MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
    if ([MFMessageComposeViewController canSendText])
    {
        vc.body = content;
        vc.recipients = phones;
        vc.messageComposeDelegate = self;
        _messageVC = vc;

        UIViewController *pushVC = [ShareWindow zf_currentViewController];
        [pushVC presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - Getter

- (BOOL)isPermission
{
    BOOL permission = NO;
    
    __block BOOL block_permission = permission;
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
            
            block_permission = YES;
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        
        permission = YES;
    }
    else {
        
        permission = NO;
    }

    return permission;
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    UIViewController *pushVC = [ShareWindow zf_currentViewController];
    [pushVC dismissViewControllerAnimated:YES completion:nil];
    
    if (_messageBlock){
        
        _messageBlock(@(result == MessageComposeResultSent));
    }
}

@end
