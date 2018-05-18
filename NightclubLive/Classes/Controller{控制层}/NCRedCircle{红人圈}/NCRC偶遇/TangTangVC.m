//
//  ViewController.m
//  CCDraggableCard-Master
//
//
//  Created by jzzx on 16/7/6.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//

#import "TangTangVC.h"
//#import "CCDraggableContainer.h"
#import "CustomCardView.h"

#import "TangTangPairSuccessVC.h"

#import "OuYuRequest.h"
#import "User.h"

#import "ConditionSettingVC.h"

#import "User.h"
#import "LZSwipeableView.h"
#import "GiftTool.h"
//#import "UIButton+NCRepeatClick.h"

@interface TangTangVC ()
<
LZSwipeableViewDataSource,LZSwipeableViewDelegate
>{
}

@property (nonatomic, strong) NSMutableArray *dataSources;

@property (weak, nonatomic) IBOutlet UIButton *disLikeButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic, strong) OuYuListRequet *request;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) LZSwipeableView *swipView;
@property (nonatomic, strong) ConditionSettingVC *settingVC;

/** 无偶遇提示 */
@property (nonatomic, strong) UILabel *noDataTip;

@end

@implementation TangTangVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self setupSwipeView];
    
    [self setupNodataView];

    [[self rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(id x) {
        self.navigationController.navigationBar.hidden = NO;
    }];
    
    [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        self.navigationController.navigationBar.hidden = YES;
    }];
    
    [[self.backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        // 返回
        [self.navigationController popViewControllerAnimated:YES];
    }];

}

- (void)setupSwipeView
{
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = SCREEN_HEIGHT * 0.7;
    CGFloat x =  (self.view.width - width) * 0.5;
    CGFloat y = 60;
    
#warning iPhoneX
    if (iPhoneX)
    {
        y = 60 + 58;
    }
    
    self.swipView = [[LZSwipeableView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    self.swipView.datasource = self;
    self.swipView.delegate = self;
    self.swipView.backgroundColor = [UIColor clearColor];
    self.swipView.topCardInset = UIEdgeInsetsMake(20, 20, 20, 20);
    self.swipView.hidden = NO;
    
    [self.view addSubview:self.swipView];
    
    self.currentPage = 0;
    
    [self requetOuYuListWithType:0];
}

#pragma mark - Swip Data Source
- (NSInteger)swipeableViewNumberOfRowsInSection:(LZSwipeableView *)swipeableView
{
    return self.dataSources.count;
}

- (NSInteger)swipeableViewMaxCardNumberWillShow:(LZSwipeableView *)swipeableView
{
    return 3;
}

- (LZSwipeableViewCell *)swipeableView:(LZSwipeableView *)swipeableView cellForIndex:(NSInteger)index
{
    CustomCardView *cardView = [CustomCardView customCardView];
    cardView.model = _dataSources[index];
    
    {
        //    cardView.layer.cornerRadius = 10;
        // [cardView installData:[_dataSources objectAtIndex:index]];
        // cardView.titleLabel.text = [NSString stringWithFormat:@"%ld",index];
    }
    
    return cardView;
}

- (void)swipeableView:(LZSwipeableView *)swipeableView didTopCardShow:(LZSwipeableViewCell *)topCell
{
    self.currentIndex = swipeableView.currentIndex;

    if (self.currentIndex == self.dataSources.count - 1)
    {
        [self requetOuYuListWithType:1];
    }
}

- (void)swipeableViewDidLastCardRemoved:(LZSwipeableView *)swipeableView
{
    _noDataTip.hidden = NO;
}

- (void)setupNodataView
{
    self.noDataTip = [[UILabel alloc] init];
    self.noDataTip.text = @"暂时没有可偶遇对像";
    self.noDataTip.textColor = [UIColor grayColor];
    self.noDataTip.hidden = YES;
    self.noDataTip.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.noDataTip];
    
    // [self.view bringSubviewToFront:self.noDataTip];
    [_noDataTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.mas_equalTo(16);
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
}

#pragma mark - 请求用户信息
- (void)requetOuYuListWithType:(NSInteger)type
{
    if (!_dataSources){
        _dataSources = [NSMutableArray array];
    }
    
    @weakify(self);
    if (type == 0){
        self.currentPage = 1;
    }
    else{
        self.currentPage += 1;
    }
    

    if (!self.request) {
        self.request = [OuYuListRequet new];
    }
    
    self.request.pageNow = self.currentPage;
    [self.request startWithCompletedBlock:^(GJBaseRequest *request)
    {
        @strongify(self);
        
        ResponseState *state = [ResponseState objectWithDic:request.responseObject];
        
        if (state.isSuccess)
        {
            if (state.data)
            {
                _dataSources = [DataUser arrayObjectWithDS:state.data].mutableCopy;
                DLog(@"_dataSources=%@",_dataSources);
                // [_dataSources addObjectsFromArray:[DataUser arrayObjectWithDS:state.data]];
                
                if (type == 0)
                {
                    [self.swipView reloadData];
                }
                else{
                    [self.swipView refreshDataSource];
                }
                
                
                NSArray *array = state.data;
                _noDataTip.hidden = !(type == 0 && array.count == 0);
                
            }else{
                
                [_dataSources removeAllObjects];
                [self.swipView reloadData];
                
                _noDataTip.hidden = NO;
            }
            
        }

    }];
}

#pragma mark - 点击爱心
- (IBAction)likeClick:(id)sender
{
    if (_currentIndex > _dataSources.count){
        return;
    }
    
    DataUser *currentUser = _dataSources[self.currentIndex];
    
    // 增加喜欢
    OuYuLiveRequet *addLiveQ = [OuYuLiveRequet new];
    addLiveQ.toUserID = currentUser.ID;
    // 判断是否喜欢
    OuYuIsLiveRequet *isLiveQ = [OuYuIsLiveRequet new];
    isLiveQ.toUserID = currentUser.ID;
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    
    __block ResponseState *addState;
    __block ResponseState *checkState;
    
    dispatch_async(queue, ^{
        
        dispatch_group_async(group, queue, ^{
            
            [addLiveQ startWithCompletedBlock:^(GJBaseRequest *request) {
                
                addState = [ResponseState objectWithDic:request.responseObject];
                
                dispatch_group_leave(group);
            }];
        });
        
        dispatch_group_async(group, queue, ^{
            [isLiveQ startWithCompletedBlock:^(GJBaseRequest *request) {
                
                checkState = [ResponseState objectWithDic:request.responseObject];
                
                dispatch_group_leave(group);
            }];
        });
        
        
        dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 60));
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            
            // 检查是否喜欢
            if (checkState.isSuccess)
            {
                TangTangPairSuccessVC *vc = [TangTangPairSuccessVC controllerWithViewModel:nil andSbName:@"TangTangPairSuccessSB"];
              //  vc.model = self.dataSources[self.currentIndex];
                vc.loveUser = currentUser;
                
                [self.navigationController pushViewController:vc animated:NO];
            }else{
                
               [self.swipView removeTopCardViewFromSwipe:LZSwipeableViewCellSwipeDirectionRight];
            }
        });
        
    });
}

#pragma mark - 点击交叉按钮
- (IBAction)disLikeClick:(id)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnClickedOperations) object:nil];
    
    [self performSelector:@selector(btnClickedOperations) withObject:nil afterDelay:0.3];
}

- (void)btnClickedOperations
{
     [self.swipView removeTopCardViewFromSwipe:LZSwipeableViewCellSwipeDirectionLeft];
}

#pragma mark - 送礼物
- (IBAction)sendGift:(id)sender
{
    if (_dataSources.count < self.currentIndex) {
        return;
    }
    
    DataUser *currentUser = _dataSources[self.currentIndex];
    GiftTool *tool = [GiftTool defaultGiftTool];
    tool.receiverID = currentUser.ID;
    tool.giftType = 7;
    tool.projectID = 0;
    [tool showGiftView];
}

#pragma mark - 点击设置
- (IBAction)settingClick:(id)sender
{
    if (!self.settingVC){
        self.settingVC =  [ConditionSettingVC initSBWithSBName:@"ConditionSettingSB"];
    }
    
    @weakify(self);
    self.settingVC.calkBackBlock = ^(NSDictionary *param)
    {
        @strongify(self);
        self.request.city = param[@"city"];
        self.request.sex  = param[@"sex"];
        self.request.job  = param[@"job"];
        
        self.currentIndex = 0;
        self.currentPage = 0;
        [self.dataSources removeAllObjects];
        [self requetOuYuListWithType:0];
    };
    
    [self.navigationController pushViewController:self.settingVC animated:YES];
}

@end
