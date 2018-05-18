//
//  WBDataPickView.m
//  NightclubLive
//
//  Created by RDP on 2017/3/28.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "RDPDataPickView.h"

NSTimeInterval AnimationDuration = 0.3;

@interface RDPDataPickView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabl;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) NSInteger selectComponent;
@property (nonatomic, assign) NSInteger selectRow;
@property (nonatomic, assign) PickStyle stype;

@end

@implementation RDPDataPickView

- (instancetype)initWithStyle:(PickStyle)style
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"RDPDataPickView" owner:nil options:nil] firstObject];
    
    self.selectRow =0;
    self.selectComponent = 0;
    _dateModel = 1;
    self.style = style;
    if (style == PickStyleData)
        [self.datePickView removeFromSuperview];
    else{
        [self.dataPickView removeFromSuperview];
        [self.datePickView addTarget:self action:@selector(datePickView) forControlEvents:UIControlEventValueChanged];
        self.titleLabl.text = @"时间选择";

    }
    self.autoAdjustIndex = YES;
    return self;
}

- (void)show
{
    _backView = [[UIView alloc] initWithFrame:ShareWindow.bounds];
    _backView.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
    [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)]];
    
    [ShareWindow addSubview:_backView];
    [_backView addSubview:self];
    
    self.frame = CGRectMake(0, ShareWindow.height, ShareWindow.width, ShareWindow.height * 0.314);
    
    [UIView animateWithDuration:AnimationDuration animations:^{
        
        self.frame = CGRectMake(0, ShareWindow.height - self.height, self.width, self.height);
    }];
    
    if (_style == PickStyleData)
        [_dataPickView reloadAllComponents];
    else{
        NSDateFormatter *dft = [[NSDateFormatter alloc] init];
        [dft setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *miniTime = [dft dateFromString:@"1949-01-01 10:00:01"];
        _datePickView.minimumDate = miniTime;
        
        if (self.maxDate){
            // 强制装24小时制
            _datePickView.maximumDate = self.maxDate;
        }
        
        if (_mineDate){
            
            // 强制转24小时制
            _datePickView.minimumDate = _mineDate;
            _datePickView.datePickerMode = _dateModel;
        }
    }
}


- (void)close
{
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.frame  = CGRectMake(0, ShareWindow.height, ShareWindow.width, ShareWindow.height);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        [_backView removeFromSuperview];
    }];
}


#pragma mark - Pick Data

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_dataSource)
    {
        // 单行
        NSArray *obj = [_dataSource firstObject];
        
        if ([obj isKindOfClass:[NSArray class]]){
            
            return obj.count;
        }
        
        return _dataSource.count;
    }
    else if (_dataSourceDic){
        // 多行
        if (component == 0)
        {
            return [_dataSourceDic allKeys].count;
        }
        else{
            NSArray *array = _dataSourceDic[[_dataSourceDic allKeys][[pickerView selectedRowInComponent:component] ]];
            
            return array.count;
        }
    }
    else if (_datas){
        
        if (component == 0){
            NSArray *arr = _datas[0];
            return arr.count;
        }else{
            NSArray *arr = _datas[1];
            return arr.count;
        }
    }
    return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.dataSource){
        return 1;
    }
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.dataSource){
        NSArray *obj = [_dataSource firstObject];
        
        if ([obj isKindOfClass:[NSArray class]]){
            
            NSArray *titles = _dataSource[component];
            
            return titles[[pickerView selectedRowInComponent:component]];
        }
        
        return _dataSource[row];
    }
    else if (_dataSourceDic){
        
        if (component == 0){
            return [self.dataSourceDic allKeys][row];
        }
        else{
            NSArray *array = self.dataSourceDic[[self.dataSourceDic allKeys][[pickerView selectedRowInComponent:0]]];
            
            if (row > array.count)
                return @"";
            
            return array[row];
            
                    }
    }
    else{
        if (component == 0){
            NSArray *arr = _datas[0];
            
            return arr[row];
        }else{
            NSArray *arr = _datas[1];
            
            return arr[row];

        }
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_dataSourceDic){
        
        if (component == 0 && self.autoAdjustIndex){
            [pickerView selectRow:0 inComponent:1 animated:NO];
        }
    }
    
    if (self.dataSource){
        _selectRow = row;
        _selectComponent = 0;
    }
    else{
        _selectRow = [pickerView selectedRowInComponent:0];
        _selectComponent = [pickerView selectedRowInComponent:1];
    }
}

#pragma mark - Button Click
- (IBAction)okClick:(id)sender
{
    if (_style == PickStyleData){
            if (_CompleteBlock)
                _CompleteBlock(_selectRow,_selectComponent);
            }
    else{
            if (_DateCompleteBlock)
                _DateCompleteBlock(_datePickView.date);
            }
    [self close];
}


#pragma mark - Data
- (void)dateChange:(UIDatePicker *)datePick
{
    
}

#pragma mark - Setter
- (void)setTitle:(NSString *)title
{
    _titleLabl.text = title;
}

@end
