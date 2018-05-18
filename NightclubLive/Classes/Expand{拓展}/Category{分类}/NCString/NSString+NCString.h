//
//  NSString+NCString.h
//  NightclubLive
//
//  Created by CodeRiding on 2017/10/23.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NCString)


- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
/**
 *  判断是否为手机号码
 *
 *  @return 结果
 */
- (BOOL)isPhoneNum;

/**
 *  由时间字符串装成时间
 *
 *  @param dateFormat 时间格式
 *
 *  @return 时间
 */
- (NSDate *)stringConvertDateWithFormat:(NSString *)dateFormat;

/**
 *  由月，日获取星座
 *
 *  @param m 月
 *  @param d 日
 *
 *  @return 星座名
 */
+(NSString *)getAstroWithMonth:(int)m day:(int)d;



/**
 *  返回缓存路径的完整路径名
 */
+ (NSString *)cacheDir;
/**
 *  返回文档路径的完整路径名
 */
+ (NSString *)documentDir;
/**
 *  返回临时路径的完整路径名
 */
+ (NSString *)tmpDir;


- (NSString *)rmbWithoutZero:(NSString *)string;

+ (NSString *)stringFromeArray:(NSArray *)array index:(NSInteger)index;

+ (UIImage *)imageFromeArray:(NSArray *)array index:(NSInteger)index;

+ (UIImageView *)imageViewFromeArray:(NSArray *)array index:(NSInteger)index;



#pragma mark - 时间
//时间字符串
+ (instancetype)nowTimeString;
//毫秒 转 获取时间  MM:SS
- (NSString *)getMMSS;


#pragma mark - 计算
///加上bString
- (NSString *)stringByAdding:(NSString *)bString;
///减去bString
- (NSString *)stringBySubtracting:(NSString *)bString;
///乘以bString
- (NSString *)stringByMultiplyingBy:(NSString *)bString;
///除以bString
- (NSString *)stringByDividingBy:(NSString *)bString;
///是否大于bString
- (BOOL)isBig:(NSString *)bString;
///比较两个数大小
- (NSComparisonResult)ob_compare:(NSString *)bString;
///去掉尾巴是0或者.的位数(10.000 -> 10 // 10.100 -> 10.1)
- (NSString *)ridTail;
///保留数据类型2位小数(如果是10.000 -> 10 // 10.100 -> 10.1)
+ (NSString *)formatterNumber:(NSNumber *)number;
///保留数据类型fractionDigits位小数
+ (NSString *)formatterNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits;


@end
