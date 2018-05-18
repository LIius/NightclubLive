//
//  MyBillDetailTableViewController.m
//  NightclubLive
//
//  Created by SuperDanny on 2016/12/11.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "MyBillDetailTableViewController.h"
#import "MineModelList.h"

#import "MineRequest.h"

#import "PayListRequest.h"
#import <AlipaySDK/AlipaySDK.h>
#import "SuccessInfoViewController.h"
#import "WXApi.h"

typedef enum{
    PayTypeLooseChange,//零钱
    PayTypeWeiChat,//微信
    PayTypeAliPay,//支付宝
}PayType;

@interface MyBillDetailTableViewController ()

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *payLCGest;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *personCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *seatLabel;
@property (weak, nonatomic) IBOutlet UILabel *packageLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UIButton *payTypeAlipayBtn;
@property (weak, nonatomic) IBOutlet UIButton *payTypeLCBtn;
@property (weak, nonatomic) IBOutlet UIButton *payTypeWeiChatBtn;
@property (weak, nonatomic) IBOutlet UIButton *aginDowOrderBtn; // 再来一单
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIView *lqView;
@property (weak, nonatomic) IBOutlet UIView *weichatView;
@property (weak, nonatomic) IBOutlet UIView *alipayView;
@property (weak, nonatomic) IBOutlet UIButton *okView;

/** 支付类型 */
@property (nonatomic, assign) PayType payType;
/** 对象 */
@property (nonatomic, weak) DownOrderModel *model;
/** 订单列表model */
@property (nonatomic, weak) OrderListModel *listOrderModel;

@end

@implementation MyBillDetailTableViewController

@dynamic model;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.payType = 0;
    [self setupViewDidload];
    [self setupOrderRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayReback:) name:NOTIFICATION_ALIPAYREBACK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weichatpayReback:) name:NOTIFICATION_WEICHATREBACK object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Data Source
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 0;
    }
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 0;
    }else if (section == 3){
        return 2;
    }
    
    return 0;
}

- (void)setupViewDidload
{
    if (_orderModel)
    {
        _aginDowOrderBtn.hidden = !(self.orderModel.status == 5);
        _footView.hidden = !(self.orderModel.status == 6 || self.orderModel.status == 1);
        if (self.orderModel.status == 6)
        {
            _lqView.hidden = YES;
            _weichatView.hidden = YES;
            _okView.hidden = YES;
            _alipayView.hidden = YES;
            _aginDowOrderBtn.hidden = NO;
        }
        
        [self payTypeClick:_payLCGest];
    }
    
    // 加载数据
    if (self.model)
    {
        [_logoIV sd_setImageWithURL:self.model.barModel.image];
        _nameLabel.text = self.model.barModel.name;
        _addressLabel.text = self.model.barModel.address;
        _personNameLabel.text = self.model.name;
        _personPhoneLabel.text = self.model.phone;
        _remarkLabel.text = self.model.remark;
        _priceLabel.text = [NSString stringWithFormat:@"%@元",self.model.packgeModel.price];
        _timeLabel.text = self.model.date.YMDHMChinaString2;
        // _personCountLabel.text = self.model.personCount;
        _seatLabel.text  = self.model.tableNo;
        _packageLabel.text = self.model.packgeModel.name;
        
        [self payTypeClick:_payLCGest];
    }
}

#pragma mark - 请求订单详情
- (void)setupOrderRequest
{
    @weakify(self);
    NSString *orderID = self.orderID ? self.orderID : self.orderModel.ID;
    DLog(@"orderID=%@",[orderID class]);
    ShowLoading;
    // 获取订单详情
    [CurrentUser getYWBToken:^(id param)
     {
         OrderDetailsRequest *r = [OrderDetailsRequest new];
         NSMutableDictionary *params = [NSMutableDictionary dictionary];
         if (param) {
             [params setValue:param forKey:@"token"];
         }
         if (orderID.length > 0) {
             [params setValue:orderID forKey:@"order.id"];
         }
         
         r.param = params;
         //r.param = @{@"token":param,@"order.id":orderID};
         [r startRequestWithCompleted:^(ResponseState *state)
         {
             @strongify(self);
             NSArray *arr = [OrderListModel arrayObjectWithDS:@[state.data]];
             
             OrderListModel *m = arr.firstObject;
             _listOrderModel = _orderModel;
             self.orderModel = m;
             CloseLoading
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 // 加载数据到界面
                 [_logoIV sd_setImageWithURL:m.image];
                 _nameLabel.text = m.merchant.name;
                 //   _addressLabel.text = self.orderModel.barModel.address;
                 _personNameLabel.text = m.contactName;
                 _personPhoneLabel.text = m.contactMobile;
                 _remarkLabel.text = m.remarks;
                 _priceLabel.text = [NSString stringWithFormat:@"%@元",m.total];
                 _timeLabel.text = m.arrivalTime.YMDHMChinaString2;
                 // _personCountLabel.text = m.mealNumber;
                 _seatLabel.text  = m.tableNo;
                 _packageLabel.text = m.name;
                 _orderNoLabel.text = m.orderNo;
                 _addressLabel.text = m.merchant.address;
                 
                 self.orderModel = m;
                 
                 if (m.status > 0){
                     // _footView.height = 51;
                     
                 }
                 else{
                     _aginDowOrderBtn.hidden = YES;
                 }
             });
             
             
         }];
         
     }];
}

#pragma mark - 阿里支付回调
- (void)alipayReback:(NSNotification *)notification
{
    NSDictionary *param = notification.object;
    NSInteger statues = [param[@"resultStatus"] integerValue];
    
    [self payResult:statues == 9000];
}

#pragma mark - 微信支付回调
- (void)weichatpayReback:(NSNotification *)notification
{
    NSInteger errorInt = [notification.object integerValue];
    
    [self payResult:errorInt == WXSuccess];
}

#pragma mark - 处理支付结果
- (void)payResult:(BOOL)result
{
    if (result)
    {
        SuccessInfoViewController *successVC =  ViewController(@"SuccessInfoSB", @"SuccessInfoViewController");
        successVC.viewType = SuccessType_Pay;
        [self.navigationController pushViewController:successVC animated:YES];
    }
    else{
        ShowError(@"支付失败");
    }
}

#pragma mark - pay Gest
- (IBAction)payTypeClick:(UITapGestureRecognizer *)sender
{
    UIView *superView = sender.view;
    NSInteger tag = superView.tag;
    
    _payType = (PayType)tag;
 
    // 改变样式
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    
    if (tag == 0)
    {
        btn1 = _payTypeLCBtn;
        btn2 = _payTypeWeiChatBtn;
        btn3 = _payTypeAlipayBtn;
    }
    else if (tag == 1){
        btn1 = _payTypeWeiChatBtn;
        btn2 = _payTypeLCBtn;
        btn3 = _payTypeAlipayBtn;
    }
    else{
        btn1 = _payTypeAlipayBtn;
        btn2 = _payTypeLCBtn;
        btn3 = _payTypeWeiChatBtn;
    }
    
    [btn1 setImage:KGetImage(@"支付页面-支付方式选中状态") forState:    UIControlStateNormal];
    [btn2 setImage:KGetImage(@"支付页面-支付方式未选中状态") forState:UIControlStateNormal];
    [btn3 setImage:KGetImage(@"支付页面-支付方式未选中状态") forState:UIControlStateNormal];
}

#pragma mark - 确认支付
- (IBAction)payClick:(id)sender
{
    PayBaseRequest *payR = [PayFactory createPayRequestWithType:_payType];
    payR.package  = self.model.name ? self.model.name : self.orderModel.name;
    payR.orderNO = self.orderModel.orderNo;
    payR.paid = self.model ?  self.model.packgeModel.price : self.orderModel.paid;
    
    @weakify(self);
    [payR startRequestWithCompleted:^(ResponseState *state)
     {
         @strongify(self);
        if (!state.isSuccess){
            ShowError(state.message);
        }
        else{
        // 支付
         switch (_payType) {
         case PayTypeAliPay:{
             
             //支付宝支付
             [[AlipaySDK defaultService] payOrder:state.data fromScheme:@"NightclueLive" callback:^(NSDictionary *resultDic) {
             }];
             
             
         }break;
         case PayTypeWeiChat:{
             
             //微信支付
             PayReq *request = [[PayReq alloc] init];
             NSDictionary *weixinDic = (NSDictionary *)state.data;
             request.partnerId = weixinDic[@"partnerid"];
             request.prepayId = weixinDic[@"prepayid"];
             request.package = weixinDic[@"package"];
             request.nonceStr = weixinDic[@"noncestr"];
             request.timeStamp = [weixinDic[@"timestamp"] intValue];
             request.sign = weixinDic[@"sign"];
             [WXApi sendReq:request];


         }break;
         case PayTypeLooseChange:{
             
             //零钱支付
             
             [self payResult:state.isSuccess];

         }break;
         }
        }
    }];
    
}

- (IBAction)aginDownOrderClick:(id)sender
{
    ObjectTableViewController *vc = ViewController(@"AppointmentSB", @"AppointmentViewController");
    vc.model = _orderModel.inviteAppUserId;
    
    PushViewController(vc);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
