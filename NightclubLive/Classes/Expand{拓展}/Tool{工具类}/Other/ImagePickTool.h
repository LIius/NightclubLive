//
//  ImagePickTool.h
//  NightclubLive
//
//  Created by RDP on 2017/4/17.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagePickTool : NSObject
/**
 *  选择完图片调用的block
 */
@property (nonatomic, copy) void (^finishBlock)(NSArray *images);
@property (nonatomic, copy) void (^finishAssetsAndImagesBlock)(NSArray *assets,NSArray *images);
/** 最多数量 */
@property (nonatomic, assign) NSInteger maxCount;
/** 是否允许选择多张 */
@property (nonatomic, assign) BOOL allowMul;
/** 是否裁剪 */
@property (nonatomic, assign) BOOL edit;
/** 是否要圆形裁剪 */
@property (nonatomic, assign) BOOL editRound;

/**
 *  显示选择项
 *
 *  @param vc 显示在什么view
 */
- (void)showPickImageDataSelect:(UIViewController *)vc  assets:(NSMutableArray *)assets;

@end
