//
//  SearchBarViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "SearchBarViewController.h"
#import "BarListCell.h"
#import "BarInfoViewController.h"
#import "HMSegmentedControl.h"
#import "MineRequest.h"
#import "MineModelList.h"

@interface SearchBarViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet HMSegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSString *searchKey;

@end

@implementation SearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    @weakify(self);
    
    _segmentedControl.sectionTitles = @[@"人气",@"附近"];
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    _segmentedControl.selectedSegmentIndex = 0;//HMSegmentedControlNoSegment;
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionIndicatorHeight = 2;
    _segmentedControl.selectionIndicatorColor = APPDefaultColor;
    _segmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    _segmentedControl.indexChangeBlock = ^(NSInteger changeIndex){
        @strongify(self);
        self.pageNow = 0;
        [self.dataSource removeAllObjects];
        [self.tableView reloadInMain];
        [self requestBegin];
    };
    
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    
    
    self.refreshView = self.tableView;
    self.isHead = YES;
    self.isFoot = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request

- (void)refreshMethod{
    
    GetBarListRequest *r = [[GetBarListRequest alloc] init];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];

    if (self.pageNow) {
        [param setValue:@(self.pageNow) forKey:@"page"];
    }
    
    if (CurrentUser.location.lclatitude) {
         [param setValue:CurrentUser.location.lclatitude forKey:@"merchant.latitude"];
    }
   
    if (CurrentUser.location.lclongitude) {
        [param setValue:CurrentUser.location.lclongitude forKey:@"merchant.longitude"];
    }
    
    
    NSInteger currentIndex = _segmentedControl.selectedSegmentIndex;
    if (currentIndex == 1){//附近
        [param setValue:@"near" forKey:@"type"];
    }
    
    if (self.searchKey.length >= 1){
        [param setValue:_searchKey forKey:@"merchant.name"];
    }
    
    r.param = [param copy];
    [r startRequestWithCompleted:^(ResponseState *state) {
        
        self.parses = [BarModel arrayObjectWithDS:state.data];
        [self requestEnd];
    }];
}
#pragma mark - Table View Data 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BarListCell *cell = [tableView dequeueReusableCellWithIdentifier:BarListCellReuseID];
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return TABLE_HEAD_FOOT_SPACE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ObjectViewController *vc = ViewController(@"BarInfoSB", @"BarInfoViewController");
    vc.model = self.dataSource[indexPath.row];
    
    PushViewController(vc);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
}

#pragma mark - Search Bar

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self searchBarForName:searchBar.text];
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.text = nil;
    
    [self searchBarForName:searchBar.text];
}


- (void)searchBarForName:(NSString *)name{
    
    [self.view endEditing:YES];

    _searchKey = name;
    
    [self requestBegin];

}

#pragma mark - empty

- (NSAttributedString *)emptyString{
    
    return [[NSAttributedString alloc] initWithString:@"搜索不到你想要找的酒吧\n又可能您所属的酒吧还未入驻夜店网\n点击右上角的“邀请”\n吧夜店网分享到酒吧吧~"];
}


@end
