//
//  GiftCountView.m
//  NightclubLive
//
//  Created by RDP on 2017/7/21.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GiftCountView.h"
#import "UIView+ScottAlertView.h"


@implementation GiftCountView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    if (self.count == 0)
        self.count = 1;
    
    _countTF.text = [NSString stringWithFormat:@"%ld",self.count];
    
}

- (void)setCount:(NSInteger)count{
    
    _count = count;

    _countTF.text = [NSString stringWithFormat:@"%ld",count];
}

- (IBAction)okClick:(id)sender {
    
    if (self.okBlock){
        self.okBlock(@([_countTF.text integerValue]));
    }
    
    [self dismiss];
}

- (IBAction)cancelClick:(id)sender {
    
    [self dismiss];
}

@end

