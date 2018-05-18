//
//  CheckVersionViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "CheckVersionViewController.h"
#import "SystemTool.h"

@interface CheckVersionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *visionLabel;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

@end

@implementation CheckVersionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _updateBtn.hidden = YES;

    [self checktVersion];
}

- (void)checktVersion
{
    @weakify(self);
    // 开始检测版本中
    [[SystemTool share] checkVersionCompletion:^(NSString *storeVersion, NSString *currentVersion, BOOL canUpdate)
     {
         @strongify(self);
         
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            NSString *msg = @"";
                            
                            if (!canUpdate)
                            {
                                msg = @"已经是最新版本";
                                _updateBtn.hidden = YES;
                                
                            }else{
                                msg =  [NSString stringWithFormat:@"当前版本%@,可更新到%@版本",currentVersion,storeVersion];
                                _updateBtn.hidden = NO;
                            }
                            
                            self.visionLabel.text = msg;
                        });
         
     }];
}

- (IBAction)updateClick:(id)sender
{
    [[SystemTool share] beginUpdateApp];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
