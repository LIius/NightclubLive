//
//  MyDataViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/18.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MyDataViewController.h"

#import "ImagePickTool.h"
#import "UserDetailRequest.h"
#import "MineRequest.h"
#import "GYZChooseCityController.h"
#import "RDPDataPickView.h"
#import "GlobalModel.h"
#import "GlobalRequest.h"


#import "NSDate+Utilities.h"
#import "UIAlertController+Factory.h"
#import "QiniuTool.h"
@interface MyDataViewController ()<GYZChooseCityDelegate>

@property (nonatomic, weak) User *model;
@property (nonatomic, strong) ImagePickTool *ac;
@property (nonatomic, strong) NSArray *jobs;
@property (nonatomic, strong) NSArray *jobStrings;

@end

@implementation MyDataViewController

@dynamic model;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupViewDidload];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        // 头像修改
        [self.ac showPickImageDataSelect:self assets:nil];
    }
    else if (indexPath.row == 1)
    {
        [self changeNickname];
    }else if (indexPath.row == 4)
    {
        [self changeCity];
    }
    else if (indexPath.row == 5 ||indexPath.row == 6)
    {
        [self changeBirthdayOrPersonState:indexPath];
    }
    else if (indexPath.row == 7)
    {
        [self changeIncome];
    }
    else if(indexPath.row == 8)
    {
        [self changeRole];
    }
}

#pragma mark - 初始化数据
- (void)setupViewDidload
{
    [_headIV sd_setImageWithURL:self.model.profile_photo placeholderImage:[UIImage userPlaceholder]];
    _nameLabel.text = self.model.user_name;
    _phoneLabel.text = self.model.phone_num;
    _cityLabel.text = self.model.city;
    
    _headIV.layer.cornerRadius = 27.7;
    _headIV.layer.masksToBounds = YES;
    
    [[JobRequest new] startRequestWithCompleted:^(ResponseState *state)
    {
        self.jobs = [JobModel arrayObjectWithDS:state.data];
    }];
    
    _brithdayLabel.text = self.model.birth_day.YMDChinaString;
    _constellationLabel.text = self.model.constellation;
    _emotionLabel.text = SelectDataForKey(@"Emotion")[[self.model.emotion integerValue]];
    _incomeLabel.text = [NSString stringWithFormat:@"%@",self.model.income.length > 0 || !(self.model.income == nil)? self.model.income : @""];
    _roleLabel.text = self.model.job_name;
    
    _sexLabel.text = [NSString stringFromeArray:@[@"女",@"男"] index:self.model.sex];
}

#pragma mark - 改变城市
- (void)changeCity
{
    GYZChooseCityController *cityVC = [[GYZChooseCityController alloc] init];
    cityVC.navigationItem.title = @"城市选择";
    cityVC.delegate = self;
    PresentViewController([[UINavigationController alloc] initWithRootViewController:cityVC]);
}

#pragma mark - 修改昵称
- (void)changeNickname
{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"昵称" okBlock:^(id param) {
        // 修改用户资料
        UpdateUserInfoRequest *r =  [UpdateUserInfoRequest new];
        r.name = param;
        [r startRequestWithCompleted:^(ResponseState *state) {
            
            if (state.isSuccess)
            {
                // 修改成功
                dispatch_async(dispatch_get_main_queue(), ^{
                    _nameLabel.text = param;
                    
                });
                
                self.model.user_name = param;
            }
        }];
        
    }];
    
    [self presentViewController:ac animated:YES completion:nil];
}

#pragma mark - 改变情感状态或者出生日期
- (void)changeBirthdayOrPersonState:(NSIndexPath *)indexPath
{
    RDPDataPickView *pickView  =  [[RDPDataPickView alloc] initWithStyle:indexPath.row == 5 ? PickStyleDate : PickStyleData];
    
    NSArray *array = SelectDataForKey(@"Emotion");
    pickView.title = indexPath.row == 6 ? @"情感" : @"出生日期";
    pickView.dataSource = array;
    
    pickView.DateCompleteBlock = ^(NSDate *date)
    {
        // 修改用户资料
        NSString *constellation = [NSString getAstroWithMonth:(int)date.month day:(int)date.day];
        UpdateUserInfoRequest *r = [[UpdateUserInfoRequest alloc] init];
        r.birthday = date;
        r.constellation = constellation;
        [r startRequestWithCompleted:^(ResponseState *state) {
            
            if (state.isSuccess)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    _brithdayLabel.text = [date YMDChinaString];
                });
                
                self.model.birth_day = date;
            }
            else
                ShowError(@"修改失败");
        }];
    };
    
    pickView.CompleteBlock = ^(NSInteger c,NSInteger r)
    {
        UpdateUserInfoRequest *request = [[UpdateUserInfoRequest alloc] init];
        request.emotion = c;
        [request startRequestWithCompleted:^(ResponseState *state) {
            
            if (state.isSuccess)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    _emotionLabel.text = array[c];
                });
                self.model.emotion =   array[c];
                
            }
        }];
    };
    
    [pickView show];
}

#pragma mark - 改变收入
- (void)changeIncome
{
    NSArray *incoms = SelectDataForKey(@"MyIncome");
    
    RDPDataPickView *pc = [[RDPDataPickView alloc] initWithStyle:PickStyleData];
    pc.dataSource = incoms;
    [pc show];
    pc.CompleteBlock = ^(NSInteger component, NSInteger row) {
        
        NSString *param = incoms[component];
        // 修改收入
        UpdateUserInfoRequest *r = [[UpdateUserInfoRequest alloc] init];
        r.income = param;
        [r startRequestWithCompleted:^(ResponseState *state) {
            
            if (state.isSuccess)
            {
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    _incomeLabel.text = [NSString stringWithFormat:@"%@",param];
                });
                
                self.model.income = param;
            }
        }];
    };
}

#pragma mark - 改变角色
- (void)changeRole
{
    RDPDataPickView *pick = [[RDPDataPickView alloc] initWithStyle:PickStyleData];
    pick.dataSource = self.jobStrings;
    pick.title = @"职业";
    pick.CompleteBlock = ^(NSInteger r ,NSInteger c){
        
        UpdateUserInfoRequest *request = [[UpdateUserInfoRequest alloc] init];
        JobModel *m = self.jobs[r];
        request.role = m.ID;
        [request startRequestWithCompleted:^(ResponseState *state) {
            
            if (state.isSuccess)
            {
                self.model.appUserRole = m.ID;
                self.model.appUserRole = m.ID;
                dispatch_async(dispatch_get_main_queue(), ^
                {
                    self.roleLabel.text = self.jobStrings[r];
                });
                
            }
            else
                ShowError(@"修改失败");
        }];
    };
    [pick show];
}

#pragma mark - GYZChooseCityDelegate
- (void)cityPickerController:(GYZChooseCityController *)chooseCityController didSelectCity:(GYZCity *)city
{
    [self dismissViewControllerAnimated:YES completion:nil];
    // 修改地区
    
    UpdateUserInfoRequest *r = [UpdateUserInfoRequest new];
    r.city = city.cityName;
    [r startRequestWithCompleted:^(ResponseState *state) {
        

        if (state.isSuccess)
        {
            self.model.city = city.cityName;
            dispatch_async(dispatch_get_main_queue(), ^{
                _cityLabel.text = city.cityName;
            });
            
        }
        else
            ShowSuccess(@"修改失败");
        
    }];
}

- (void)setJobs:(NSArray *)jobs
{
    _jobs = jobs;
    
    NSMutableArray *array = [NSMutableArray array];
    for (JobModel *m in jobs){
        [array addObject:m.name];
    }
    
    _jobStrings = [array copy];
}

#pragma mark - Getter
- (ImagePickTool *)ac
{
    if (!_ac)
    {
        ImagePickTool *ac = [ImagePickTool new];
        ac.edit = YES;
        ac.maxCount = 1;
        ac.finishAssetsAndImagesBlock = ^(NSArray *assets,NSArray *imgs)
        {
            MBProgressHUD *hud = [MBProgressHUD bwm_showHUDAddedTo:ShareWindow title:@"上传中"];
            @weakify(self);
            [[QiniuTool shareTool] uploadImages:imgs type:UploadTypeSpaceTypeAuth success:^(id value)
            {
                // 修改用户资料
                UpdateUserInfoRequest *r =  [UpdateUserInfoRequest new];
                r.headURL = [value firstObject];
                [r startRequestWithCompleted:^(ResponseState *state)
                 {
                    @strongify(self);
                    if (state.isSuccess)
                    {
                        // 修改成功
                        self.model.profile_photo = URL([value firstObject]);
                        dispatch_async(dispatch_get_main_queue(), ^
                        {
                            [self.headIV sd_setImageWithURL:URL([value firstObject]) placeholderImage:[UIImage userPlaceholder]];
                        });
                        
                    }
                    
                    [hud hide:YES];
                }];
                
            } failure:^(NSError *error)
             {
                [hud hide:YES];
            }];
            
        };
        
        _ac = ac;

    }
    return _ac;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
