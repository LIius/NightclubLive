//
//  ConditionSettingVC.m
//  NightclubLive
//
//  Created by WanBo on 16/12/1.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "ConditionSettingVC.h"
#import "UIAlertController+Factory.h"
#import "GYZChooseCityController.h"
#import "GlobalModel.h"
#import "GlobalRequest.h"
#import "NCAlert.h"

@interface ConditionSettingVC ()<GYZChooseCityDelegate>

@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *jobLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (nonatomic, strong) NSArray *jobs;
@property (nonatomic, weak) JobModel *selectJob;

@end

@implementation ConditionSettingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    [self setupRequest];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.calkBackBlock)
    {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        
        if (![self.sexLabel.text isEqualToString:@"性别"])
            [param setValue:self.sexLabel.text forKey:@"sex"];
        if (![self.jobLabel.text isEqualToString:@"职业"])
            [param setValue:self.selectJob.ID forKey:@"job"];
        if (![self.cityLabel.text isEqualToString:@"地区"])
            [param setValue:self.cityLabel.text forKey:@"city"];
        
        self.calkBackBlock([param copy]);
    }
}

#pragma mark - 获取职业信息
- (void)setupRequest
{
    [JobRequest startRequestWithCompleted:^(ResponseState *state) {
        
        self.jobs = [JobModel arrayObjectWithDS:state.data];
    }];
}

#pragma mark - Table View Data Source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TABLE_HEAD_FOOT_SPACE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *array = @[];
    if (indexPath.row == 0)
    {
        // 性别
        array = @[@"女",@"男"];
    }
    else if (indexPath.row == 1)
    {
        //职业
        NSMutableArray *jobs = [NSMutableArray array];
        for (JobModel *m in _jobs)
        {
            [jobs addObject:m.name];
        }
        
        array = [jobs copy];
    }
    else  if (indexPath.row == 2){
        // 地区
        GYZChooseCityController *cityVC = [[GYZChooseCityController alloc] init];
        
        cityVC.delegate  = self;
        
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:cityVC] animated:YES completion:nil];
        
        return;
    }
 
    if (array.count >0 )
    {
        [NCAlert showActionSheetWithDataSource:array blockHandel:^(NSInteger index) {

            NSString *str = [array stringAtIndex:index];

            if (indexPath.row == 0)
            {
                _sexLabel.text = str;
            }
            else{
                _jobLabel.text = str;
                _selectJob = [_jobs objectAtIndex:index];
            }
        }];

    }

}


#pragma mark - GYChooseCityDelegate
- (void)cityPickerController:(GYZChooseCityController *)chooseCityController
                didSelectCity:(GYZCity *)city
{
    [chooseCityController dismissViewControllerAnimated:YES completion:nil];
    _cityLabel.text = city.cityName;
}

@end
