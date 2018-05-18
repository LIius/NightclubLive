//
//  DDCustomPickerView.h
//  YanYou
//
//  Created by SuperDanny on 16/9/12.
//  Copyright © 2016年 SuperDanny ( http://SuperDanny.link/ ). All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDPickerStyle) {
    DDPickerStyle_1 = 1,
    DDPickerStyle_2 = 2,
    DDPickerStyle_3 = 3,
};

@interface DDCustomPickerView : UIView

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (instancetype)initWithStyle:(DDPickerStyle)pickerStyle;

- (void)setSelectBlock:(void(^)(NSInteger row, NSInteger component))block;
- (void)setChooseBlock:(void(^)())block;
/**
 *  设置行数
 *
 *  @param block 回调
 */
- (void)setNumberOfRowsBlock:(NSUInteger(^)(NSInteger component))block;
/**
 *  设置文本
 *
 *  @param block 回调
 */
- (void)setTitleForRowBlock:(NSString *(^)(NSInteger row, NSInteger component))block;

- (void)showInView:(UIView *)view;
- (IBAction)dismiss;

@end
