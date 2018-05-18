//
//  TangTangPairSuccessVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/11.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "TangTangPairSuccessVC.h"
#import "User.h"
#import "GlobalRequest.h"
#import "GlobalModel.h"

@interface TangTangPairSuccessVC ()

@property (weak, nonatomic) IBOutlet UIButton *popHomeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *selfImageView;
@property (weak, nonatomic) IBOutlet UIImageView *heImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContstantH;

@end

@implementation TangTangPairSuccessVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(id x) {
        self.navigationController.navigationBar.hidden = NO;
    }];
    
    [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        self.navigationController.navigationBar.hidden = YES;
    }];
    [[_popHomeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];

    
    [_selfImageView sd_setImageWithURL:[UserInfo shareUser].user.profile_photo];
    [_heImageView sd_setImageWithURL:self.loveUser.profilePhoto];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews ];
#warning iPhoneX
    if (iPhoneX)
    {
        [self.topContstantH setConstant:50];
    }
}

- (IBAction)backClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)chatClick:(id)sender
{
    NIMSession *session = [NIMSession session:self.loveUser.phoneNum type:NIMSessionTypeP2P];
    
    NIMSessionViewController *chatVC = [[NIMSessionViewController alloc] initWithSession:session];
    
    [self.navigationController pushViewController:chatVC animated:YES];
}

@end
