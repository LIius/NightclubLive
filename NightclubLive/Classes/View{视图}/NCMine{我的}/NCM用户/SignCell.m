//
//  SignCell.m
//  NightclubLive
//
//  Created by SuperDanny on 2017/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "SignCell.h"

@interface SignCell ()

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UITextField *signTf;
@property (weak, nonatomic) IBOutlet UILabel *signLab;

@end

@implementation SignCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)cellHeightWithModel:(id)model {
    return 50;
}

- (void)configureDataWithModel:(id)model {
    
}

#pragma mark - 个性签名
- (IBAction)constellationAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _signTf.enabled = sender.isSelected;
    if (sender.isSelected) {
        [_signTf becomeFirstResponder];
    }
}

@end
