//
//  AddressBookHeaderView.m
//  NightclubLive
//
//  Created by SuperDanny on 2017/1/17.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AddressBookHeaderView.h"

@interface AddressBookHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *arrowBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (copy, nonatomic) void(^Select_Block)(BOOL);
@end

@implementation AddressBookHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"AddressBookHeaderView" owner:self options:nil] firstObject];
    if (self) {
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title status:(BOOL)isOpen {
    self = [[[NSBundle mainBundle] loadNibNamed:@"AddressBookHeaderView" owner:self options:nil] firstObject];
    if (self) {
        self.titleLab.text = title;
        self.arrowBtn.selected = isOpen;
    }
    return self;
}

- (void)setSelectBlock:(void (^)(BOOL))block {
    self.Select_Block = block;
}

- (IBAction)action:(UIButton *)sender {
    _arrowBtn.selected = !_arrowBtn.selected;
//    _bottomLine.hidden = _arrowBtn.isSelected;
    
    if (_Select_Block) {
        _Select_Block(_arrowBtn.isSelected);
    }
}

- (IBAction)invationClick:(id)sender {
    
    if (self.invitionBlock)
        self.invitionBlock(nil);
}

@end
