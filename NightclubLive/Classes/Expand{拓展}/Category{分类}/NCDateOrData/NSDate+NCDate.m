//
//  NSDate+NCDate.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NSDate+NCDate.h"
#import "NSDate+Utilities.h"

@implementation NSDate (NCDate)

@dynamic YMDString,YMDChinaString;




- (NSString *)capNowDate{
    
    NSDateFormatter *form = [[NSDateFormatter alloc] init];
    
    if([self isYesterday]){
        return @"昨天";
    }
    
    if ([self isToday]){
        return @"今天";
    }
    
    [form setDateFormat:@"yy-MM-dd"];
    
    return [form stringFromDate:self];
}





- (NSString *)YMDString{
    return [self dateConvertStringWithFormatter:@"yyyy-MM-dd"];
}

- (NSString *)YMDChinaString{
    return [self dateConvertStringWithFormatter:@"yyyy年M月dd日"];
}

- (NSString *)HMChinaString{
    return [self dateConvertStringWithFormatter:@"MM月dd日"];
}

- (NSString *)YDMMChinaString{
    return [self dateConvertStringWithFormatter:@"MM月dd日 HH:mm"];
}

- (NSString *)HHmmString{
    
    return [self dateConvertStringWithFormatter:@"HH:mm"];
}

- (NSString *)YMDSlashString{
    
    return [self dateConvertStringWithFormatter:@"yyyy/MM/dd"];
}

- (NSString *)YMDHMSStirng{
    
    return [self dateConvertStringWithFormatter:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)YMDHMChinaString{
    
    return [self dateConvertStringWithFormatter:@"yyyy年MM月dd日 HH:mm:ss"];
}

- (NSString *)YMDHMChinaString2{
    
    return [self dateConvertStringWithFormatter:@"yyyy年MM月dd日 HH:mm"];
}

- (NSString *)timeStringWithFormatter:(NSString *)formatter{
    
    return [self dateConvertStringWithFormatter:formatter];
}

- (NSString *)difftime{
    
    NSDate *nowTime = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:nowTime];
    NSDate *localeDate = [nowTime  dateByAddingTimeInterval: interval];
    nowTime = localeDate;
    
    BOOL isToday = nowTime.year == self.year && nowTime.month == self.month && nowTime.day == self.day;
    
    
    //判断时间差
    NSInteger hourSecGap =  [nowTime timeIntervalSinceDate:self];
    
    //判断是不是今天
    if(isToday){
        //相差是不是超过一个小时
        NSInteger hourGap = nowTime.hour - self.hour;
        
        if ( hourSecGap > 60  * 60){
            return [NSString stringWithFormat:@"%ld小时前",hourGap];
        }
        else{//在一个小时之内
            NSInteger minuteGap = nowTime.minute - self.minute;
            if (hourSecGap < 60){
                NSInteger secondGap = nowTime.seconds - self.seconds;
                if (secondGap < 0)
                    secondGap *= -1;
                return [NSString stringWithFormat:@"%ld秒前",secondGap];
            }else{
                return [NSString stringWithFormat:@"%ld分钟前",(long)(hourSecGap / 60)];
            }
        }
    }
    else{
        if (self.year){//同一年
            
            //月份差距
            NSInteger month = nowTime.month - self.month;
            
            if (month == 0){
                NSInteger dayGap = nowTime.day - self.day;
                
                //没有超过一个星期
                if (dayGap < 7){
                    return [NSString stringWithFormat:@"%ld天前",dayGap];
                }
            }
        }
    }
    
    return [self dateConvertStringWithFormatter:@"yyyy-MM-dd HH:mm"];
}


- (NSString *)dateConvertStringWithFormatter:(NSString *)formatter{
    NSDateFormatter *dft = [[NSDateFormatter alloc] init];
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    [dft setTimeZone:GTMzone];
    [dft setDateFormat:formatter];
    return [dft stringFromDate:self];
}

- (NSString *)dateConvert2StringWithFormatter:(NSString *)formatter{
    NSDateFormatter *dft = [[NSDateFormatter alloc] init];
    NSTimeZone* GTMzone = [NSTimeZone systemTimeZone];
    [dft setTimeZone:GTMzone];
    [dft setDateFormat:formatter];
    return [dft stringFromDate:self];
}

@end
