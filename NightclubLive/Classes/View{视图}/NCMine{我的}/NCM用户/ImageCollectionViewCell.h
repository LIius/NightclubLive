//
//  ImageCollectionViewCell.h
//  NightclubLive
//
//  Created by RDP on 2017/3/11.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectCollectionViewCell.h"
@class PhotoAlbumList;

static NSString *ImageCollectionViewCellID = @"ImageCollectionViewCell";

@interface ImageCollectionViewCell : ObjectCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgIV;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic, weak) PhotoAlbumList *photomodel;
@property (nonatomic, copy) CalkBackBlock selectBlock;
@property (nonatomic, assign) BOOL isAdjust;
@end
