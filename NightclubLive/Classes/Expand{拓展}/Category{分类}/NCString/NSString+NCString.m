//
//  NSString+NCString.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/10/23.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NSString+NCString.h"
#import "NSDate+Utilities.h"

@implementation NSString (NCString)


- (CGSize)getSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    CGSize resultSize = CGSizeZero;
    if (self.length <= 0) {
        return resultSize;
    }
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.alignment = NSTextAlignmentLeft;
    
    resultSize = [self boundingRectWithSize:size
                                    options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)
                                 attributes:@{NSFontAttributeName: font,NSParagraphStyleAttributeName:style}
                                    context:nil].size;
    resultSize = CGSizeMake(MIN(size.width, ceilf(resultSize.width)), MIN(size.height, ceilf(resultSize.height)));
    return resultSize;
}
- (CGFloat)getHeightWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].height;
}
- (CGFloat)getWidthWithFont:(UIFont *)font constrainedToSize:(CGSize)size{
    return [self getSizeWithFont:font constrainedToSize:size].width;
}

- (BOOL)isPhoneNum{
    
    NSString *mobile = [self copy];
    
    mobile = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
    
    return YES;
    
}

- (NSDate *)stringConvertDateWithFormat:(NSString *)dateFormat{
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:dateFormat];
    
    NSDate *newDate = [format dateFromString:self];
    
    return [newDate iosConvertLocationTime];
}


+(NSString *)getAstroWithMonth:(int)m day:(int)d{
    
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    if (m<1||m>12||d<1||d>31){
        return @"错误日期格式!";
    }
    
    if(m==2 && d>29)
    {
        return @"错误日期格式!!";
    }else if(m==4 || m==6 || m==9 || m==11) {
        
        if (d>30) {
            return @"错误日期格式!!!";
        }
    }
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    
    
    return result;
}




+ (NSString *)cacheDir {
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [dir stringByAppendingPathComponent:[[[self alloc] init] lastPathComponent]];
}

+ (NSString *)documentDir {
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [dir stringByAppendingPathComponent:[[[self alloc] init] lastPathComponent]];
}

+ (NSString *)tmpDir {
    NSString *dir = NSTemporaryDirectory();
    return [dir stringByAppendingPathComponent:[[[self alloc] init] lastPathComponent]];
}


+ (NSString *)stringFromeArray:(NSArray *)array index:(NSInteger)index
{
    return [array stringAtIndex:index];
}

+ (UIImage *)imageFromeArray:(NSArray *)array index:(NSInteger)index
{
    return [array imageAtIndex:index];
}

+ (UIImageView *)imageViewFromeArray:(NSArray *)array index:(NSInteger)index
{
    return [array imageViewAtIndex:index];
}

- (NSString *)rmbWithoutZero:(NSString *)string
{
    if ([string hasSuffix:@".00"])
    {
        string = [string stringByReplacingOccurrencesOfString:@".00" withString:@""];
    }
    
    return string;
}



#pragma mark - 时间
+ (instancetype)nowTimeString
{
    NSString *str = nil;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddmmhhssSSS"];
    
    str = [formatter stringFromDate:date];
    
    NSInteger randomNum = arc4random() / 1000;
    
    str = [str stringByAppendingFormat:@"%ld",(long)randomNum];
    
    return str;
}
- (NSString *)getMMSS
{
    NSInteger seconds = ceil([self integerValue] / 1000);
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%0.2ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%0.2ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    return format_time;
}



#pragma mark - 计算
#if 0
- (NSString *)stringByAdding:(NSString *)bString {
    NSString *aString = self;
    if ([NSString filterNULLValue:aString].length == 0) {
        aString = @"0";
    }
    if ([NSString filterNULLValue:bString].length == 0) {
        bString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc]initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc]initWithString:bString];
    NSDecimalNumber *c = [a decimalNumberByAdding:b];
    NSString *cString = [NSString stringWithFormat:@"%@", c];
    NSString *rid = [cString ridTail];
    return rid;
}
- (NSString *)stringBySubtracting:(NSString *)bString {
    NSString *aString = self;
    if ([NSString filterNULLValue:aString].length == 0) {
        aString = @"0";
    }
    if ([NSString filterNULLValue:bString].length == 0) {
        bString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc] initWithString:bString];
    NSDecimalNumber *c = [a decimalNumberBySubtracting:b];
    NSString *cString = [NSString stringWithFormat:@"%@", c];
    NSString *rid = [cString ridTail];
    return rid;
}
- (NSString *)stringByMultiplyingBy:(NSString *)bString {
    NSString *aString = self;
    if ([NSString filterNULLValue:aString].length == 0) {
        aString = @"0";
    }
    if ([NSString filterNULLValue:bString].length == 0) {
        bString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc] initWithString:bString];
    NSDecimalNumber *c = [a decimalNumberByMultiplyingBy:b];
    NSString *cString = [NSString stringWithFormat:@"%@", c];
    NSString *rid = [cString ridTail];
    return rid;
}
- (NSString *)stringByDividingBy:(NSString *)bString {
    NSString *aString = self;
    if ([NSString filterNULLValue:aString].length == 0) {
        aString = @"0";
    }
    if ([NSString filterNULLValue:bString].length == 0) {
        bString = @"0";
    }
    if ([[bString ridTail] isEqualToString:@"0"]) {
        NSLog(@"除数为0");
        return @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc] initWithString:bString];
    NSDecimalNumber *c = [a decimalNumberByDividingBy:b];
    NSString *cString = [NSString stringWithFormat:@"%@", c];
    NSString *rid = [cString ridTail];
    return rid;
    return [NSString stringWithFormat:@"%@", c];
}
- (BOOL)isBig:(NSString *)bString {
    NSString *aString = self;
    if ([NSString filterNULLValue:aString].length == 0) {
        aString = @"0";
    }
    if ([NSString filterNULLValue:bString].length == 0) {
        bString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc] initWithString:bString];
    if ([a compare:b] == NSOrderedAscending) {//上升
        return NO;
    } else if ([a compare:b] == NSOrderedDescending) {//下降
        return YES;
    } else {//相等
        return NO;
    }
}
- (NSComparisonResult)ob_compare:(NSString *)bString {
    NSString *aString = self;
    if ([NSString filterNULLValue:aString].length == 0) {
        aString = @"0";
    }
    if ([NSString filterNULLValue:bString].length == 0) {
        bString = @"0";
    }
    NSDecimalNumber *a = [[NSDecimalNumber alloc] initWithString:aString];
    NSDecimalNumber *b = [[NSDecimalNumber alloc] initWithString:bString];
    return [a compare:b];
}
- (NSString *)ridTail {
    NSString *string = self;
    if (![string containsString:@"."]) {
        return string;
    }
    if ([string hasSuffix:@"0"]) {
        string = [string substringToIndex:string.length - 1];
        string = [string ridTail];
    } else if ([string hasSuffix:@"."]) {
        string = [string substringToIndex:string.length - 1];
        return string;
    } else {
        return string;
    }
    return string;
}
+ (NSString *)formatterNumber:(NSNumber *)number {
    return [self formatterNumber:number fractionDigits:2];
}
+ (NSString *)formatterNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setMaximumFractionDigits:fractionDigits];
    [numberFormatter setMinimumFractionDigits:0];
    [numberFormatter setMinimumIntegerDigits:1];
    
    return [numberFormatter stringFromNumber:number];
}
#endif

@end
