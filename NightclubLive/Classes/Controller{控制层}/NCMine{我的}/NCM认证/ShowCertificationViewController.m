//
//  ShowCertificationViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/3/15.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ShowCertificationViewController.h"
#import "AuthModel.h"
#import "GlobalRequest.h"

@interface ShowCertificationViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *IDCardLabel;

@property (weak, nonatomic) IBOutlet UIImageView *handIV;
@property (weak, nonatomic) IBOutlet UIImageView *fIV;
@property (weak, nonatomic) IBOutlet UIImageView *bIV;

@end

@implementation ShowCertificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获取认证信息
    
    ShowLoading;
    
    GetJobRequest *r = [GetJobRequest new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.model) {
        [params setValue:self.model forKey:@"userId"];
    }
    r.param = params;
    //r.param = @{@"userId":self.model};
#warning 这里是什么？
    [r startRequestWithCompleted:^(ResponseState *state) {
        
        if (state.isSuccess){
            
            AuthJobModel *m = [AuthJobModel objectWithDic:[state.datas firstObject]];
            _nameLabel.text = m.userName;
            _jobLabel.text = m.occupation;
            _IDCardLabel.text = m.idnumber;
           // NSString *handIM = m.idimageUrl[handheldImageKey]);
            [_handIV sd_setImageWithURL:URL(m.idiImageDic[handheldImageKey])];
            [_fIV sd_setImageWithURL:URL(m.idiImageDic[positiveImageKey])];
            [_bIV sd_setImageWithURL:URL(m.idiImageDic[backImageKey])];
        }
        
        CloseLoading;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
