//
//  InfoCell.m
//  NightclubLive
//
//  Created by SuperDanny on 2017/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "InfoCell.h"

@interface InfoCell ()

@property (weak, nonatomic) IBOutlet UITextField *IDTf;
///星座
@property (weak, nonatomic) IBOutlet UITextField *constellationTf;
///情感状态
@property (weak, nonatomic) IBOutlet UITextField *affectiveTf;
///职业
@property (weak, nonatomic) IBOutlet UITextField *professionTf;
///收入
@property (weak, nonatomic) IBOutlet UITextField *incomeTf;

@end

@implementation InfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeight {
    return 150;
}

- (void)configureDataWithModel:(id)model {
    
}

#pragma mark - 星座
- (IBAction)constellationAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _constellationTf.enabled = sender.isSelected;
    if (sender.isSelected) {
        [_constellationTf becomeFirstResponder];
    }
}

#pragma mark - 情感
- (IBAction)affectiveAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _affectiveTf.enabled = sender.isSelected;
    if (sender.isSelected) {
        [_affectiveTf becomeFirstResponder];
    }
}

#pragma mark - 职业
- (IBAction)professionAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _professionTf.enabled = sender.isSelected;
    if (sender.isSelected) {
        [_professionTf becomeFirstResponder];
    }
}

#pragma mark - 收入
- (IBAction)incomeAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _incomeTf.enabled = sender.isSelected;
    if (sender.isSelected) {
        [_incomeTf becomeFirstResponder];
    }
}


@end
