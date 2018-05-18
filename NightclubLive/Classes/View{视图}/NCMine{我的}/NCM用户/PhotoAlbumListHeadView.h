//
//  PhotoAlbumListHeadView.h
//  NightclubLive
//
//  Created by RDP on 2017/4/21.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoAlbumList;

static NSString *PhotoAlbumListHeadViewReuseID = @"PhotoAlbumListHeadView";

@interface PhotoAlbumListHeadView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (nonatomic, weak) PhotoAlbumList *model;
@property (nonatomic, weak) NSIndexPath *indexPath;
@property (nonatomic, copy) CalkBackBlock allBlock;
@property (nonatomic, copy) CalkBackBlock deleteBlock;
@property (nonatomic, assign) BOOL hiddenOperation;
@end
