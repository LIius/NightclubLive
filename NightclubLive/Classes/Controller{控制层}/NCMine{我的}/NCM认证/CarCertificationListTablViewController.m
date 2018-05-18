//
//  CarCertificationListTablViewController.m
//  NightclubLive
//
//  我车辆认证列表
//  Created by RDP on 2017/5/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "CarCertificationListTablViewController.h"
#import "GlobalRequest.h"
#import "AuthModel.h"
#import "CarCertificationCell.h"

@interface CarCertificationListTablViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBtn;

@end

@implementation CarCertificationListTablViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isHead = YES;
    self.tableView.rowHeight = 145;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self refreshMethod];
}

- (void)refreshMethod
{
    @weakify(self);

    GetCarRequest *r = [GetCarRequest new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([UserInfo shareUser].userID.length >0)
    {
        [params setValue:[UserInfo shareUser].userID forKey:@"userId"];
    }
    r.param = params;
    //r.param = @{@"userId":[UserInfo shareUser].userID};
    [r startRequestWithCompleted:^(ResponseState *state)
     {
         @strongify(self);
 
        self.parses = [CarAuthModel arrayObjectWithDS:state.datas];

        if (self.dataSource.count >= 3)
        {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DLog(@"%@",self.dataSource);
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarCertificationCell *cell = [tableView dequeueReusableCellWithIdentifier:CarCertificationCellReuseID];
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

#pragma mark - 添加认证
- (IBAction)addClick:(id)sender
{
     CarCertificationListTablViewController *vc =  ViewController(@"CarCertificationSB", @"CarCertificationViewController");
    PushViewController(vc);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
