//
//  PersonCVC.m
//  NightclubLive
//
//  Created by RDP on 2017/6/30.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "PersonCVC.h"
#import "PersonCell.h"
#import "CMWaterFallLayout.h"
#import "XRWaterfallLayout.h"
#import "ChatRequest.h"
#import "NetRedCircleListModel.h"
#import "UIWindow+CurrentViewController.h"
#import "UserInfoViewController.h"
#import "EmptyBigView.h"
#import "FindUserView.h"

@interface PersonCVC ()<XRWaterfallLayoutDelegate>

/** itemHeight */
@property (nonatomic, assign) CGFloat itemHeight;
/** 搜索关键词 */
@property (nonatomic, copy) NSString *searchKey;
/** footView */
@property (nonatomic, strong) UIView *footView;
@property(nonatomic,strong)UIView *emptyView;

@end

@implementation PersonCVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    adjustsScrollViewInsets_NO(self.collectionView,self);
    
    XRWaterfallLayout *layout = (XRWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = 3;
    layout.columnSpacing = 10;
    layout.rowSpacing = 10;
    
    CGFloat top = 20;
    if (iPhoneX) {
        top = 40;
    }
    
    layout.sectionInset = UIEdgeInsetsMake(top, 10, 20, 10);
    layout.delegate =  self;
    
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView registerClass:[FindUserView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:FindUserViewReuseID];
    self.isFoot = YES;
}

#pragma mark - Search
- (void)searchForKey:(NSString *)searchkey
{
    self.pageNow = 1;
    _searchKey = searchkey;
    [self.dataSources removeAllObjects];
    [self.collectionView.mj_footer resetNoMoreData];
    [self.collectionView reloadDataInMain];
    [self.collectionView endRefresh];
    [self refreshMethod];
}

- (void)refreshMethod
{
    FindUserRequest *r = [FindUserRequest new];
    r.professionValue = _searchKey;
    r.pageNow = self.pageNow;
    [r startRequestWithCompleted:^(ResponseState *state) {
        // 处理
        self.parses = [FindUserModel arrayObjectWithDS:state.data];
    }];
}

#pragma mark - Getter
- (UIView *)footView
{
    if (_footView)
    {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        _footView.backgroundColor = [UIColor blueColor];
    }
    return _footView;
}

#pragma mark - Colleciton

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataSources.count == 0 )
    {
        if (!_emptyView)
        {
            UIView *v = [EmptyBigView viewWithTip:@"找不到半个用户~"];
            v.frame = [NCEmpty getEmtpyViewRectWithScrollView:self.collectionView];
            CGPoint offset = CGPointMake(0, -self.view.height * 0.25);
            v.y += offset.y;
            v.x += offset.x;
            
            [self.view addSubview:v];
            _emptyView = v;
        }
        
    }else{
        if (_emptyView){
            [_emptyView removeFromSuperview];
        }
        
    }
    return self.dataSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PersonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PersonCellReuseID forIndexPath:indexPath];
    cell.model = self.dataSources[indexPath.row];
    
    return cell;
}

// 根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(XRWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath
{
    return (150/110.0) * itemWidth + 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FindUserModel  *m = self.dataSources[indexPath.row];
    User *user = [User new];
    user.userId = m.ID;
    
    UserInfoViewController *infoVC = ViewController(@"UserInfoSB", @"UserInfoViewController");
    infoVC.userModel = user;
 
    [[ShareWindow zf_currentViewController].navigationController pushViewController:infoVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
