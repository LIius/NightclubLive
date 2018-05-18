//
//  ImagePickTool.m
//  NightclubLive
//
//  Created by RDP on 2017/4/17.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ImagePickTool.h"
#import "UIAlertController+Factory.h"
#import "CTAssetsPickerController.h"
#import "UIWindow+CurrentViewController.h"
#import <QBImagePickerController/QBImagePickerController.h>
#import "TZImagePickerController.h"

@interface ImagePickTool()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate,TZImagePickerControllerDelegate>
@property (nonatomic, strong) QBImagePickerController *picker;
/** 图片选择编辑器 */
@property (nonatomic, strong) TZImagePickerController *imagePick;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIImagePickerController *imagePCU;
@property (nonatomic, strong) NSArray *assetSubtypes;
@property (nonatomic, strong) NSArray *mediaTypes;

@end

@implementation ImagePickTool

- (instancetype)init
{
    if ([super init]){
        if (!self.maxCount)
        {
            self.maxCount = 9;
        }
        
    }
    return self;
}


- (QBImagePickerController *)picker
{
    if (!_picker){
        
        _picker = [[QBImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.allowsMultipleSelection = YES;
        _picker.showsNumberOfSelectedAssets = YES;
        _picker.mediaType = QBImagePickerMediaTypeImage;
    }
    return _picker;
}

- (void)showPickImageDataSelect:(UIViewController *)vc assets:(NSMutableArray *)assets
{
    // 必须每次都创建
    self.imagePick = [[TZImagePickerController alloc] initWithMaxImagesCount:self.maxCount delegate:self];
    self.imagePick.allowCrop = self.edit;
    self.imagePick.allowPickingVideo = NO;
    self.imagePick.maxImagesCount = self.maxCount;
    self.imagePick.showSelectBtn = !self.edit;
    self.imagePick.needCircleCrop = self.editRound;
    self.imagePick.selectedAssets = assets;
    UIViewController *pushVC = vc ? vc : [ShareWindow zf_currentViewController];
    [pushVC presentViewController:self.imagePick animated:YES completion:nil];
}

- (NSArray *)assetSubtypes
{
    NSArray *assetCollectionSubtypes =
    @[@(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
      @(PHAssetCollectionSubtypeAlbumMyPhotoStream),
      @(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded),
      @(PHAssetCollectionSubtypeSmartAlbumFavorites),
      @(PHAssetCollectionSubtypeSmartAlbumPanoramas),
      // @(PHAssetCollectionSubtypeSmartAlbumVideos),
      @(PHAssetCollectionSubtypeSmartAlbumSlomoVideos),
      @(PHAssetCollectionSubtypeSmartAlbumTimelapses),
      @(PHAssetCollectionSubtypeSmartAlbumBursts),
      @(PHAssetCollectionSubtypeSmartAlbumAllHidden),
      @(PHAssetCollectionSubtypeSmartAlbumGeneric),
      @(PHAssetCollectionSubtypeAlbumRegular),
      @(PHAssetCollectionSubtypeAlbumSyncedAlbum),
      @(PHAssetCollectionSubtypeAlbumSyncedEvent),
      @(PHAssetCollectionSubtypeAlbumSyncedFaces),
      @(PHAssetCollectionSubtypeAlbumImported),
      @(PHAssetCollectionSubtypeAlbumCloudShared)];
    
    // Add iOS 9's new albums
    if ([[PHAsset new] respondsToSelector:@selector(sourceType)])
    {
        NSMutableArray *subtypes = [NSMutableArray arrayWithArray:assetCollectionSubtypes];
        [subtypes insertObject:@(PHAssetCollectionSubtypeSmartAlbumSelfPortraits) atIndex:4];
        [subtypes insertObject:@(PHAssetCollectionSubtypeSmartAlbumScreenshots) atIndex:10];
        
        assetCollectionSubtypes = [NSArray arrayWithArray:subtypes];
    }
    return assetCollectionSubtypes;
}

- (UIImagePickerController *)imagePCU
{
    if (!_imagePCU){
        _imagePCU = [[UIImagePickerController alloc] init];
        _imagePCU.sourceType = UIImagePickerControllerSourceTypeCamera;
        _imagePCU.delegate = self;
    }
    return _imagePCU;
}

- (NSArray *)assetMediaTypes
{
    NSMutableArray *subTypes   = [self.assetSubtypes mutableCopy];
    
    NSArray *videoTypes = @[
                            @(PHAssetCollectionSubtypeSmartAlbumVideos),
                            @(PHAssetCollectionSubtypeSmartAlbumSlomoVideos)];
    
    if (![self.mediaTypes containsObject:(NSString *)kUTTypeImage]) {
        subTypes = [videoTypes mutableCopy];
    }
    if (![self.mediaTypes containsObject:(NSString *)kUTTypeMovie]) {
        [subTypes removeObjectsInArray:videoTypes];
    }
    return subTypes;
}

- (NSArray *)mediaTypes
{
    if (!_mediaTypes){
        
        _mediaTypes = @[/*(NSString *)kUTTypeMovie,*/(NSString *)kUTTypeImage];

    }return _mediaTypes;
}

#pragma mark - CTAssetsPickerControllerDelegate

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
    [UIImage getImageFromPHAsset:assets Complete:^(NSArray *images) {
        
        if (self.finishBlock)
            self.finishBlock(images);
    }];
    
    imagePickerController.delegate = nil;
    imagePickerController = nil;
    self.picker = nil;
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
    imagePickerController.delegate = nil;
    imagePickerController = nil;
    self.picker = nil;
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto
{
    if (self.finishAssetsAndImagesBlock){
        self.finishAssetsAndImagesBlock(assets,photos);
    }
    
}

@end
