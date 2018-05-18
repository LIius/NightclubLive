//
//  SelectSexView.h
//  AgileCarRental
//
//  Created by WanBo on 16/9/11.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MMPopupView/MMPopupView.h>

@interface ShareView : MMPopupView
{
    UIButton *_maskView;
}

//
@property (weak, nonatomic) IBOutlet UIButton *weiBoBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiXinBtn;
@property (weak, nonatomic) IBOutlet UIButton *pyqBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;


+ (instancetype)shareView;
- (void)dismissMaskView;
- (void)showMaskView;
- (void)setUP;

@end
