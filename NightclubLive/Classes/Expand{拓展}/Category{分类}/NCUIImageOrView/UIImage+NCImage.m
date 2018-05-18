//
//  UIImage+NCImage.m
//  NightclubLive
//
//  Created by CodeRiding on 2017/11/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "UIImage+NCImage.h"
#import <Photos/Photos.h>

@implementation UIImage (NCImage)

#pragma makr - 系统常用图片配置
+ (UIImage *)userPlaceholder{
    
    
    return [UIImage imageNamed:@"icon_headpictureblank"];
}

+ (UIImage *)picturePlaceholder{
    
    return [UIImage imageNamed:@"icon_pictureblank"];
}

+ (UIImage *)praiseImage{
    
    return KGetImage(@"icon_赞");
}

+ (UIImage *)nopraiseImage{
    
    return KGetImage(@"红人圈-点赞");
}

+ (UIImage *)praiseWithType:(NSInteger)type{
    
    if (type == 1)
        return [self praiseImage];
    else
        return [self nopraiseImage];
}

+ (UIImage *)sexImageWithType:(NSInteger)type{
    
    NSString *imageName = [NSString stringFromeArray:@[@"红人圈-头像-女图标",@"红人圈-头像-男图标"] index:type];
    
    return [UIImage imageNamed:imageName];
}

+ (UIImage *)sex2ImageWithType:(NSInteger)type{
    
    NSString *imageName = [NSString stringFromeArray:@[@"icon_female",@"icon_male"] index:type];
    
    return [UIImage imageNamed:imageName];
}





#pragma mark - 与相册相关
+ (void)getImageFromPHAsset:(NSArray *)assets Complete:(void (^)(NSArray *))result{
    
    NSMutableArray *array = [NSMutableArray array];
    
    __block NSData * data;
    
    for (PHAsset *asset in assets){
        
        if (asset.mediaType == PHAssetMediaTypeImage) {
            PHImageRequestOptions * options = [[PHImageRequestOptions alloc] init];
            options.version = PHImageRequestOptionsVersionCurrent;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            options.synchronous = YES; [[PHImageManager defaultManager] requestImageDataForAsset: asset options: options resultHandler: ^(NSData * imageData, NSString * dataUTI, UIImageOrientation orientation, NSDictionary * info) {
                data = [NSData dataWithData: imageData];
            }];
        }
        
        UIImage *image = [UIImage imageWithData:data];
        [array addObject:image];
    }
    
    
    result([array copy]);
}



#pragma mark - 根据目标视图大小获得新的图片尺寸
- (UIImage *)imageSizeTransformToTargetView:(UIView *)targetView
{
    UIImage *scaleImage=[[UIImage alloc]init];
    
    if (targetView.width/targetView.height > self.size.width/self.size.height)
    {
        CGSize imageSize = self.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        CGFloat targetWidth = targetView.width;
        CGFloat targetHeight = height / (width / targetWidth);
        CGSize size = CGSizeMake(targetWidth, targetHeight);
        scaleImage=[self scaleImageToSize:size];
    }else{
        
        CGSize imageSize = self.size;
        CGFloat width = imageSize.width;
        CGFloat height = imageSize.height;
        CGFloat targetHeight = targetView.height;
        CGFloat targetWidth = width / (height / targetHeight);
        CGSize size = CGSizeMake(targetWidth, targetHeight);
        scaleImage=[self scaleImageToSize:size];
    }
    
    CGFloat targetWidth=targetView.width;
    CGFloat destionX = 0;
    CGFloat destionY = 0;
    
    if (scaleImage.size.width>targetWidth){
        destionX=(scaleImage.size.width-targetWidth)/2;
    }else{
        destionX=0;
    }
    if (scaleImage.size.height>targetView.height)
    {
        destionY=(scaleImage.size.height-targetView.height)/2;
    }else{
        destionY=0;
    }
    
    CGRect cropRect =CGRectMake(destionX,destionY,targetView.width ,targetView.height);
    cropRect = CGRectMake(cropRect.origin.x * scaleImage.scale,
                          cropRect.origin.y * scaleImage.scale,
                          cropRect.size.width * scaleImage.scale,
                          cropRect.size.height * scaleImage.scale);
    CGImageRef imagePartRef = CGImageCreateWithImageInRect(scaleImage.CGImage, cropRect);
    scaleImage = [UIImage imageWithCGImage:imagePartRef];
    CGImageRelease(imagePartRef);
    
    return scaleImage;
}

- (UIImage *)scaleImageToSize:(CGSize)newSize
{
    CGRect scaledImageRect = CGRectZero;
    
    CGFloat aspectWidth = newSize.width / self.size.width;
    CGFloat aspectHeight = newSize.height / self.size.height;
    CGFloat aspectRatio = MIN ( aspectWidth, aspectHeight );
    
    scaledImageRect.size.width = self.size.width * aspectRatio;
    scaledImageRect.size.height = self.size.height * aspectRatio;
    scaledImageRect.origin.x = (newSize.width - scaledImageRect.size.width) / 2.0f;
    scaledImageRect.origin.y = (newSize.height - scaledImageRect.size.height) / 2.0f;
    
    UIGraphicsBeginImageContextWithOptions( newSize, NO, 0.0);
    [self drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

#pragma mark - 用颜色创建背景图片
+ (UIImage*)imageWithColor:(UIColor*)color
{
    CGSize imageSize = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - 圆形图
-(instancetype)circleImage
{
    //开启图形上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    //描述裁剪区域
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.size.width, self.size.width)];
    //设置裁剪区域
    [path addClip];
    //画图形
    [self drawAtPoint:CGPointZero];
    //取出图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 圆形图
+(instancetype)circleWithImageName:(NSString *)name
{
    return [[self imageNamed:name] circleImage];
}

#pragma mark - 指定高度按比例缩放
-(UIImage *)imageCompressToTargetHeigth:(NSInteger)targetHeight withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = width / (height / targetHeight);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 指定宽度按比例缩放
-(UIImage *)imageCompressToTargetWidth:(NSInteger )targetWidth withSourceImage:(UIImage *)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 等比例缩放
- (UIImage*)imageScaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1){
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }else{
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    width = width*radio;
    height = height*radio;
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}






/*翻转*/
- (UIImage *)flip:(BOOL)isHorizontal {
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    if (&UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    } else {
        //        UIGraphicsBeginImageContext(rect.size);
    }
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClipToRect(ctx, rect);
    if (isHorizontal) {
        CGContextRotateCTM(ctx, M_PI);
        CGContextTranslateCTM(ctx, -rect.size.width, -rect.size.height);
    }
    CGContextDrawImage(ctx, rect, self.CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/*垂直翻转*/
- (UIImage *)flipVertical {
    return [self flip:NO];
}
/*水平翻转*/
- (UIImage *)flipHorizontal {
    return [self flip:YES];
}
//压缩图片
- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height {
    CGSize size = CGSizeMake(width, height);
    if (&UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    } else {
        //        UIGraphicsBeginImageContext(size);
    }
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/*返回一张拉伸不变形的图片 从中间拉伸*/
- (UIImage *)resizableImage
{
    CGFloat edgeW = self.size.width * 0.5;
    CGFloat edgeH = self.size.height * 0.5;
    return [self stretchableImageWithLeftCapWidth:edgeW topCapHeight:edgeH];
}
//crop
- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect) ;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, rect, imageRef);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

//调整方向
- (UIImage *)fixOrientation{
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (UIImage *)scaledImageV2WithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight{
    CGRect rect = CGRectIntegral(CGRectMake(0, 0, aWidth,aHeight));
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)scaledImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
    aWidth = aWidth > self.size.width ? self.size.width : aWidth;
    aHeight = aHeight > self.size.height ? self.size.height : aHeight;
    
    CGRect rect = CGRectIntegral(CGRectMake(0, 0, aWidth,aHeight));
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)scaledHeadImageWithWidth:(CGFloat)aWidth andHeight:(CGFloat)aHeight
{
    CGSize endSize = CGSizeMake(aWidth, aHeight);
    CGRect backRect = CGRectMake(0, 0, aWidth, aHeight);
    float imagex =0;
    float imagey =0;
    
    BOOL needBack = NO;
    if (self.size.width > self.size.height) {
        aWidth = aWidth > self.size.width ? self.size.width : aWidth;
        imagex =0;
        float ff = self.size.width /aWidth;
        aHeight = self.size.height/ff;
        imagey = (aWidth-aHeight)/2;
        needBack =YES;
        backRect = CGRectMake(0, 0, aWidth, aWidth);
        endSize = CGSizeMake(aWidth, aWidth);
    }
    else if(self.size.width < self.size.height)
    {
        aHeight = aHeight > self.size.height ? self.size.height : aHeight;
        imagey =0;
        float ff = self.size.height /aHeight;
        aWidth = self.size.width/ff;
        imagex = (aHeight-aWidth)/2;
        needBack =YES;
        backRect = CGRectMake(0, 0, aHeight, aHeight);
        endSize = CGSizeMake(aHeight, aHeight);
    }
    else
    {
        aWidth = aWidth > self.size.width ? self.size.width : aWidth;
        aHeight = aHeight > self.size.height ? self.size.height : aHeight;
    }
    CGRect rect = CGRectMake(imagex, imagey, aWidth,aHeight);
    UIGraphicsBeginImageContext(endSize);  //rect.size);
    
    if (needBack) {
        // get a reference to that context we created
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        UIColor *color = [UIColor blackColor];
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextAddRect(context, backRect);
        CGContextDrawPath(context,kCGPathFill);
    }
    [self drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+ (UIImage *)lineImage {
    UIImage *image = [UIImage imageNamed:@"line"];
    return image;
}

+ (UIImage *)imaginarylineImage {
    UIImage *image = [UIImage imageNamed:@"imaginaryline"];
    return image;
}

// 生成一张指定颜色的图片
+(UIImage*)imageWithColor2:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

+ (UIImage *)cellBackImage {
    UIImage *image = [UIImage imageNamed:@"cellBackgroundColor"];
    image =[image resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0) resizingMode:UIImageResizingModeStretch];
    return image;
}

+ (UIImage *)cellBackImageGray {
    UIImage *image = [UIImage imageNamed:@"cellBackgroundColorGray"];
    image =[image resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0) resizingMode:UIImageResizingModeStretch];
    return image;
}

+ (UIImage *)cellBackImageTop {
    UIImage *image = [UIImage imageNamed:@"cellBackgroundColor_top"];
    image =[image resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0) resizingMode:UIImageResizingModeStretch];
    return image;
}

+ (UIImage *)cellBackImageMiddle {
    UIImage *image = [UIImage imageNamed:@"cellBackgroundColor_mid"];
    image =[image resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0) resizingMode:UIImageResizingModeStretch];
    return image;
}

+ (UIImage *)cellBackImageButtom {
    UIImage *image = [UIImage imageNamed:@"cellBackgroundColor_buttom"];
    image =[image resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 4.0, 4.0, 4.0) resizingMode:UIImageResizingModeStretch];
    return image;
}
///正方形
+ (UIImage *)placeholderImage_square {
    UIImage * image = [UIImage imageNamed:@"icon3"];
    return image;
}
///长方形
+ (UIImage *)placeholderImage_rectangle {
    UIImage * image = [UIImage imageNamed:@"icon3"];
    return image;
}
///首页大广告
+ (UIImage *)placeholderImage_bigAdv {
    UIImage * image = [UIImage imageNamed:@"placeholderImage_adv"];
    return image;
}

@end
