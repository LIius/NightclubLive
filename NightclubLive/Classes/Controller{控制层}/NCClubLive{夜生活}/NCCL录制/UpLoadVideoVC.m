//
//  UpLoadVideoVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/11.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "UpLoadVideoVC.h"
#import "MRCViewModel.h"

@interface UpLoadVideoVC ()

@property (weak, nonatomic) IBOutlet UIButton *dissMissBtn;
@property (weak, nonatomic) IBOutlet UIButton *LocalVideoBtn;
@property (weak, nonatomic) IBOutlet UIButton *RecordingAction;

@property (nonatomic, strong) MRCViewModel *viewModel;

@end

@implementation UpLoadVideoVC
@dynamic viewModel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupDismissBtn];
    
    [self setupLocalVideo];
    
    [self setupNowVideo];
}

- (void)setupDismissBtn
{
    [[self.dissMissBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x)
     {
         
         [self dismissViewControllerAnimated:YES completion:^{
             
         }];
     }];
}

- (void)setupLocalVideo
{
    [[self.LocalVideoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x)
     {
         [self dismissViewControllerAnimated:YES completion:^{
             if (self.viewModel.callback) {
                 self.viewModel.callback(@1);
             }
             
             if (self.calkBlock){
                 self.calkBlock(@1);
             }
             
         }];
     }];
    
    _LocalVideoBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)setupNowVideo
{
    [[self.RecordingAction rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x)
     {
         [self dismissViewControllerAnimated:YES completion:^{
             if (self.viewModel.callback) {
                 self.viewModel.callback(@0);
             }
             
             if (self.calkBlock)
                 self.calkBlock(@0);
             
         }];
     }];
    
    _RecordingAction.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
