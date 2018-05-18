//
//  Photo.h
//  NightclubLive
//
//  Created by WanBo on 16/12/1.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Photo : UICollectionViewCell

@property (nonatomic,copy)NSString *caption;

@property (nonatomic,copy)NSString *comment;
@property (nonatomic,strong)NSString *imagename;
@property (nonatomic,strong)NSString *icon;

@end
