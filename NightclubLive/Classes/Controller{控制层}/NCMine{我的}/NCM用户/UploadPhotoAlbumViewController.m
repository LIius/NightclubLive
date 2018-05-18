//
//  UploadPhotoAlbumViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/17.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "UploadPhotoAlbumViewController.h"
#import "ImageCollectionViewCell.h"
#import "CTAssetsPickerController.h"
#import "ImagePickTool.h"
#import "QiniuTool.h"
#import "TipsView.h"

#import "UIAlertController+Factory.h"
#import "PhotoRequest.h"
#import "XLPhotoBrowser.h"

@interface UploadPhotoAlbumViewController ()
<
UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource
>
{
    CGSize _itemSize;
    UIEdgeInsets _edge;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) ImagePickTool *imageTool;
@property (nonatomic,strong)NSMutableArray *assetsArray;

@end

@implementation UploadPhotoAlbumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGFloat itemWith = self.view.width * 0.296;
    _itemSize = CGSizeMake(itemWith, itemWith);
    
    _edge = UIEdgeInsetsMake(13.5, 5, 5, 5);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:KGetImage(@"icon_backwhite") style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataSource.count < maxImagcount)
        return self.dataSource.count + 1;
    else
        return self.dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return _edge;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    @weakify(self);
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCollectionViewCellID forIndexPath:indexPath];
    
    cell.calkBlock = ^(NSIndexPath *valueIndexPath){
        @strongify(self);
        [self.dataSource removeObjectAtIndex:valueIndexPath.row];
        [self.assetsArray removeObjectAtIndex:valueIndexPath.row];
        
        [self.collectionView performBatchUpdates:^{
            @strongify(self);
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            @strongify(self);
            [self updateImageView];
            [self.collectionView reloadDataInMain];
        }];

    };
    
    if (indexPath.row == self.dataSource.count){
        cell.model = KGetImage(@"btn_添加");
    }
    else{
        cell.model = self.dataSource[indexPath.row];
    }
    
    cell.indexPath = indexPath;
    
    cell.closeBtn.hidden = indexPath.row == self.dataSource.count;
    
    return cell;
}

#pragma mark - Collection Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataSource.count )
    {
        [self.imageTool showPickImageDataSelect:self assets:self.assetsArray];
    }
    else{
        [XLPhotoBrowser showPhotoBrowserWithImages:[self.dataSource copy] currentImageIndex:indexPath.row];
    }
}

#pragma mark - Getter

- (ImagePickTool *)imageTool
{
    if (!_imageTool){
        
        @weakify(self);
        _imageTool = [[ImagePickTool alloc] init];
        
        _imageTool.finishAssetsAndImagesBlock = ^(NSArray *assets,NSArray *images)
        {
            @strongify(self);
            self.assetsArray =  [NSMutableArray arrayWithArray:assets];
            self.dataSource = [NSMutableArray arrayWithArray:images];
            [self updateImageView];
            [self.collectionView reloadDataInMain];
        };
        
    }
    return _imageTool;
}

#pragma mark - Priavte Method
- (void)updateImageView
{
    NSInteger row = ceil((self.dataSource.count + 1) / 3.0 );
    
    self.collectionView.height = row * _itemSize.height + 34.5;
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)uploadClick:(id)sender {
    
    if (self.dataSource.count < 1)
    {
        [self presentViewController:[UIAlertController alertControllerWithTitle:nil withMessage:@"请添加要上传的图片" calk:nil] animated:YES completion:nil];
        return;
    }

    ShowLoading;
    
    // 上传到七牛云
    @weakify(self);
    [[QiniuTool shareTool] uploadImages:self.dataSource type:UploadTypeSpaceTypeAuth success:^(id value)
     {
        if (!value)
        {
            return ;
        }

        // 提交数据到服务器
        UploadPotoRequest *r = [[UploadPotoRequest alloc] init];
        r.img = value;
        
        [r startRequestWithCompleted:^(ResponseState *state)
        {
            @strongify(self);
            CloseLoading;
            if (state.isSuccess){
                [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController.childViewControllers[self.navigationController.childViewControllers.count - 1] presentViewController:[UIAlertController alertControllerWithTitle:@"提示" withMessage:@"图片上传成功" calk:nil] animated:YES completion:nil];
            }
        }];
        
    } failure:^(NSError *error) {
        CloseLoading;
    }];
}

#pragma mark - Button
- (void)backClick
{
    TipsView *view = [TipsView tipsView];
    [view.doneBtn setTitle:@"点错了" forState:UIControlStateNormal];
    [view.oneBtn setTitle:@"是的" forState:UIControlStateNormal];
    view.titleLable.text = @"是否取消编辑";
    [view show];
    [[view.doneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [view removeFromSuperview];
    }];
    
    [[view.oneBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController popViewControllerAnimated:YES];
        [view removeFromSuperview];
        
    }];
}

@end
