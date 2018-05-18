//
//  BusinessNoAuthViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "BusinessNoAuthViewController.h"

@interface BusinessNoAuthViewController ()

@end

@implementation BusinessNoAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.tag == 1){
        self.navigationItem.title = @"夜店管理";
        self.titleLabel.text = @"尚未绑定夜店";
        self.contentLabel.text = @"绑定夜店可以让用户直接进行夜店约台操作";
    

        [self.btn setTitle:@"绑定夜店" forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)autoClick:(id)sender {
    
    if (self.tag == 0 ){
        PushViewController(ViewController(@"BussinessSB", @"BusinessTableViewController"));
    }
    else{
        PushViewController(ViewController(@"SearchBarSB", @"SearchBarViewController"));
    }
}

@end
