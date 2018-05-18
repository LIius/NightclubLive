
//
//  MyBindBarListViewController.m
//  NightclubLive
//
//  Created by rdp on 2017/5/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MyBindBarListViewController.h"
#import "MyBarListCell.h"
#import "MineRequest.h"
#import "MineModelList.h"
#import "SearchBarViewController.h"

@interface MyBindBarListViewController ()

@end

@implementation MyBindBarListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isHead = YES;
    MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)self.tableView.mj_header;
    header.stateLabel.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
    [self refreshMethod];
}

#pragma mark - Rquest

- (void)refreshMethod{
    
    [CurrentUser getYWBToken:^(id param) {
        
        GetMyBarListRequest *getR = [GetMyBarListRequest new];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if (param) {
            [params setValue:param forKey:@"token"];
        }
        if (CurrentUser.userID.length > 0) {
            [params setValue:CurrentUser.userID forKey:@"user.appUserId"];
        }
        getR.param = params;
        //getR.param = @{@"token":param,@"user.appUserId":CurrentUser.userID};
        [getR startRequestWithCompleted:^(ResponseState *state) {
            
            self.parses = [BarBindModel arrayObjectWithDS:state.data];

        }];
        
    }];
}

#pragma mark - Table View 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyBarListCell *cell = [tableView dequeueReusableCellWithIdentifier:MyBarListCellReuseID];
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 144;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ObjectViewController *vc = ViewController(@"BarBindSB", @"BarBindDetailsViewController");
    vc.model = self.dataSource[indexPath.row];
    PushViewController(vc);
}

#pragma mark - Button Click

- (IBAction)addBarClick:(id)sender {
    
    PushViewController(ViewController(@"SearchBarSB", @"SearchBarViewController"));
}

@end
