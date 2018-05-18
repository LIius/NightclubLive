//
//  UIApplication+scanLocalVideo.h
//  LocalVideo
//
//  Created by Coderiding on 16/8/2.
//  Copyright © 2016年 Coderiding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef void (^AssetBlock)(NSArray *nameArr,NSArray *lengthArray,NSArray *imageArray);

@interface UIApplication (scanLocalVideo)
/**
 *  获取相册的授权
 *  @return YES/NO
 */
- (BOOL)authStatus;
/**
 *  视频的搜索结果
 *
 *  @return 返回的是一个数组集合，里面是PHAsset
 */
- (PHFetchResult *)assetsFetchResults;
/**
 *  获取所需要的Video属性
 *
 *  @param type TFVideoAssetType
 *
 *  @return 资源数组
 */
- (void )getVideoRelatedAttributesAssetBlock:(AssetBlock )block;

@end
