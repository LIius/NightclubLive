//
//  PchDefine.h
//  NightclubLive
//
//  Created by CodeRiding on 2017/10/14.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#ifndef PchDefine_h
#define PchDefine_h

// 临时
#define FMLEditCommandCompletionNotification @"FMLEditCommandCompletionNotification"
#define FMLExportCommandCompletionNotification @"FMLExportCommandCompletionNotification"

#define APPDefaultColor  RGBCOLOR(192,48,146)
#define NavDefaultColor  RGBCOLOR(58,18,115)

#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

// app规则
#define InvationRegularString @"([A-Z][0-9]{3})|([0-9][A-Z][0-9]{2})|([0-9]{2}[A-Z][0-9]|[0-9]{3}[A-Z])"
#define InvationLength 4

//故事板初始化ViewController
#define ViewController(storyboardName, vcName) [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:vcName]

#define kTrueHeight(height,trueWidth)   trueWidth * height * 1.0 / 375.0

#define SharedAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define ShareWindow [UIApplication sharedApplication].windows.firstObject

//code==360 授权失败，重新登录  code==278  断网  code==279 其他网络错误
#define netWorkErrorDomain @"com.sam.netWorkErrorDomain"
/** 弱引用 */
#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;
#define WEAKSELF __weak typeof(self) weakSelf = self;
//shi fou sijiduan
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_H_POINT (float)SCREEN_HEIGHT/667.f

/** 设备是否为iPhone 4/4S 分辨率320x480，像素640x960，@2x */
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 5C/5/5S 分辨率320x568，像素640x1136，@2x */
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 6 分辨率375x667，像素750x1334，@2x */
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

/** 设备是否为iPhone 6 Plus 分辨率414x736，像素1242x2208，@3x */
#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhoneX ([[UIApplication sharedApplication] statusBarFrame].size.height>20)



//----------------------ABOUT SYSTYM & VERSION 系统与版本 ----------------------------
//Get the OS version.       判断操作系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

/** 获取系统版本 */
#define iOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])

/** 是否为iOS7 */
#define iOS7 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES : NO)

/** 是否为iOS8 */
#define iOS8 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) ? YES : NO)

/** 是否为iOS9 */
#define iOS9 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ? YES : NO)

/** 是否为iOS11 */
#define iOS11 (([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) ? YES : NO)




//----------------------ABOUT PRINTING LOG 打印日志 ----------------------------
//Using dlog to print while in debug model.        调试状态下打印日志
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif



//----------------------ABOUT COLOR 颜色相关 ----------------------------

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define THEMCOLOR             UIColorFromRGB(0xC03092)




//----------------------ABOUT IMAGE 图片 ----------------------------

//LOAD LOCAL IMAGE FILE     读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]


//DEFINE IMAGE      定义UIImage对象//    imgView.image = IMAGE(@"Default.png");

#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]
//#define NOCacheImage(name) [UIImage imageNoCrachWithName:name]
#define KGetImage(name) [UIImage imageNamed:name]

//DEFINE IMAGE      定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

#define KEYWINDOW [UIApplication sharedApplication].keyWindow




// 解决iOS11 automaticallyAdjustsScrollViewInsets失效
#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)




//-----------------Other
#define URL(String) [NSURL URLWithString:[String stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]

#define  PushViewController(vc)    [self.navigationController pushViewController:vc animated:YES];
#define  WeakSelfPushViewController(vc,weakself) [kWeakSelf(weakself).navigationController pushViewController:vc animated:YES];
#define  PresentViewController(vc) [self presentViewController:vc animated:YES completion:nil];
#define DimssVC [self dismissViewControllerAnimated:YES completion:nil];
#define CurrentUser [UserInfo shareUser]
//-----------------数据选择
#define SelectDataForKey(key) [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"]][key]

static NSInteger maxImagcount = 20;

#define TABLE_HEAD_FOOT_SPACE 0.01

//苹果商店ID
#define APPStoreID @"1221802515"

//支付宝APPID
#define AliPayAppID = @"2016120904050101"

//----------------- HUD

#define ShowError(error)  [ShareWindow makeToast:error duration:1.5 position:CSToastPositionCenter];

#define ShowSuccess(succes) [ShareWindow makeToast:succes duration:1.5 position:CSToastPositionCenter];

#define ShowMessage(message) [ShareWindow makeToast:message duration:1.5 position:CSToastPositionCenter];

#define ShowStatue(state)     [SVProgressHUD showWithStatus:state];

#define ShowLoading [WBLoadingHUD show];
#define CloseLoading [WBLoadingHUD close];

//------------------ 加密解密
#define RSAEncryptString(String) [RSATool rsaEncryptString:String]
#define RSADecryptString(String) [RSATool rsaDecryptString:String]

//------------------ JSON
#define JSONToObject(JSONString) [NSJSONSerialization JSONObjectWithData:[JSONString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil]

//------------------Notifcation
/** 中心通知类 */
#define KNotificationCenter [NSNotificationCenter defaultCenter]


#endif /* PchDefine_h */
