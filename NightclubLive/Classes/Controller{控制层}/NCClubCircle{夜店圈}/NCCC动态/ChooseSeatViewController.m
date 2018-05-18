//
//  ChooseSeatViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/6/29.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ChooseSeatViewController.h"
#import "ChooseSeatCell.h"
#import "SeatHeadIView.h"
#import "ClubCircleRequest.h"

#import "ClubCircleModelList.h"
#import "NSDate+Utilities.h"

#import "NetRedCircleListModel.h"
#import "WebActivityViewController.h"

static NSInteger itemSpace = 16;
static NSInteger itemCount = 4;

@interface ChooseSeatViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** item大小 */
@property (nonatomic, assign) CGSize itemSize;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 不可选座位数组 */
@property (nonatomic, strong) NSArray *nocans;
/** 选择的index */
@property (nonatomic, weak) NSIndexPath *selectIndexPath;
/** 模型对象 */
@property (nonatomic, strong) NetRedCircleBarDetailModel *barDetailsModel;


@end

@implementation ChooseSeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //计算item大小
    CGFloat itemWidth  = (SCREEN_WIDTH - (itemCount + 1) * itemSpace ) / itemCount;
    CGFloat itemHeight = 43;
    
    _itemSize = CGSizeMake(itemWidth, itemHeight);

    [_collectionView registerClass:[SeatHeadIView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SeatHeadIViewReuseID];

    self.refreshView = self.collectionView;
    
    [self refreshMethod];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request Method
- (void)refreshMethod{
    
    BarTableNoRequest *r = [BarTableNoRequest new];
    NSString *timeStr = [self.selectDate timeStringWithFormatter:@"yyyy-MM-dd HH:mm"];
    
    if (self.tag == 0){
        timeStr = [self.selectDate timeStringWithFormatter:@"yyyy-MM-dd"];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.model) {
        [params setValue:self.model forKey:@"sellerId"];
    }
    if (timeStr.length > 0) {
        [params setValue:timeStr forKey:@"dateTime"];
    }
    r.param = params;
   // r.param = @{@"sellerId":self.model,@"dateTime":timeStr};
    
    [r startRequestWithCompleted:^(ResponseState *state) {
        
        self.parses = [BarTableNoModel arrayObjectWithDS:state.datas];
        self.nocans = [BarTableNoNoCanModel arrayObjectWithDS:state.data];
        self.barDetailsModel = [[NetRedCircleBarDetailModel alloc] initWithDic:state.seller_details];
    }];
}


#pragma mark - Getter

- (NSDate *)selectDate{
    
    if (!_selectDate)
        return [NSDate date];
    
    return _selectDate;
}

#pragma mark - Collection Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.dataSource.count <= section)
        return 0;
    
    BarTableNoModel *m = self.dataSource[section];
    return m.seats.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ChooseSeatCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ChooseSeatCellReuseID forIndexPath:indexPath];
    
    BarTableNoModel *m = self.dataSource[indexPath.section];
    
    NSString *title = m.seats[indexPath.row];
    
    cell.seatNameLabel.text = title;
    NSInteger tag = 0 ;
    for (BarTableNoNoCanModel *m in self.nocans){
        if([title isEqualToString:m.tableName]){
            tag = 1;
            break;
        }
    }
    
    cell.tag = tag;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        SeatHeadIView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SeatHeadIViewReuseID forIndexPath:indexPath];
     //   headView.backgroundColor = [UIColor blueColor];
        
       // headView.titleLabel.text = @"测试";
        BarTableNoModel * m = self.dataSource[indexPath.section];
        NSString *title = [NSString stringWithFormat:@"%@（可容纳%ld人）",m.tableType,m.galleryful];
        NSMutableAttributedString *mString = [[NSMutableAttributedString alloc] initWithString:title];
        [mString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, m.tableType.length)];
        [mString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(m.tableType.length, title.length - m.tableType.length)];
    
        headView.titleLabel.attributedText = mString;
        return headView;
    }
    
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(SCREEN_WIDTH, 60);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectIndexPath = indexPath;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return _itemSize;
}

#pragma mark - Click

- (IBAction)okClick:(id)sender {
    
    if (!_selectIndexPath){
        ShowError(@"请选取座位号");
        return;
    }
    
    if (self.calkBlock){
        BarTableNoModel *m = self.dataSource[_selectIndexPath.section];
        
        self.calkBlock(m.seats[_selectIndexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (IBAction)seatClick:(id)sender {
    
    NSURL *url = self.barDetailsModel.seatImageURL;
    
    WebActivityViewController *wv = [[WebActivityViewController alloc] initWithURL:url];
    if (AX_WEB_VIEW_CONTROLLER_iOS9_0_AVAILABLE()) {
        wv.webView.allowsLinkPreview = YES;
    }
    wv.showsToolBar = NO;

    PushViewController(wv);
}

@end
