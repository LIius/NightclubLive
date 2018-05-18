//
//  GiftInfoViewController.m
//  NightclubLive
//
//  Created by SuperDanny on 2017/1/13.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GiftInfoViewController.h"
#import "TagView.h"
#import "MineModelList.h"
#import "MineRequest.h"
#import "RDPDataPickView.h"


@interface GiftInfoViewController ()<UITextFieldDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *prizeIV;
@property (weak, nonatomic) IBOutlet UILabel *campaginNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *prizeNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *addressDetailsTF;
@property (weak, nonatomic) IBOutlet UITextField *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
@property (nonatomic, weak) PrizeListModel *model;
@end

@implementation GiftInfoViewController
@dynamic model;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)loadDataToView{
    
    [_prizeIV sd_setImageWithURL:URL([self.model.prizeImgs firstObject])  placeholderImage:[UIImage picturePlaceholder]];
    
    _campaginNameLabel.text = self.model.campaign_title;
    _prizeNameLabel.text = self.model.prize_name;
    
    
    if (self.model.status > 0){
        _getBtn.hidden = YES;
        _nameTF.enabled = NO;
        _phoneNumTF.enabled = NO;
        _addressDetailsTF.enabled = NO;
        _addressLabel.enabled = NO;
    }
    
    
}

- (IBAction)getClick:(id)sender {
    
    NSString *error =nil;
    if (_nameTF.text.length == 0)
        error = @"请填写领取人姓名";
    else if (_phoneNumTF.text.length == 0)
        error = @"请填写手机号码";
    else if (_addressLabel.text.length == 0)
        error = @"选择选择所在地";
    else if (_addressDetailsTF.text.length == 0)
        error = @"请填写详细地址";
    
    if (error){
        ShowError(error);
        return;
    }
    
    GetPrizeReqeust *r = [GetPrizeReqeust new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (CurrentUser.userID.length >0) {
        [params setValue:CurrentUser.userID forKey:@"user_id"];
    }
    if (self.model.ID.length > 0) {
        [params setValue:self.model.ID forKey:@"id"];
    }
    if (_nameTF.text.length >0) {
        [params setValue:_nameTF.text forKey:@"receiver"];
    }
    if (_phoneNumTF.text.length > 0) {
        [params setValue:_phoneNumTF.text forKey:@"phoneNum"];
    }
    if (_addressLabel.text.length >0) {
        [params setValue:_addressLabel.text forKey:@"province_city"];
    }
    if (_addressDetailsTF.text.length > 0) {
        [params setValue:_addressDetailsTF.text forKey:@"address"];
    }
    
    r.param = params;
    //r.param = @{@"user_id":CurrentUser.userID,@"id":self.model.ID,@"receiver":_nameTF.text,@"phoneNum":_phoneNumTF.text,@"province_city":_addressLabel.text,@"address":_addressDetailsTF.text};
    [r startRequestWithCompleted:^(ResponseState *state) {
        
        if (state.isSuccess){
            [self loadDataToView];
            self.model.status = 1;
            ShowSuccess(@"领取成功");
        }
        else
            ShowError(@"领取失败");
    }];
}

- (IBAction)addressClick:(id)sender {

    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cityData" ofType:@"plist"];
    NSDictionary *cityDic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    RDPDataPickView *pick = [[RDPDataPickView alloc] initWithStyle:PickStyleData];
    pick.dataSourceDic = cityDic;
    
    // 回调正确的地址
    pick.CompleteBlock = ^(NSInteger c,NSInteger r){//c 第一个，r 第二个
        NSString *province = [NSString stringFromeArray:[cityDic allKeys] index:c];
    
        NSArray *array = [cityDic arrayForKey:province];
        NSString *city = [NSString stringFromeArray:array index:r];
        
        _addressLabel.text = [NSString stringWithFormat:@"%@%@",province,city];
    };
    [pick show];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}
@end
