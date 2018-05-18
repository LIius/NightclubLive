//
//  WBDataPickView.h
//  NightclubLive
//
//  数据选取view
//  Created by RDP on 2017/3/28.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    PickStyleData,//选择数据
    PickStyleDate,//选择时间
}PickStyle;

typedef enum{
    DateModelTypeDate = 1,//显示日期
    DateModelTypeTime = 0,//显示时间
    DateModelTypeDateAndTime = 2,//显示日期跟时间
}DateModelType;

@interface RDPDataPickView : UIView

@property (nonatomic, assign) PickStyle style;
/** 时间显示类型 */
@property (nonatomic, assign) NSInteger dateModel;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSDate *maxDate;
/** 最小时间 */
@property (nonatomic, strong) NSDate *mineDate;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePickView;
@property (weak, nonatomic) IBOutlet UIPickerView *dataPickView;
/** 
 单行数据源
 */
@property (nonatomic, strong) NSArray *dataSource;
/** 二维数组 */
@property (nonatomic, strong) NSArray *datas;

/** 多行数据源 */
@property (nonatomic, strong) NSDictionary *dataSourceDic;
/**
 *  完成选择的列 行 用户Data 类型
 */
@property (nonatomic, copy) void (^CompleteBlock)(NSInteger component,NSInteger row);
/** 是否自动调整第二行序号 */
@property (nonatomic, assign) BOOL autoAdjustIndex;

/**
 *  选择时间
 */
@property (nonatomic, copy) void (^DateCompleteBlock)(NSDate *selectDate);

/**
 *  初始化
 *
 *  @param style 风格
 *
 *  @return 对象
 */
- (instancetype)initWithStyle:(PickStyle)style;

/**
 *  显示在某一个view
 */
- (void)show;
/**
 *  关闭
 */
- (void)close;

@end
