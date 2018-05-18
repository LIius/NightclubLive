//
//  GiftDetailViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GiftDetailViewController.h"
#import "SDCycleScrollView.h"
#import "MineModelList.h"

#import "GiftInfoViewController.h"

@interface GiftDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet SDCycleScrollView *banndScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabe;
@property (weak, nonatomic) IBOutlet UILabel *productionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (nonatomic, weak) PrizeListModel *model;
@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;
@end

@implementation GiftDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载数据
    _titleLabe.text = [NSString stringWithFormat:@"恭喜你获得%@%@",self.model.campaign_title,self.model.ranking];
    _productionNameLabel.text = self.model.prize_name;
    _endTimeLabel.text = [NSString stringWithFormat:@"%@ 止",self.model.end_date.YMDChinaString];
    [_banndScrollView setImageURLStringsGroup:self.model.prizeImgs];
    
    [self addDetailsImageToView];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (!(self.model.status==0)){
        _tipView.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private  Method

/**
 *  添加详细图片到界面
 */
- (void)addDetailsImageToView{
    
    [self.view layoutIfNeeded];
    
    CGFloat spaceHeight = 16.5;
    CGFloat start_y = CGRectGetMaxY(_detailsLabel.frame);
    CGFloat start_x =  _detailsLabel.x;
    
    CGFloat maxWidth = self.view.width - start_x * 2;
    //总共需要的高度
    __block CGFloat sumHeight = start_y;
    for (NSInteger i = 0 ; i < self.model.detailsImgs.count ; i ++){
        
        NSString *url = self.model.detailsImgs[i];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [imageView sd_setImageWithURL:URL(url) placeholderImage:[UIImage picturePlaceholder] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //调整位置
                CGFloat needHeight = (image.size.height / image.size.width) * maxWidth;
                imageView.frame = CGRectMake(start_x, sumHeight + spaceHeight, maxWidth, needHeight);
            
                sumHeight += needHeight;
            });

        }];
        
        imageView.frame = CGRectMake(start_x, maxWidth * i + CGRectGetMaxY(_detailsLabel.frame) + spaceHeight, maxWidth, maxWidth);
        
        [self.detailsView addSubview:imageView];
        
    }
    

    [_detailsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(_detailsView.superview).with.offset(sumHeight);
    }];
    
}

/** 领取礼物 */
- (IBAction)getPrizeClick:(id)sender {
    
    GiftInfoViewController *getVC = [GiftInfoViewController initSBWithSBName:@"GiftInfoSB"];
    
    getVC.model = self.model;
    
    PushViewController(getVC);
}

@end
