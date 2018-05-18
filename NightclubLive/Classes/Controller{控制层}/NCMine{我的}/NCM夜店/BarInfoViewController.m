//
//  BarInfoViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "BarInfoViewController.h"
#import "UINavigationBar+Awesome.h"
#import "BarRequestViewController.h"
#import "UINavigationBar+Awesome.h"
#import "MineModelList.h"
#import "MineRequest.h"
#import "UITextView+WZB.h"


@interface BarInfoViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) BarModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *headBackIV;

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *barLogoIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTV;

@end

@implementation BarInfoViewController
@dynamic model;

- (void)viewDidLoad {
    [super viewDidLoad];
   
    adjustsScrollViewInsets_NO(self.tableView,self);
    _messageTV.placeholder = @"请输入申请信息";
    _messageTV.placeholderColor = [UIColor lightGrayColor];
    
    //加载数据
    [_barLogoIV sd_setImageWithURL:self.model.image placeholderImage:[UIImage picturePlaceholder]];
    [_headBackIV sd_setImageWithURL:self.model.image placeholderImage:[UIImage picturePlaceholder]];
    _nameLabel.text = self.model.name;
    _distanceLabel.text = [NSString stringWithFormat:@"%@m",self.model.distance];
    _addressLabel.text = self.model.address;
    _phoneLabel.text = self.model.tel;
    
    CGSize size = [self.model.address getSizeWithFont:_nameLabel.font constrainedToSize:CGSizeMake(SCREEN_WIDTH - 10, SCREEN_HEIGHT * 0.5)];
    
    [self.view layoutIfNeeded];
    _headView.height = SCREEN_WIDTH + 135 +  size.height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar lt_reset];
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.messageTV];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
}

- (IBAction)requetClick:(id)sender
{
    ShowLoading
    //先获取token
    [CurrentUser getYWBToken:^(NSString *token) {
        
        BindBarRequest *bindR = [BindBarRequest new];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (token.length >0) {
            [params setValue:token forKey:@"token"];
        }
        if (self.model.ID.length > 0) {
            [params setValue:self.model.ID forKey:@"merchant.id"];
        }
        if (self.messageTV.text.length >0) {
            [params setValue:self.messageTV.text forKey:@"applyInfo"];
        }
        
        bindR.param = params;
        //bindR.param = @{@"token":token,@"merchant.id":self.model.ID,@"applyInfo":self.messageTV.text};
        
        [bindR startRequestWithCompleted:^(ResponseState *state) {
            
            CloseLoading
            if (state.isSuccess){
                ObjectViewController *vc = ViewController(@"BarRequestSB", @"BarRequestViewController");
                vc.model = self.model;
                PushViewController(vc);
            }
            else{
                ShowError(state.message);
            }
            

        }];

    }];
    
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = NavDefaultColor;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 50) {
        CGFloat alpha = MIN(1, 1 - ((50 + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

#pragma mark - Button Click
- (IBAction)calkClick:(id)sender
{
    NSString *calkPhone = [NSString stringWithFormat:@"telprompt://%@",self.model.tel];
    NSURL *calkURL = [NSURL URLWithString:calkPhone];
    [[UIApplication sharedApplication] openURL:calkURL];
}

@end
