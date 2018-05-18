//
//  TipsVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/5.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "TipsVC.h"

@interface TipsVC ()
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

@implementation TipsVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[self.doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                
    }];
    
  //  self.view.layer.cornerRadius

}

@end
