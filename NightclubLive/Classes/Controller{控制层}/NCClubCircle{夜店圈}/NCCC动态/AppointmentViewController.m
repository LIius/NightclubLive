//
//  AppointmentViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/5/27.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AppointmentViewController.h"
#import "UITextView+WZB.h"
#import "UITextField+Utilities.h"
#import "MineRequest.h"
#import "MineModelList.h"
#import "UINavigationBar+Awesome.h"
#import "RDPDataPickView.h"


#import "MineRequest.h"
#import "MineModelList.h"

#import "MyBillDetailTableViewController.h"
#import "ChooseSeatViewController.h"
#import "PackageListViewController.h"


#import "NSDate+Utilities.h"

//#import "UINavigationController+FDFullscreenPopGesture.h"

@interface AppointmentViewController ()
<
UITextViewDelegate
>
{
    // 下单封装模型
    DownOrderModel *orderModel;
}

@property (weak, nonatomic) IBOutlet UIImageView *backIV; // 头部背景图
@property (weak, nonatomic) IBOutlet UIImageView *logoIV; // 酒吧头像标识

@property (weak, nonatomic) IBOutlet UITextField *barNameTF;
@property (weak, nonatomic) IBOutlet UITextField *timeTF;
@property (weak, nonatomic) IBOutlet UITextField *packTypeTF;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITableViewCell *selectTVC;
@property (weak, nonatomic) IBOutlet UITextView *messageTV;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITextField *seatTF;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBItem;
@property (weak, nonatomic) IBOutlet UITextField *personTF;
@property (weak, nonatomic) IBOutlet UIButton *bataiBtn;
@property (weak, nonatomic) IBOutlet UIButton *kazhuoBtn;
@property (weak, nonatomic) IBOutlet UIButton *baoxiangBtN;

/** 选择的酒吧项 */
@property (nonatomic, assign) NSInteger selectBarIndex;
/** 座位类型 */
@property (nonatomic, assign) NSInteger seatType;
/** 数据选择器 */
@property (nonatomic, strong) RDPDataPickView *pc;
/** 选择的酒吧 */
@property (nonatomic, weak) BarBindModel *selectBar;
/** 时间类型  0-在场 1-预约 */
@property (nonatomic, assign) NSInteger timeType;
/** 目标对象 */
@property (nonatomic, copy) NSString *model;
/** 绑定酒吧列表 */
@property (nonatomic, strong) NSArray *bindBarList;
/** 套餐列表 */
@property (nonatomic, strong) NSArray *packageList;

@end

@implementation AppointmentViewController

@dynamic model;

- (void)viewDidLoad
{
    [super viewDidLoad];

    adjustsScrollViewInsets_NO(self.tableView,self);
    
     self.backIV.image = [UIImage picturePlaceholder];
  
    [self setupViewDidload];
    
    [self setupBarRequest];

    // 选择吧台
    [self seatTypeClick:_bataiBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Table DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3)
        return 10;
    
    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return TABLE_HEAD_FOOT_SPACE;
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        if (self.tag == 1)
            return 0;
    }
    
    if (indexPath.section == 3)
        return 88;
    
    if (indexPath.section == 1 && indexPath.row == 2)
        return 60;
    
    return 44;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section >= 2)
    {
        return;
    }
    
    if (indexPath.row == 0 && indexPath.section == 0 )
    {
        // 选择酒吧
        [self goChooseBar:indexPath];
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            // 选择时间
            [self goChooseTime:indexPath];
        }
        else if (indexPath.row == 1)
        {
            // 选择座位（跳转页面）
            [self goChooseSeat];
        }
        else if (indexPath.row == 2)
        {
            // 选择套餐 (跳转页面)
            [self goChooseMenu];
        }
    }
}

- (IBAction)pop:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupViewDidload
{
    // 配置一些颜色之类
    _messageTV.placeholder = @"请填写备注信息";
    UIColor *pleceholder = RGBCOLOR(51, 51, 51);
    _barNameTF.placeholderColor = pleceholder;
    _timeTF.placeholderColor = pleceholder;
    _personTF.placeholderColor = pleceholder;
    _packTypeTF.placeholderColor = pleceholder;
    _phoneTF.placeholderColor = pleceholder;
    _nameTF.placeholderColor = pleceholder;
    _seatTF.placeholderColor = pleceholder;
}

#pragma mark - 请求酒吧列表
- (void)setupBarRequest
{
    orderModel = [DownOrderModel new];
    
    ShowLoading
    if (self.tag == 0)
    {
        // 获取已经绑定酒吧列表
        [CurrentUser getYWBToken:^(id param)
         {
             GetMyBarListRequest *r = [GetMyBarListRequest new];
             NSMutableDictionary *params = [NSMutableDictionary dictionary];
             if (param) {
                 [params setValue:param forKey:@"token"];
             }
             if (self.model) {
                 [params setValue:self.model forKey:@"user.appUserId"];
             }
             r.param = params;
             //r.param = @{@"user.appUserId":self.model,@"token":param};
             [r startRequestWithCompleted:^(ResponseState *state){
                 CloseLoading
                 // 处理请求信息
                 [self handelResponse:state];
             }];
         }];
        
    }
    else{
        
        CloseLoading
        _selectTVC.height = 0;
        self.selectBarIndex = 0;
    }
}

- (void)handelResponse:(ResponseState *)state
{
    _bindBarList = [BarModel arrayObjectWithDS:state.data];
    if (self.bindBarID){
        
        NSInteger selectIndex = -1;
        for (NSInteger i = 0 ; i < _bindBarList.count ; i ++){
            BarModel *b = _bindBarList[i];
            if ([b.ID isEqualToString:self.bindBarID]){
                selectIndex = i;
            }
        }
        
        if (selectIndex == -1){
            self.selectBarIndex = 0;
        }
        else{
            self.selectBarIndex = selectIndex;
        }
        
    }
    else{
        self.selectBarIndex = 0;
    }
}

#pragma mark - 选择座位
- (void)goChooseSeat
{
    if (_timeTF.text.length == 0){
        ShowError(@"请先选择时间");
        return;
    }
    
    ChooseSeatViewController *vc = [ChooseSeatViewController initSBWithSBName:@"ChooseSeatSB"];
    vc.model = _selectBar.ID;
    vc.tag = orderModel.bookType;
    vc.selectDate = orderModel.date;
    vc.calkBlock = ^(NSString *name) {
        _seatTF.text = name;
        orderModel.tableNo = name;
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 选择套餐
- (void)goChooseMenu
{
    PackageListViewController *vc = [PackageListViewController initSBWithSBName:@"PackageListSB"];
    vc.model = _selectBar.ID;
    vc.calkBlock = ^(BarPackageModel *packageModel)
    {
        _packTypeTF.text = packageModel.name;
        _priceLabel.text = packageModel.price;
        orderModel.packgeModel = packageModel;
        //改变颜色
        _priceLabel.textColor = RGBCOLOR(205, 79, 161);
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 选择时间
- (void)goChooseTime:(NSIndexPath *)indexPath
{
    RDPDataPickView *pc = [[RDPDataPickView alloc] initWithStyle:PickStyleData];
    pc.title = @"时间选择";
    NSArray *arr = @[@"已在现场",@"预约"];
    pc.dataSource = arr;
    pc.CompleteBlock = ^(NSInteger component, NSInteger row)
    {
        [self finishChooseWithComponent:component indexPath:indexPath datasource:arr];
    };
    [pc show];
}

#pragma mark - 酒吧选择
- (void)goChooseBar:(NSIndexPath *)indexPath
{
    RDPDataPickView *pc = [[RDPDataPickView alloc] initWithStyle:PickStyleData];
    NSMutableArray *arr = [NSMutableArray array];
    for (BarBindModel *m in _bindBarList){
        [arr addObject:m.name];
    };
    pc.title = @"酒吧选择";
    pc.dataSource = arr;
    pc.CompleteBlock = ^(NSInteger component, NSInteger row)
    {
        [self finishChooseWithComponent:component indexPath:indexPath datasource:arr];
    };
    [pc show];
}

#pragma mark - 完成选择
- (void)finishChooseWithComponent:(NSInteger )component
                        indexPath:(NSIndexPath *)indexPath
                       datasource:(NSArray *)array
{
    if (indexPath.row == 0 && indexPath.section == 0 )
    {
        // 选择酒吧
        self.selectBarIndex = component;
    }
    else if (indexPath.section == 1)
    {
        // 时间选择
        orderModel.bookType = component;
        if (component == 0)
        {
            _timeTF.text = array[component];
        }
        else{
            
            // 获取时间
            NSDate *nowDate = [[NSDate date] iosConvertLocationTime];
            NSMutableArray *dates = [[NSMutableArray alloc] init];
            NSMutableArray *dateStrs = [[NSMutableArray alloc] init];
            
            for (NSInteger i = 0 ; i <= 7 ; i ++)
            {
                NSDate *newDate = [nowDate aimDay:i];
                [dates addObject:newDate];
                [dateStrs addObject:newDate.HMChinaString];
            }
            
            NSArray *pcdates = @[dateStrs,orderModel.barModel.dobusinessArray];
            RDPDataPickView *datePC = [[RDPDataPickView alloc] initWithStyle:PickStyleData];
            datePC.style = PickStyleData;
            datePC.datas = pcdates;
            datePC.dataSource =nil;
            datePC.autoAdjustIndex = NO;
            [datePC show];
            datePC.CompleteBlock = ^(NSInteger component, NSInteger row)
            {
                NSString *day = pcdates[0][component];
                NSString *time = pcdates[1][row];
                
                _timeTF.text = [NSString stringWithFormat:@"%@ %@",day,time];
                
                NSDate *date = dates[component];
                NSString *newDateStr = date.YMDHMSStirng;
                NSArray *newDateStrArray = [newDateStr componentsSeparatedByString:@" "];
                NSString *newDateStr2 = [NSString stringWithFormat:@"%@ %@",[newDateStrArray firstObject],time];
                NSDate *date2 = [newDateStr2 stringConvertDateWithFormat:@"yyyy-MM-dd HH:mm"];
                orderModel.date = date2;
                
                DLog(@"%@,%@",day,time);
            };
        }
    }
}

#pragma mark - Set
- (void)setSelectBarIndex:(NSInteger)selectBarIndex
{
    _selectBarIndex = selectBarIndex;
    
    if (self.bindBarList.count <= selectBarIndex)
        return;
    
    BarBindModel *m = self.bindBarList[selectBarIndex];
    orderModel.barModel = m;
    [_logoIV sd_setImageWithURL:m.image placeholderImage:[UIImage picturePlaceholder]];
    _addressLabel.text  = m.address;
    _distanceLabel.text = m.distance;
    _phoneLabel.text = m.tel;
    [_backIV sd_setImageWithURL:m.image placeholderImage:[UIImage picturePlaceholder]];
    _barNameTF.text = m.name;
    _selectBar = m;
    
    // 清除目前所选的酒吧
    _timeTF.text = nil;
    _seatTF.text = nil;
    _packTypeTF.text = nil;
    _priceLabel.text = @"确定消费价格";
}

- (void)setBar:(BarModel *)bar
{
    _bindBarList = @[bar];
    self.selectBarIndex = 0;
}

#pragma mark - Text View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIColor * color = NavDefaultColor;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 64) {
        CGFloat alpha = MIN(1, 1 - ((64 + 64 - offsetY) / 64));
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
    } else {
        [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:0]];
    }
}

#pragma mark - Button Click
- (IBAction)seatTypeClick:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    _seatType = sender.tag;
    orderModel.reatType = _seatType;
    UIButton *selectBtn;
    UIButton *otherBtn1;
    UIButton *otherBtn2;
    NSInteger tag = sender.tag;
    if (tag == 0){
        selectBtn = sender;
        otherBtn1 = _kazhuoBtn;
        otherBtn2 = _baoxiangBtN;
    }
    else if (tag == 1){
        selectBtn = sender;
        otherBtn1 = _bataiBtn;
        otherBtn2 = _baoxiangBtN;
    }
    else{
        selectBtn = sender;
        otherBtn1 = _bataiBtn;
        otherBtn2 = _kazhuoBtn;
    }
    
    [selectBtn setImage:KGetImage(@"icon_checkwhite") forState:UIControlStateNormal];
    [selectBtn setBackgroundColor:APPDefaultColor];
    selectBtn.layer.borderColor = [UIColor clearColor].CGColor;
    [selectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [otherBtn1 setImage:nil forState:UIControlStateNormal];
    [otherBtn1 setBackgroundColor:[UIColor whiteColor]];
    [otherBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [otherBtn1 setBorderColor:[UIColor lightGrayColor] borderWidth:0.5];
    
    [otherBtn2 setImage:nil forState:UIControlStateNormal];
    [otherBtn2 setBackgroundColor:[UIColor whiteColor]];
    [otherBtn2 setBorderColor:[UIColor lightGrayColor] borderWidth:0.5];
    [otherBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (IBAction)okClick:(id)sender
{
    //检查数据
    [self.view endEditing:YES];
    
    NSString *error = nil;
    
    //检查到场时间
    
    if (_timeTF.text.length == 0){
        error = @"请选择到场时间";
    }
    else if (_packTypeTF.text.length == 0){
        error = @"请选择套餐";
    }
    else if (_nameTF.text.length == 0){
        error = @"请输入姓名";
    }
    else if (_phoneTF.text.length == 0){
        error = @"请输入手机号码";
    }
    else if (_messageTV.text.length > 0){
        if (_messageTV.text.length > 50)
            error = @"备注信息不能超过50个字";
    }
    
    if (error){
        ShowError(error);
        return;
    }
    
    // 下单请求
    [self setupSubmitOrderRequest];
}

- (void)setupSubmitOrderRequest
{
    orderModel.phone = _phoneTF.text;
    orderModel.name = _nameTF.text;
    orderModel.remark = _messageTV.text;
    
    ShowLoading;
    [CurrentUser getYWBToken:^(id param)
     {
         DownOrderRequest *r = [DownOrderRequest new];
         NSMutableDictionary *params = [NSMutableDictionary dictionary];
         if (param) {
             [params setValue:param forKey:@"token"];
         }
         if (orderModel.barModel.ID.length > 0) {
             [params setValue:orderModel.barModel.ID forKey:@"merchant.id"];
         }
         if (orderModel.name.length > 0) {
             [params setValue:orderModel.name forKey:@"contactName"];
         }
         
         [params setValue:@(2) forKey:@"orderSource"];
         
         if (orderModel.phone.length > 0) {
             [params setValue:orderModel.phone forKey:@"contactMobile"];
         }
         
         
         {
             NSMutableDictionary *paramDic = [NSMutableDictionary new];
             [paramDic setValue:@"combo" forKey:@"orderType"];
             [paramDic setValue:orderModel.tableNo forKey:@"tableNo"];
             [paramDic setValue:@"4" forKey:@"mealNumber"];
             [paramDic setValue:@[@{@"id":orderModel.packgeModel.ID,@"number":@(1)}] forKey:@"items"];
             [paramDic setValue:@(orderModel.bookType) forKey:@"bookType"];
             
             if (orderModel.remark){
                 [paramDic setValue:orderModel.remark forKey:@"remarks"];
             }
             if (paramDic.mj_JSONString) {
                 [params setValue:paramDic.mj_JSONString forKey:@"body"];
             }
         }
         
         
         //NSMutableDictionary *rDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"token":param,@"merchant.id":orderModel.barModel.ID,@"contactName":orderModel.name,@"orderSource":@(2),@"contactMobile":orderModel.phone,@"body":paramDic.JSONString,@"orderSource":@(2)}];
         
         if (self.tag == 0)
         {
             if (self.model)
             {
                 [params setValue:self.model forKey:@"inviteAppUserId"];
             }
         }
         
         if (orderModel.bookType == 1)
         {
             if (orderModel.date.YMDHMSStirng)
             {
                 [params setValue:orderModel.date.YMDHMSStirng forKey:@"arrivalTime"];
             }
         }
         
         r.param = params;
         //
         //        r.param = @{@"token":param,@"merchant.id":orderModel.barModel.ID,@"arrivalTime":orderModel.date.YMDHMSStirng,@"contactName":orderModel.name,@"contactMobile":orderModel.phone,@"body":paramDic.JSONString,@"inviteAppUserId":self.model};
         [r startRequestWithCompleted:^(ResponseState *state)
          {
              CloseLoading
              
              if (state.isSuccess)
              {
                  MyBillDetailTableViewController  *vc = [MyBillDetailTableViewController initSBWithSBName:@"MyBillDetailSB"];
                  vc.model = orderModel;
                  
                  if ([state.data isKindOfClass:[NSDictionary class]])
                  {
                      vc.orderID = [((NSDictionary *)state.data) stringForKey:@"id"];
                  }
                  PushViewController(vc);
              }
              else{
                  ShowError(state.message);
              }
          }];
         
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
