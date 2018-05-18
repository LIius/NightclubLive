//
//  XWPublishBaseController.m
//  XWPublishDemo
//
//  Created by 邱学伟 on 16/4/15.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "XWPublishBaseController.h"
#import "XLPhotoBrowser.h"
#import "ImagePickTool.h"
#import "ObjectNavigationController.h"

// 间隔
static CGFloat SpaceWith = 10;

@interface XWPublishBaseController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate
>
{
    NSString *pushImageName;
}

@property (nonatomic, strong) ImagePickTool *imageTool;
@end

@implementation XWPublishBaseController

static NSString * const reuseIdentifier = @"XWPhotoCell";

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        if (!_showActionSheetViewController)
        {
            _showActionSheetViewController = self;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

// 初始化collectionView
-(void)initPickerView
{
    _showActionSheetViewController = self;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (_showInView) {
        self.pickerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(14, 40, _showInView.frame.size.width, _showInView.frame.size.height) collectionViewLayout:layout];
        [_showInView addSubview:self.pickerCollectionView];
    }
    self.pickerCollectionView.delegate=self;
    self.pickerCollectionView.dataSource=self;
    self.pickerCollectionView.backgroundColor = [UIColor whiteColor];
    
    if(_imageArray.count == 0)
    {
        _imageArray = [NSMutableArray array];
    }
    
    pushImageName = @"plus.png";
    
    _pickerCollectionView.scrollEnabled = NO;
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger numberItem = _imageArray.count;
    
    if (numberItem < _maxCount)
        numberItem += 1;
    
    return numberItem;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    UINib *nib = [UINib nibWithNibName:@"XWPhotoCell" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"XWPhotoCell"];

    XWPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"XWPhotoCell" forIndexPath:indexPath];
    
    if (indexPath.row == _imageArray.count) {
        [cell.profilePhoto setImage:[UIImage imageNamed:pushImageName]];
        cell.closeButton.hidden = YES;
    }
    else{
        [cell.profilePhoto setImage:_imageArray[indexPath.item]];
        cell.closeButton.hidden = NO;
    }
    [cell setBigImgViewWithImage:nil];
    cell.profilePhoto.tag = [indexPath item];
    
    // 添加图片cell点击事件
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapProfileImage:)];
    singleTap.numberOfTapsRequired = 1;
    cell.profilePhoto .userInteractionEnabled = YES;
    [cell.profilePhoto  addGestureRecognizer:singleTap];
    cell.closeButton.tag = [indexPath item];
    [cell.closeButton addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat collectionViewW = _showInView.frame.size.width;
                           
    CGFloat width = (collectionViewW - SpaceWith * (_rowCount + 1) ) / _rowCount;
    CGFloat height = width;
    DLog(@"{height=%f---%f---%ld",width,collectionViewW,(long)_rowCount);
    return CGSizeMake(width, height);
}

////定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 5, 0, 5);
}

#pragma mark - 图片cell点击事件
// 点击图片看大图
- (void) tapProfileImage:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
    
    UIImageView *tableGridImage = (UIImageView*)gestureRecognizer.view;
    NSInteger index = tableGridImage.tag;
    
    if (index == (_imageArray.count)) {
        [self.view endEditing:YES];
        // 添加新图片
        [self addNewImg];
    }
    else{
        // 点击放大查看
        XWPhotoCell *cell = (XWPhotoCell*)[_pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        if (!cell.BigImgView || !cell.BigImgView.image) {
           
            [cell setBigImgViewWithImage:self.imageArray[index]];
            //[cell setBigImgViewWithImage:[self getBigIamgeWithALAsset:_arrSelected[index]]];
        }
        
        // 数组内部可以是UIImage/NSURL网络图片地址/ALAsset,但只能是其中一种
//        [XLPhotoBrowser showPhotoBrowserWithImages:_bigImageArray currentImageIndex:index];
         [XLPhotoBrowser showPhotoBrowserWithImages:self.imageArray currentImageIndex:index];
    }
}

- (ImagePickTool *)imageTool
{
    if (!_imageTool){
        
        @weakify(self);
        
        _imageTool = [[ImagePickTool alloc] init];
        _imageTool.maxCount = 20;
        
        _imageTool.finishAssetsAndImagesBlock = ^(NSArray *assets,NSArray *images){
            @strongify(self);
            DLog(@"%@",images);
            
            //（ALAsset）类型 Array
                self.assetsArray = [NSMutableArray arrayWithArray:assets];
            // 正方形缩略图 Array
            self.imageArray = [NSMutableArray arrayWithArray:images] ;
        };
        
    }
    return _imageTool;
}

#pragma mark - 选择图片
- (void)addNewImg
{
    [self.imageTool showPickImageDataSelect:self assets:self.assetsArray];
}

#pragma mark - 删除照片
- (void)deletePhoto:(UIButton *)sender
{
    [self.imageArray removeObjectAtIndex:sender.tag];
    [self.assetsArray removeObjectAtIndex:sender.tag];

    // 停掉动画
    [self.pickerCollectionView reloadData];
    
    for (NSInteger item = sender.tag; item <= _imageArray.count; item++) {
        XWPhotoCell *cell = (XWPhotoCell*)[self.pickerCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]];
        cell.closeButton.tag--;
        cell.profilePhoto.tag--;
    }
    
    [self changeCollectionViewHeight];
}

#pragma mark - 改变view，collectionView高度
- (void)changeCollectionViewHeight
{
    if (_collectionFrameY) {
        _pickerCollectionView.frame = CGRectMake(0, _collectionFrameY,_showInView.frame.size.width, (((float)[UIScreen mainScreen].bounds.size.width-64.0) /4.0 +20.0)* ((int)(self.imageArray.count)/4 +1)+20.0);
        //_pickerCollectionView.frame = CGRectMake(0, _collectionFrameY, [UIScreen mainScreen].bounds.size.width, (((float)[UIScreen mainScreen].bounds.size.width-64.0) /4.0 +20.0)* ((int)(_arrSelected.count)/4 +1)+20.0);
    }
    else{
        _pickerCollectionView.frame = CGRectMake(0, 40,_showInView.frame.size.width, (((float)[UIScreen mainScreen].bounds.size.width-64.0) /4.0 +20.0)* ((int)(self.imageArray.count)/4 +1)+20.0);
        //_pickerCollectionView.frame = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, (((float)[UIScreen mainScreen].bounds.size.width-64.0) /4.0 +20.0)* ((int)(_arrSelected.count)/4 +1)+20.0);
    }
    
    [self pickerViewFrameChanged];
}

/**
 *  相册完成选择得到图片
 */
-(void)getSelectImageWithALAssetArray:(NSArray *)ALAssetArray thumbnailImageArray:(NSArray *)thumbnailImgArray
{
    //（ALAsset）类型 Array
//    self.arrSelected = [NSMutableArray arrayWithArray:ALAssetArray];
    // 正方形缩略图 Array
    self.imageArray = [NSMutableArray arrayWithArray:thumbnailImgArray] ;
}

- (void)setImageArray:(NSMutableArray *)imageArray
{
    _imageArray = imageArray;
    

    [self changeCollectionViewHeight];
    
    [self.pickerCollectionView reloadData];
}

//- (void)setArrSelected:(NSMutableArray *)arrSelected
//{
//    _arrSelected = arrSelected;
//}

- (void)pickerViewFrameChanged
{
    
}

- (void)updatePickerViewFrameY:(CGFloat)Y
{
    _collectionFrameY = Y;
    
    // coderiding
    NSInteger imgCount = _imageArray.count;
    NSInteger count = (imgCount / _rowCount) + 1;
    
    CGFloat height = (([UIScreen mainScreen].bounds.size.width - SpaceWith * (_rowCount + 2) + 10) / _rowCount + 15) * count ;
    
//    _pickerCollectionView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
    _pickerCollectionView.frame = CGRectMake(0, 0, _showInView.frame.size.width, height);
}

#pragma mark - 防止奔溃处理
-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    // NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}

- (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize
{
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}

// 获得大图
//- (NSArray*)getBigImageArrayWithALAssetArray:(NSArray*)ALAssetArray
//{
//    _bigImgDataArray = [NSMutableArray array];
//    NSMutableArray *bigImgArr = [NSMutableArray array];
//    for (ALAsset *set in ALAssetArray) {
//        [bigImgArr addObject:[self getBigIamgeWithALAsset:set]];
//    }
//
//    _bigImageArray = bigImgArr;
//
//    return _bigImgDataArray;
//}

#pragma mark - 获得选中图片各个尺寸
//- (NSArray*)getALAssetArray
//{
//    return _arrSelected;
//}

//- (NSArray*)getBigImageArray
//{
//    return [self getBigImageArrayWithALAssetArray:_arrSelected];
//}

- (NSArray*)getSmallImageArray
{
    return _imageArray;
}

- (CGRect)getPickerViewFrame
{
    return self.pickerCollectionView.frame;
}

#pragma mark - Setter
- (void)setMaxCount:(NSInteger)maxCount
{
    _maxCount = maxCount;
}
@end
