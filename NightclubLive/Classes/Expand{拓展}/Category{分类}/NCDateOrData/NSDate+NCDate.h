//
//  NSDate+NCDate.h
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NCDate)


/**
 *  比较两个时间差
 *
 *  @param date 比较时间
 *
 *  @return 字符串格式按照上面所诉
 */
- (NSString *)capDate:(NSDate *)date;

/**
 *  与当前时间比较
 *
 *  @return 字符串返回
 */
- (NSString *)capNowDate;




/** 获取时间字符串 格式 YYYY-MM-DD */
@property (nonatomic, copy) NSString *YMDString;
/** 中文格式数据字符串 2019年9月25日 */
@property (nonatomic, copy) NSString *YMDChinaString;
/** 时间字符串 格式为2019/9/25  */
@property (nonatomic, copy) NSString *YMDSlashString;
/** 中午格式字符串 11月14号 11:45 */
@property (nonatomic, copy) NSString *YDMMChinaString;
/** 时间字符串 格式 2019-08-19 11：11：11 */
@property (nonatomic, copy) NSString *YMDHMSStirng;
/** 时间字符串 格式 2019年08月01日 11：11：11 */
@property (nonatomic, copy) NSString *YMDHMChinaString;
/** 时间字符串 格式 2019年08月01日 11:11 */
@property (nonatomic, copy) NSString *YMDHMChinaString2;
/** 获取日期 */
@property (nonatomic, copy) NSString *HMChinaString;
/** 获取时分 */
@property (nonatomic, copy) NSString *HHmmString;

/**
 *  与当前目前时间差
 *  规则
 *  “X分钟前”，“X小时前”，“X天前”，今年的“月份-日期 时：分”，往年的显示“年份-月份-日期 时：分”
 */
@property (nonatomic, copy) NSString *difftime;
/**
 *  获取字符串
 *
 *  @param formatter 格式
 *
 *  @return 字符串
 */
- (NSString *)timeStringWithFormatter:(NSString *)formatter;

@end
