//
//  BarRequestViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "BarRequestViewController.h"
#import "MineRequest.h"


#import "SystemTool.h"

@interface BarRequestViewController ()
/** 对象 */
@property (nonatomic, weak) BarModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *connectBarBtn;
@property (weak, nonatomic) IBOutlet UILabel *barNameLabel;

@end

@implementation BarRequestViewController

@dynamic model;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_connectBarBtn setBorderColor:APPDefaultColor borderWidth:0.5];
    _logoIV.isRound = YES;
    
    //记载数据到界面
    
    [_logoIV sd_setImageWithURL:self.model.image placeholderImage:[UIImage picturePlaceholder]];
    _barNameLabel.text = self.model.name;
    
    NSString *nowTimeString = [NSDate date].YMDHMChinaString;
    NSString *tipString = [NSString stringWithFormat:@"您的申请已于%@成功发送,如果酒吧方未在48小时内进行操作则可发起新的加入申请,请耐性等待吧回复",nowTimeString];
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc] initWithString:tipString];
    [mString addAttribute:NSForegroundColorAttributeName value:APPDefaultColor range:NSMakeRange(6, nowTimeString.length)];
    [mString addAttribute:NSForegroundColorAttributeName value:APPDefaultColor range:NSMakeRange(18 + nowTimeString.length, 4)];

    _tipLabel.attributedText = mString;
    [_tipLabel sizeToFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connectBar:(id)sender {
}

- (IBAction)calkBSClick:(id)sender {
    
    NSString *calkPhone = [NSString stringWithFormat:@"telprompt://%@",self.model.tel];
    
    NSURL *calkURL = [NSURL URLWithString:calkPhone];
    
    [[UIApplication sharedApplication] openURL:calkURL];
    
}


- (IBAction)alertMerchantClick:(UIButton *)sender {
    
    //获取token
    [CurrentUser getYWBToken:^(NSString *token) {
        
        AlertBindRequest *r = [AlertBindRequest new];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (token.length >0) {
            [params setValue:token forKey:@"token"];
        }
        if (self.model.ID.length > 0) {
            [params setValue:self.model.ID forKey:@"merchant.id"];
        }
        r.param = params;
        //r.param = @{@"token":token,@"merchant.id":self.model.ID};
        
        [r startRequestWithCompleted:^(ResponseState *state) {
            
            
            if (state.isSuccess){
                [sender setBackgroundColor:[UIColor lightGrayColor]];
                [sender setUserInteractionEnabled:NO];
            }
            else{
                ShowError(@"提醒失败");
            }
        }];
    }];
}

@end
