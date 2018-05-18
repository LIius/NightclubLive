//
//  UIImage+NCImage.h
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;

@interface UIImage (NCImage)

/**
 *  用户占位
 *
 *  @return 图片
 */
+ (UIImage *)userPlaceholder;

/**
 *  普通图片占位
 *
 *  @return 图片
 */
+ (UIImage *)picturePlaceholder;

/** 点赞的iamge */
+ (UIImage *)praiseImage;
/** 没有点赞的iamge */
+ (UIImage *)nopraiseImage;
/** 获取点赞图片  */
+ (UIImage *)praiseWithType:(NSInteger)type;
/** 获取头像(type - 0（女） ,type - 1(男) )  下同*/
+ (UIImage *)sexImageWithType:(NSInteger)type;
+ (UIImage *)sex2ImageWithType:(NSInteger)type;




+ (void)getImageFromPHAsset:(NSArray *)assets Complete:(void (^)(NSArray *images))result;




#pragma mark - 根据目标视图大小获得新的图片尺寸
- (UIImage *)imageSizeTransformToTargetView:(UIView *)targetView;

#pragma mark - 用颜色创建背景图片
+ (UIImage*)imageWithColor:(UIColor*)color;

#pragma mark - 圆形图
-(instancetype)circleImage;

#pragma mark - 圆形图
+(instancetype)circleWithImageName:(NSString *)name;

/**
 指定高度按比例缩放
 */
-(UIImage *)imageCompressToTargetHeigth:(NSInteger)targetHeight withSourceImage:(UIImage *)sourceImage;

/** 指定宽度按比例缩放
 */
-(UIImage *)imageCompressToTargetWidth:(NSInteger )targetWidth withSourceImage:(UIImage *)sourceImage;

/**等比例缩放
 */
- (UIImage*)imageScaleToSize:(CGSize)size;

#pragma mark 实现图片的缩小或者放大
- (UIImage *)scaleImageToSize:(CGSize)newSize;





/*垂直翻转*/
- (UIImage *)flipVertical;

/*水平翻转*/
- (UIImage *)flipHorizontal;

/*改变size*/   //压缩图片
- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height;
/*返回一张拉伸不变形的图片 从中间拉伸*/
- (UIImage *)resizableImage;
//crop
- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

//确认image的真实orientation
- (UIImage *)fixOrientation;

- (UIImage *)scaledImageV2WithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;
- (UIImage *)scaledImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;
- (UIImage *)scaledHeadImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight;

// 生成一张指定颜色的图片
+(UIImage*)imageWithColor:(UIColor*)color;

+ (UIImage *)cellBackImage;
+ (UIImage *)cellBackImageGray;
+ (UIImage *)cellBackImageTop;
+ (UIImage *)cellBackImageMiddle;
+ (UIImage *)cellBackImageButtom;
///正方形
+ (UIImage *)placeholderImage_square;
///长方形
+ (UIImage *)placeholderImage_rectangle;
///首页大广告
+ (UIImage *)placeholderImage_bigAdv;
+ (UIImage *)lineImage;
+ (UIImage *)imaginarylineImage;

@end
