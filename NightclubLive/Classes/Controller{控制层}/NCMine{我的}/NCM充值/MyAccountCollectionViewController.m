//
//  MyAccountCollectionViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/13.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MyAccountCollectionViewController.h"
#import "GlobalModel.h"
#import "GlobalRequest.h"
#import "MyAccountCell.h"
#import "AddedValueRequest.h"
#import "AddedValueFootCollectionReusableView.h"
#import "AddedValueHeadCollectionReusableView.h"
#import "AddedValueTool.h"
#import "AXWebViewController.h"
#import "WebActivityViewController.h"
#import "BlocksKit+UIKit.h"
@interface MyAccountCollectionViewController ()
<
UICollectionViewDelegateFlowLayout
>
{
    CGSize _itemSize;
}

@end

@implementation MyAccountCollectionViewController

- (void)dealloc {
    
    self.collectionView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupPacketListRequest];
    
    [self setupCollectionWH];
}

- (void)setupCollectionWH
{
    //设置item大小
    CGFloat width = self.view.width * 0.25;
    CGFloat height = 51.5;
    _itemSize = CGSizeMake(width, height);
}

- (void)setupPacketListRequest
{
    [[AddedValueTool shareTool] getIOSPackageListCompletion:^(NSArray *list)
     {
         [self.dataSources removeAllObjects];
         [self.dataSources addObjectsFromArray:list];
         [self.collectionView reloadDataInMain];
     }];
}

#pragma mark <UICollectionViewDataSource>
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyAccountCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MyAccountCellReuseID forIndexPath:indexPath];
    
    cell.model = self.dataSources[indexPath.row];
    
    cell.indexPath = indexPath;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, self.view.width * 0.06, self.view.height * 0.025, self.view.width * 0.06);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        
        AddedValueHeadCollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:AddedValueHeadCollectionReusableViewReuseID forIndexPath:indexPath];
        
        head.ncBitLabel.text = [UserInfo shareUser].account.night_bit;
        return head;
    }
    else{
        
        AddedValueFootCollectionReusableView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:AddedValueFootCollectionReusableViewReuseID forIndexPath:indexPath];
        
        // 添加充值
        [foot.rechargeBtn bk_whenTapped:^
         {
            @strongify(self);
             [self setupCharge:collectionView];
         }];
        
        return foot;
    }
    
    return nil;
}

- (void)setupCharge:(UICollectionView *)collectionView
{
    // 寻找已经点击cell
    NSInteger selectRow = -1;
    for (NSInteger row = 0 ; row < collectionView.visibleCells.count ; row ++)
    {
        MyAccountCell *cell = collectionView.visibleCells[row];
        if (cell.isSelected)
        {
            selectRow = cell.indexPath.row;
            break;
        }
    }
    
    if (selectRow == -1)
    {
        //提示错误
        
    }else{
        // 购买
        AddedValuePackageModel *m = self.dataSources[selectRow];
        [[AddedValueTool shareTool] buyPackageWithID:m.ID completion:^(id value) {

        }];
    }
}

- (IBAction)seeRuleClick:(id)sender
{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"充值协议" ofType:@"png"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
     NSURLRequest *request = [NSURLRequest requestWithURL:url];

    AXWebViewController *webC = [[AXWebViewController alloc] initWithRequest:request];
    if (AX_WEB_VIEW_CONTROLLER_iOS9_0_AVAILABLE()) {
        webC.webView.allowsLinkPreview = YES;
    }
    webC.showsToolBar = NO;
    webC.showsBackgroundLabel = NO;
    
    webC.title = @"充值协议";
    [self.navigationController pushViewController:webC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
