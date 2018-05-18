//
//  CarCertificationViewController.m
//  NightclubLive
//
//  Created by SuperDanny on 2016/12/14.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "CarCertificationViewController.h"
#import "QiNiuSystemService.h"
#import "GlobalModel.h"
#import "GlobalRequest.h"
#import "DDCustomPickerView.h"
#import "UIAlertController+Factory.h"
#import "QiniuTool.h"
#import "BlocksKit+UIKit.h"
#import "NCAlert.h"
@interface CarCertificationViewController ()

@property (weak, nonatomic) IBOutlet UIButton *cardBtn;
@property (weak, nonatomic) IBOutlet UILabel *carTypeLabel;

@property (nonatomic, assign) NSInteger selectRow;
@property (nonatomic, strong) UIImage *carImage;
@property (nonatomic, strong) NSArray *cars; /** 车辆数组 */

@end

@implementation CarCertificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _selectRow = -1;
    
    [self setupCarData];
}

- (void)setupCarData
{
    @weakify(self);
    //获取车辆信息
    [CarRequest startRequestWithCompleted:^(ResponseState *state)
     {
         @strongify(self);
         self.cars = [CarModel arrayObjectWithDS:state.data];
     }];
}

#pragma mark - 提交
- (IBAction)commitAction:(id)sender
{
    if (!self.carImage){
        ShowError(@"证件照不能为空");
        return;
    }
    else if (_selectRow == -1){
        ShowError(@"选择车辆信息");
        return;
    }
    
    ShowLoading;
    
    QiniuTool *tool = [QiniuTool shareTool];
    
    @weakify(self);
    [tool uploadImages:@[self.carImage] type:UploadTypeSpaceTypeAuth success:^(id value) {
        
        // 图片上传完毕上传到NC
        CarModel *m = self.cars[self.selectRow];
        AuthPushCarRequest *r = [AuthPushCarRequest new];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if ([UserInfo shareUser].userID.length >0) {
            [params setValue:[UserInfo shareUser].userID forKey:@"userId"];
        }
        if (m.ID.length > 0) {
            [params setValue:m.ID forKey:@"carBrand"];
        }
        if (value[0]) {
            [params setValue:value[0] forKey:@"license"];
        }
        r.param = params;
        //r.param = @{@"userId":[UserInfo shareUser].userID,@"carBrand":m.ID,@"license":value[0]};
        
        [r startRequestWithCompleted:^(ResponseState *state) {
            @strongify(self);
            if (state.isSuccess)
            {
                [UserInfo shareUser].user.vehicle_certification = YES;
                [self.navigationController popViewControllerAnimated:YES];
                
                ShowSuccess(@"车辆认证资料已提交，请等待审核");
            }
            else{
                ShowError(state.message);
            }
            
            CloseLoading
        }];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Button click
- (IBAction)carImageClick:(id)sender
{
    @weakify(self);
    [NCAlert showActionSheetWithDataSource:@[@"图库",@"相机"] blockHandel:^(NSInteger index) {
        @strongify(self);
        if (index == 0 || index == 1)
        {
            UIImagePickerController *pc = [UIImagePickerController new];
            
            [pc setBk_didFinishPickingMediaBlock:^(UIImagePickerController *vc, NSDictionary *param) {
                
                [_cardBtn setImage:param[UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
                self.carImage = param[UIImagePickerControllerOriginalImage];
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            
            pc.sourceType = index;
            
            [self presentViewController:pc animated:YES completion:nil];
        }
    }];

}

- (IBAction)selectCarClick:(id)sender
{
    @weakify(self);
    
    NSMutableArray *tempArr = [NSMutableArray array];
    
    for (CarModel *m in self.cars){
        [tempArr addObject:m.car_name];
    }
    
    DDCustomPickerView *pk = [[DDCustomPickerView alloc] initWithStyle:DDPickerStyle_1];
    pk.titleLabel.text = @"车辆选择";
    
    [pk setNumberOfRowsBlock:^NSUInteger(NSInteger component) {
        return tempArr.count;
    }];
    
    [pk setTitleForRowBlock:^NSString *(NSInteger row, NSInteger component) {
        if (row < tempArr.count) {
            return tempArr[row];
        }
        return @"";
    }];
    
    [pk setSelectBlock:^(NSInteger row, NSInteger component) {
//        if (row < tempArr.count) {
//            professionStr = tempArr[row];
//        }
//        weakSelf.selectJobIndex = row;
        @strongify(self);
        self.selectRow = row;
        self.carTypeLabel.text = tempArr[row];
    }];
    
    [pk setChooseBlock:^{
       // [weakSelf.professionBtn setTitle:professionStr forState:UIControlStateNormal];
    }];
    
    [pk showInView:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
