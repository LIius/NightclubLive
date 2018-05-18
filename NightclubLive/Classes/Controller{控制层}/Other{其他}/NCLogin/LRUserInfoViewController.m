//
//  LRUserInfoViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/3/28.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "LRUserInfoViewController.h"
#import "RDPDataPickView.h"

#import "UIAlertController+Factory.h"
#import "RLLRequest.h"
#import "QiniuTool.h"
#import "NSDate+Utilities.h"
#import "RLJobCollectionViewCell.h"
#import "GlobalModel.h"
#import "GlobalRequest.h"
#include "math.h"
#import "GYZChooseCityController.h"
#import "BlocksKit+UIKit.h"
#import "NCAlert.h"
static CGFloat JobHeight = 27;

@interface LRUserInfoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,GYZChooseCityDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *ciytTF;
@property (weak, nonatomic) IBOutlet UIButton *logoBtn;
@property (weak, nonatomic) IBOutlet UITextField *sexTF;
@property (weak, nonatomic) IBOutlet UITextField *birthdayTF;
@property (weak, nonatomic) IBOutlet UITextField *roleTF;
@property (weak, nonatomic) IBOutlet UIButton *sexWomanBtn;
@property (weak, nonatomic) IBOutlet UIButton *sexManBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *jobCollectionView;
@property (weak, nonatomic) IBOutlet UIView *jobSuperView;

/** 选取的头像 */
@property (nonatomic, strong) UIImage *logoImage;
/** 用户昵称 */
@property (nonatomic, copy) NSString *name;
/** 性别 */
@property (nonatomic, assign) NSInteger sex;
/** 生日 */
@property (nonatomic, copy) NSString *birthdy;
/** 生日Date 用户转换*/
@property (nonatomic, strong) NSDate *birthdyDate;
/** 角色 */
@property (nonatomic, assign) NSInteger role;
/** 职业列表 */
@property (nonatomic, strong) NSArray *jobs;

@end

@implementation LRUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _sex = -1;
    _role = -1;
    _logoBtn.layer.cornerRadius = 36;
    _logoBtn.imageView.layer.cornerRadius = 36;
    
    _sexManBtn.selected = YES;
    
    [_sexManBtn setImage:KGetImage(@"icon_menon") forState:UIControlStateNormal];
    [_sexManBtn setImage:KGetImage(@"icon_men") forState:UIControlStateSelected];
    
    [_sexWomanBtn setImage:KGetImage(@"icon_womenon") forState:UIControlStateNormal];
    [_sexWomanBtn setImage:KGetImage(@"icon_women")  forState:UIControlStateSelected];
    
    // 获取职业列表
    ShowLoading;
    JobRequest *jobr = [JobRequest new];
    [jobr startRequestWithCompleted:^(ResponseState *state) {
        
        self.jobs = [JobModel arrayObjectWithDS:state.data];
        
        [self.jobCollectionView reloadDataInMain];
        
        //计算背景view高度
        [self.jobSuperView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            CGFloat result = ceil(self.jobs.count / 3.0 );
            make.height.mas_equalTo(result * 30 + 70);
        }];
        CloseLoading;
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    CloseLoading;

}

#pragma mark - Gest Action

- (IBAction)showData:(UITapGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
    
    NSInteger tag = sender.view.tag;
    
    RDPDataPickView *pickView;

    if (tag == 1){
        
        pickView = [[RDPDataPickView alloc] initWithStyle:PickStyleDate];
        
        pickView.maxDate = [NSDate date];
        
        pickView.DateCompleteBlock = ^(NSDate *date){
            
            _birthdyDate = date;

            NSTimeZone *timeZone=[NSTimeZone systemTimeZone];
            NSInteger seconds=[timeZone secondsFromGMTForDate:date];
            NSDate *newDate=[date dateByAddingTimeInterval:seconds];
            NSString *brithdayStr = newDate.YMDString;
            _birthdayTF.text = brithdayStr;
            _birthdy = _birthdayTF.text;
        };
        
    }else{
        
        NSString *title = nil;
        NSString *key   = nil;
        NSArray *datas = nil;
        if (tag == 0){
            key = @"Sex";
            title = @"性别选择";
        }
        else{
            key = @"Role";
            title = @"角色选择";
        }
        
        pickView = [[RDPDataPickView alloc] initWithStyle:PickStyleData];
        
        datas = SelectDataForKey(key);

        pickView.title = title;
        
        pickView.dataSource = datas;
        
        pickView.CompleteBlock = ^(NSInteger r , NSInteger c){
            
            if (tag == 0){
                _sexTF.text = datas[r];
                _sex = r;
            }
            else{
                _roleTF.text = datas[r];
                _role = r;
            }
        };
    }
    
    [pickView show];

}

#pragma mark - Button Click

- (IBAction)submitClick:(id)sender
{
    if (_sexManBtn.isSelected)
        _sex = 0;
    else
        _sex = 1;
    
    //获取职业
    __block NSInteger jobSelectIndex =  -1;

    [_jobCollectionView.visibleCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        
        if (obj.selected){
            jobSelectIndex = idx;
        }
    }];
    
    

    _name = _nameTF.text;
    
    NSString *error;

    if (!_logoImage)
        error = @"请选择头像";
    else if (_name.length <= 0)
        error = @"请填写昵称";
    else if (_sex == -1)
        error = @"请选择性别";
    else if (_birthdy.length <= 0)
        error = @"选取出生日期";
    else if (_ciytTF.text.length <= 0)
        error = @"请选取城市";
    else if (jobSelectIndex == -1)
        error = @"请选择职业";
    else
        error = nil;
    
    if (error){
        
        ShowError(error);
        return;
    }
    else{
        
        ShowLoading
        
        //上传头像
        QiniuTool *tool = [QiniuTool new];
        [tool uploadImages:@[_logoImage] type:UploadTypeSpaceTypeAuth success:^(id value) {
            
            //进行网络请求
            SignInRequest *r = [SignInRequest new];
            
            //获取岁数
            NSInteger age = [NSDate date].year - _birthdyDate.year;
            JobModel *jobModel = _jobs[jobSelectIndex];

            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if (self.name.length >0) {
                [params setValue:self.name forKey:@"userName"];
            }
            if (_ciytTF.text.length > 0) {
                [params setValue:_ciytTF.text forKey:@"city"];
            }
            if (self.paw.length > 0) {
                [params setValue:self.paw forKey:@"passWord"];
            }
            if (self.phone.length > 0) {
                [params setValue:self.phone forKey:@"phoneNum"];
            }
            if (self.sex) {
                [params setValue:@(self.sex) forKey:@"sex"];
            }
            if ([value firstObject]) {
                [params setValue:[value firstObject] forKey:@"profilePhoto"];
            }
            if (jobModel.ID.length >0) {
                [params setValue:jobModel.ID forKey:@"appUserRole"];
            }
            if (self.authCode.length >0) {
                [params setValue:self.authCode forKey:@"verifyCode"];
            }
            if (self.birthdy.length >0) {
                [params setValue:self.birthdy forKey:@"birth_day"];
            }
            
            if (jobModel.ID.length >0) {
                [params setValue:jobModel.ID forKey:@"occupation"];
            }
            
            if (age) {
                [params setValue:@(age) forKey:@"age"];
            }
  
            if (self.invitationCode.length > 1)
            {
                [params setValue:self.invitationCode forKey:@"invitationCode"];
            }
            
            r.param = [params copy];
            
            [r startRequestWithCompleted:^(ResponseState *state) {
                
                CloseLoading
                
                if (state.isSuccess){

                    //进行登录
                    ShowLoading
                    [UserInfo shareUser].lgPaw =  self.paw;
                    [UserInfo shareUser].lgPhone = self.phone;
                    [[UserInfo shareUser] loginWithCompletion:^(ResponseState *state) {
                        
                        CloseLoading
                        if (state.isSuccess){
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                    }];

                }
                else{
                    [SharedAppDelegate.window makeToast:state.message duration:2.0 position:CSToastPositionCenter];
                }
            }];

        } failure:^(NSError *error) {
        }];

    }
}

- (IBAction)logoClick:(id)sender
{
    
    @weakify(self);
    [NCAlert showActionSheetWithDataSource:@[@"相册",@"相机"] blockHandel:^(NSInteger index) {
        if (index == 0 || index == 1)
        {
            @strongify(self);
            UIImagePickerController *pick = [[UIImagePickerController alloc] init];
            kWeakSelf(pick);
            pick.sourceType = index;
            [pick setBk_didFinishPickingMediaBlock:^(UIImagePickerController *pickVC, NSDictionary *param)
             {
                 @strongify(self);
                 [self.logoBtn setImage:param[UIImagePickerControllerOriginalImage] forState:UIControlStateNormal];
                 self.logoImage = param[UIImagePickerControllerOriginalImage];
                 
                 [weakpick dismissViewControllerAnimated:YES completion:nil];
             }];
            
            [self presentViewController:pick animated:YES completion:nil];
        }
    }];

}

- (IBAction)sexClick:(UIButton *)sender {

    sender.selected = YES;
    
    UIButton *btn;
    btn = [self.view viewWithTag:sender.tag == 50 ? 51 : 50];
    
    btn.selected = NO;
    
    
}

- (IBAction)cityClick:(id)sender {
    
    GYZChooseCityController *cityVC = [[GYZChooseCityController alloc] init];
    
    cityVC.delegate  = self;
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityVC] animated:YES completion:nil];
}


- (IBAction)backClick:(id)sender {
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.jobs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    RLJobCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RLJobCollectionViewCellReuseID forIndexPath:indexPath];
    
    cell.model = _jobs[indexPath.row];
    
    cell.indexPath = indexPath;
    
    return cell;
}

- (CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.view.width * 0.25, JobHeight);
}



- (IBAction)cityTF:(id)sender {
}


#pragma mark - GYChooseCityDelegate

- (void)cityPickerController:(GYZChooseCityController *)chooseCityController
               didSelectCity:(GYZCity *)city{
    
    [chooseCityController dismissViewControllerAnimated:YES completion:nil];
    
    _ciytTF.text = city.cityName;

}

@end
