//
//  PhotoAlbumCollectionViewController.m
//  NightclubLive
//
//  Created by RDP on 2017/4/21.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "PhotoAlbumCollectionViewController.h"
#import "ImageCollectionViewCell.h"
#import "PhotoAlbumListHeadView.h"
#import "MineRequest.h"
#import "MineModelList.h"
#import "XLPhotoBrowser.h"
#import "UIAlertController+Factory.h"

#import "NCAlert.h"

@interface PhotoAlbumCollectionViewController ()<UICollectionViewDelegateFlowLayout>
{
    CGSize _itemSize;
    UIEdgeInsets _inset;
    BOOL _isSelf;
    BOOL _canEdit;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBtn;

@end

@implementation PhotoAlbumCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _canEdit = NO;
    self.isHead = YES;
    self.isFoot = YES;
    
    CGFloat width = (self.view.width - 32)  / 3.0;
    _itemSize = CGSizeMake(width, width);
    _inset    = UIEdgeInsetsMake(0, 8, 8, 8);
    
    _isSelf = [[UserInfo shareUser].userID isEqualToString:self.model];
    
    if (!_isSelf)
        self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - Request
- (void)refreshMethod
{
    // 获取我的相册,获取其它人
    PhotoAlbumListRequest  *r = [PhotoAlbumListRequest new];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.pageNow) {
        [params setValue:@(self.pageNow) forKey:@"pageNow"];
    }
    if (self.model) {
        [params setValue:self.model forKey:@"userId"];
    }
    [params setValue:@"1" forKey:@"type"];
    r.param = params;
    //r.param = @{@"pageNow":@(self.pageNow),@"userId":self.model,@"type":@"1"};
    [r startRequestWithCompleted:^(ResponseState *state)
    {
        self.parses = [PhotoAlbumList arrayObjectWithDS:state.data];
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    PhotoAlbumList *m = self.dataSources[section];
    return m.images.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImageCollectionViewCellID forIndexPath:indexPath];
    
    PhotoAlbumList *m = self.dataSources[indexPath.section];
    
    cell.indexPath = indexPath;
    cell.photomodel = m;
    cell.selectBtn.hidden = !(_isSelf && _canEdit);
    cell.isAdjust = YES;

    [cell.imgIV sd_setImageWithURL:URL(m.images[indexPath.row]) placeholderImage:[UIImage picturePlaceholder] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
        [cell.imgIV autoAdjustWidth];
    }];

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _itemSize;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return _inset;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    
    if ([UICollectionElementKindSectionHeader isEqualToString:kind])
    {
        PhotoAlbumListHeadView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:PhotoAlbumListHeadViewReuseID forIndexPath:indexPath];
        
        headView.model = self.dataSources[indexPath.section];
        headView.indexPath = indexPath;
        headView.hiddenOperation = !(_isSelf && _canEdit);

        // 删除
        headView.deleteBlock = ^(NSIndexPath *vIndexPath)
        {
            @strongify(self);
            // 删选删除
            // 搜查勾选相册
            ShowLoading
            NSMutableArray *arr = [NSMutableArray array];
            NSMutableArray *remainArr = [NSMutableArray array];
            PhotoAlbumList *m = self.dataSources[vIndexPath.section];
            [m.selects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger isSelect = [obj integerValue];
                
                if (isSelect == 1)
                    [arr addObject:m.images[idx]];
                else
                    [remainArr addObject:m.images[idx]];
            }];
            
            CloseLoading
            // 根据勾选提示
            if (arr.count > 0)
            {
                @strongify(self);
                UIAlertController *ac = [UIAlertController alertCancelAndOKWithTitle:@"提示" message:@"确定要删除照片" okCalk:^(id param) {
                    
                    //提交删除请求到服务器
                    DeletePhotoRequest *r = [DeletePhotoRequest new];
                    r.photoID = m.ID;
                    r.imgs    = [arr copy];
  
                    [r startRequestWithCompleted:^(ResponseState *state) {
                        @strongify(self);
                        if (state.isSuccess){
                            //处理成功,删除对应的图片
                            if (remainArr.count == 0){
                                [self.dataSources removeObjectAtIndex:vIndexPath.section];

                            }
                            else{
                                m.images = [remainArr copy];
                                [m setSelectWithBool:0];
                            }

                            [self.collectionView reloadDataInMain];
                        }
                        else
                            ShowError(state.message);
                    }];
                }];
                
                [self presentViewController:ac animated:YES completion:nil];
            }else{
                                
                UIAlertController *ac = [UIAlertController alertCancelAndOKWithTitle:@"提示" message:@"请勾选需要删除的照片" okCalk:^(id param) {
                }];
                PresentViewController(ac);
            }
        };
        
        //全选
        headView.allBlock = ^(NSDictionary *param){
            
            NSIndexPath *vIndexPath = param[@"indexPath"];
            BOOL isSelect = [param[@"isSelect"] boolValue];
            PhotoAlbumList *m = self.dataSources[vIndexPath.section];
            [m setSelectWithBool:isSelect ? 1 : 0];
            [self.collectionView reloadDataInMain];
        };
        
        return headView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoAlbumList *m = self.dataSources[indexPath.section];
    [XLPhotoBrowser showPhotoBrowserWithImages:m.images currentImageIndex:indexPath.row];
}

#pragma mark - Buttion Click
- (IBAction)editClick:(UIBarButtonItem *)sender
{
    if (_canEdit){//编辑中
        //退出编辑
        _canEdit =!_canEdit;
        
        [sender setImage:KGetImage(@"心声-右上角按钮")];
        [sender setTitle:nil];
        [self.collectionView reloadDataInMain];
    }
    else{
        [NCAlert showActionSheetWithDataSource:@[@"添加",@"删除"] blockHandel:^(NSInteger index) {
            if (index == 0 ){
                [self.navigationController pushViewController:ViewController(@"UploadAlbumSB", @"UploadPhotoAlbumViewController") animated:YES];
            }
            else if (index == 1 )
            {
                if (!_canEdit){
                    [sender setTitle:@"退出编辑"];
                    [sender setImage:nil];
                }else{
                    [sender setImage:KGetImage(@"心声-右上角按钮")];
                    [sender setTitle:nil];
                }
                
                _canEdit = !_canEdit;
                
                [self.collectionView reloadDataInMain];
                
            }
        }];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
