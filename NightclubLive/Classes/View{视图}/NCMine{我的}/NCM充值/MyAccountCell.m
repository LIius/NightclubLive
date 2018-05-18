//
//  MyAccountCell.m
//  NightclubLive
//
//  Created by RDP on 2017/4/13.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MyAccountCell.h"
#import "GlobalModel.h"

@implementation MyAccountCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = RGBCOLOR(153, 153, 153).CGColor;
    self.layer.cornerRadius = 5;
}

- (void)setModel:(AddedValuePackageModel *)model{
    
    [super setModel:model];
    
     NSString *orgrinPrice = [NSString stringWithFormat:@"%.2f",[model.rmbValue doubleValue]];
    
    _nightBitLabel.text = model.packageName;
    _rmbLabel.text = [NSString stringWithFormat:@"%@元",[orgrinPrice rmbWithoutZero:orgrinPrice]];
}

- (void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    if (selected){
        
        self.nightBitLabel.textColor = [UIColor whiteColor];
        self.rmbLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = RGBCOLOR(205, 79, 161);
        self.layer.borderWidth = 0;
        
    }else{
        
        self.nightBitLabel.textColor = RGBCOLOR(51, 51, 51);
        self.rmbLabel.textColor = RGBCOLOR(153, 153, 153);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = RGBCOLOR(153, 153, 153).CGColor;
    }
}
@end
