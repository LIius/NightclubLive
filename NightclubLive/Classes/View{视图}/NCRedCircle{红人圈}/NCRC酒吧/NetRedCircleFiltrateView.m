//
//  NetRedCircleFiltrateView.m
//  NightclubLive
//
//  Created by RDP on 2017/6/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "NetRedCircleFiltrateView.h"


@implementation NetRedCircleFiltrateView

- (void)awakeFromNib{
    [super awakeFromNib];
    _color = RGBCOLOR(146, 65, 230);
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
}

- (IBAction)okBtn:(id)sender {
    
    [self close];
    
    if (_okBlock)
        _okBlock(@(_selectRow));
}

#pragma mark - 改变事件

- (IBAction)tagClick:(UIButton *)sender {
    
    [self selectStyleWithBtn:sender];
    
    for (UIView *v in self.contentView.subviews){
        
        if (v.tag < 10 && ![v isEqual:sender] && [v isKindOfClass:[UIButton class]])
            [self normalStypeWithBtn:(UIButton *)v];
    }
    
    _selectRow = sender.tag;
}

- (void)selectStyleWithBtn:(UIButton *)btn{

    [btn setBackgroundColor:_color];
    [btn setBorderColor:_color borderWidth:0];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)normalStypeWithBtn:(UIButton *)btn{
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setBorderColor:_color borderWidth:1];
    [btn setTitleColor:_color forState:UIControlStateNormal];
    
}


#pragma mark - 事件

- (void)show{


    if (_hiddeStatue == 1){
        [self close];
        _hiddeStatue = 0;
        return;
    }
    
    
    //先移除外面
    self.x = SCREEN_WIDTH;
    
    //慢慢移进来
    [UIView animateWithDuration:1.0 animations:^{
        
        self.x = SCREEN_WIDTH - self.width;
    }];
    
    [self tagClick:[self.contentView viewWithTag:_selectRow]];
    //UIView *v = [self.contentView viewWithTag:selectRow];
    
  //  [self tagClick:(UIButton *)v];
    _hiddeStatue = 1;
}

- (void)close{
    
    if (_hiddeStatue == 0){
        [self show];
        _hiddeStatue = 1;
        return;
    }
    
    //慢慢移出去
    [UIView animateWithDuration:1.0 animations:^{
        self.x = SCREEN_WIDTH;
    }];
    
    _hiddeStatue = 0;
}

- (IBAction)viewClick:(id)sender {
    [self close];
}

#pragma mark - Set

- (void)setSelectRow:(NSInteger)selectRow{
    
    _selectRow = selectRow;
    
}


@end
