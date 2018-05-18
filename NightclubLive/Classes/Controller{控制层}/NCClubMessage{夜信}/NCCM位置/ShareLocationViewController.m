//
//  ShareLocationViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/3/22.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ShareLocationViewController.h"
#import "NCAnnotation.h"
#import "ChatLocationNearbyCell.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>


NSInteger showRegion = 750;

@interface ShareLocationViewController ()<MAMapViewDelegate,UIScrollViewDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchLocationSB;
@property (weak, nonatomic) IBOutlet MKMapView *locationMV;
@property (weak, nonatomic) IBOutlet UITableView *locationTableView;
@property (nonatomic, assign) CLLocationCoordinate2D userLocation;
@property (nonatomic, assign) CLLocationCoordinate2D centerLocation;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (weak, nonatomic) IBOutlet UIView *mapBGView;
/** 地图界面 */
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) NCAnnotation *annotion;
/** 附近地点 */
@property (nonatomic, strong) NSMutableArray *nearbyAddress;
/** 搜索结果 */
@property (nonatomic, strong) NSArray *searchResults;

//高德
/** 用户当前定位 */
@property (nonatomic, strong) MAUserLocation *gdUserLocation;
/** 高德标志 */
@property (nonatomic, strong) MAPointAnnotation *gdAnnotaion;
/** 搜索类 */
@property (nonatomic, strong) AMapSearchAPI *search;
/** 搜索页数 */
@property (nonatomic, assign) NSInteger searchPage;
/** 当前位置地理反编码 */
@property (nonatomic, strong) AMapReGeocode *currentRG;

@end

@implementation ShareLocationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [AMapServices sharedServices].enableHTTPS = YES;
    [self.mapBGView addSubview:self.mapView];
    _searchPage = 1;
    _nearbyAddress = [NSMutableArray array];
    _searchResults = [NSMutableArray array];


    @weakify(self);
    //添加下拉加载更多
    MJRefreshAutoNormalFooter *foot = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^
    {
        @strongify(self);
        _searchPage += 1;
        [self getNearbyList];
    }];
    foot.refreshingTitleHidden = YES;
    [foot setTitle:@"" forState:MJRefreshStateIdle];
    self.locationTableView.mj_footer = foot;
    
    
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:KGetImage(@"icon_purplepbutton")]];
//    [rightBtn bk_t]
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 57.5, 24.5)];
    [rightBtn setImage:KGetImage(@"icon_purplepbutton") forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MapViewDelegate

//用户定位
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    self.gdUserLocation = userLocation;
    
   // self.centerLocation = userLocation.coordinate;
    
}

/** 地图发送改变 */
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    CLLocationCoordinate2D coordinate = mapView.centerCoordinate;
    
    if (!(coordinate.latitude == self.centerLocation.latitude && coordinate.longitude == self.centerLocation.longitude))
        self.centerLocation = coordinate;
}


#pragma mark - AMapSearchDelegate

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{

    if (response.pois){
        [_nearbyAddress addObjectsFromArray:response.pois];
        [_locationTableView reloadInMain];
    }
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    
    _currentRG = response.regeocode;
    self.currentLocationLabel.text = response.regeocode.formattedAddress;
}

- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response{
    
    if (response.tips.count > 0){
        
        _searchResults = response.tips;
        
//        //[_searchLocationSB
//        [_searchLocationSB.sear]
        [self.searchDisplayController.searchResultsTableView reloadInMain];
    }
}

#pragma mark - Search Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self searchAddressInKey:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self searchAddressInKey:searchBar.text];
}

- (void)searchAddressInKey:(NSString *)searchKey{
    
    AMapInputTipsSearchRequest *request = [[AMapInputTipsSearchRequest alloc] init];
    request.keywords = searchKey;
    request.city     = _currentRG.addressComponent.city;
    request.cityLimit = NO;
    [_search AMapInputTipsSearch:request];
    
  //  _searchResults = nil;
}

//
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
//    
//    self.userLocation = [userLocation coordinate];
//    [self showUserLocation];
//    
//    [self addAnnotaion:[userLocation coordinate] title:nil subtitle:nil];
//    
//    self.centerLocation = [userLocation coordinate];
//}
//
//
//- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
//    
//    //中心点
//    CLLocationCoordinate2D centerLC =  mapView.centerCoordinate;
//    
//    self.centerLocation = centerLC;
//    
//    [self addAnnotaion:centerLC title:nil subtitle:nil];
//    
//}
//
//- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views{
//}


#pragma mark - Touch 


#pragma mark - Button Click

- (IBAction)showUserLocationClick:(id)sender {
    
    [_mapView setRegion:MACoordinateRegionMakeWithDistance(_gdUserLocation.coordinate, showRegion, showRegion)
               animated:YES];
}

- (IBAction)cancelClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)sendClick:(id)sender {
    
    NSDictionary *locationDic = @{@"name":self.currentRG.formattedAddress,@"la":@(self.centerLocation.latitude),@"lo":@(self.centerLocation.longitude)};
    
    if (self.calkBlock)
        self.calkBlock(locationDic);
    
    [self dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark - Priavte Method

- (void)addAnnotaion:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle{
//    //添加大头针
//    if (!_annotion){
//        _annotion = [[NCAnnotation alloc] init];
//    }
//    else{
//        [_locationMV removeAnnotation:_annotion];
//    }
//    
//    _annotion.coordinate = coordinate;
//    _annotion.title = title;
//    _annotion.subtitle = subtitle;
//    [_locationMV addAnnotation:_annotion];
//    
  //  [_locationMV removeAnnotation:<#(nonnull id<MKAnnotation>)#>]
    
    if (!_gdAnnotaion){
        _gdAnnotaion = [[MAPointAnnotation alloc] init];

        [_mapView addAnnotation:_gdAnnotaion];

    }
  //  [_mapView removeAnnotation:_gdAnnotaion];
    _gdAnnotaion.coordinate = coordinate;
    _gdAnnotaion.title = title;
    _gdAnnotaion.subtitle = subtitle;
   // [_mapView addAnnotation:_gdAnnotaion];
    
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
   //     annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
  //      annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
      //  annotationView.pinColor = MAPinAnnotationColorPurple;

        [annotationView setDragState:MAAnnotationViewDragStateStarting animated:YES];
        [annotationView setSelected:YES animated:nil];
        return annotationView;
    }
    return nil;
}


//获取附近地点
- (void)getNearbyList{
    
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:_gdUserLocation.coordinate.latitude longitude:_gdAnnotaion.coordinate.longitude];
    request.sortrule = 0;
    request.requireExtension = YES;
    request.page = _searchPage;
  //  request.keywords = @"汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施";
    
    [self.search AMapPOIAroundSearch:request];
    
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (![tableView isKindOfClass:NSClassFromString(@"UISearchResultsTableView")])
        return _nearbyAddress.count;
    else
        return _searchResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![tableView isKindOfClass:NSClassFromString(@"UISearchResultsTableView")])
        return 67.f;
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (![tableView isKindOfClass:NSClassFromString(@"UISearchResultsTableView")]){
        
        static NSString *resuseID = @"ChatLocationNearbyCell";
        
        ChatLocationNearbyCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseID];
        if (!cell)
        {
            cell = [[ChatLocationNearbyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:resuseID];
        }
        AMapPOI *item = _nearbyAddress[indexPath.row];
        cell.addressLabel.text = item.name;
        cell.subTitleLabel.text = item.address;
        
        return cell;
        
    }else{
        
        AMapTip *tip = _searchResults[indexPath.row];
        
        static NSString *reuseID = @"ResultCellID";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        
        if (!cell)
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
        
        cell.textLabel.text = tip.name;
        
        return cell;
    }
    
    return nil;
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CLLocationCoordinate2D coordinate;
    
    if (![tableView isKindOfClass:NSClassFromString(@"UISearchResultsTableView")]){
        
        AMapPOI *item = _nearbyAddress[indexPath.row];
        
        coordinate  = CLLocationCoordinate2DMake(item.location.latitude, item.location.longitude);
    }
    else{
        
        AMapTip *tip = _searchResults[indexPath.row];
        
        coordinate  = CLLocationCoordinate2DMake(tip.location.latitude,tip.location.longitude);
        
        [_searchLocationSB resignFirstResponder];
        
        [self.view endEditing:YES];

        self.searchDisplayController.active = NO;
    }
    
    [_mapView setRegion:MACoordinateRegionMakeWithDistance(coordinate, showRegion, showRegion)
               animated:YES];
}

#pragma mark - Setter

- (void)setCenterLocation:(CLLocationCoordinate2D)centerLocation{
    
    _centerLocation = centerLocation;
    

    AMapReGeocodeSearchRequest *gR = [[AMapReGeocodeSearchRequest alloc] init];
    gR.location = [AMapGeoPoint locationWithLatitude:centerLocation.latitude longitude:centerLocation.longitude];
    
//    gR.requireExtension = YES;
    
    [self.search AMapReGoecodeSearch:gR];
    
    //移除
    [_nearbyAddress removeAllObjects];
    [_locationTableView reloadInMain];
    [self getNearbyList];

    //重新标志位置
    [UIView animateWithDuration:0.1 animations:^{
        
        [self addAnnotaion:centerLocation title:_currentRG.formattedAddress subtitle:nil];
    }];

}

- (MAMapView *)mapView{
    
    if (!_mapView){
        _mapView = [[MAMapView alloc] initWithFrame:self.mapBGView.bounds];
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
        _mapView.delegate = self;
        _mapView.showsCompass = NO;//MACoordinateRegion
        _mapView.zoomLevel =  15.301968503363673;
        _mapView.zoomEnabled = NO;
    }
    return _mapView;
}


- (AMapSearchAPI *)search{
    
    if (!_search){
        
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}
@end
