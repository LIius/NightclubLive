//
//  ClubCircleDynamicCell.m
//  NightclubLive
//
//  Created by WanBo on 16/12/2.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "ClubCircleDynamicCell.h"
#import "NSDate+Utilities.h"
#import "DynamicListModel.h"

#import "DynamicImageItemCollectionViewCell.h"
#import "NSDate+LSCore.h"


#import "UserTagView.h"
#import "CMPhoto3DFlowLayout.h"


#import "BlocksKit+UIKit.h"
@interface ClubCircleDynamicCell()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
{
    DynamicListModelFrame *_modelFrame;
}

/** gallery 布局 */
@property (nonatomic, strong) CMPhoto3DFlowLayout *layout3D;
/** flow 布局 */
@property (nonatomic, strong) UICollectionViewFlowLayout *layoutFlow;
/** 布局模式 */
@property (nonatomic, assign) NSInteger layoutType;

@end

@implementation ClubCircleDynamicCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    @weakify(self);
    //头像点击
    [_userlogoImageView bk_whenTapped:^{
        @strongify(self);
        if (self.logoClickBlock)
            self.logoClickBlock(self.indexPath);
    }];
    
    [_giftBtn bk_whenTapped:^{
        @strongify(self);
        if (self.sendGiftBlock)
            self.sendGiftBlock(self.indexPath);
    }];
    
    [_appointmentBtn bk_whenTapped:^{
        @strongify(self);
        if (self.appointmentBlock)
            self.appointmentBlock(self.indexPath);
    }];
    
    [_voiceBtn bk_whenTapped:^{
        @strongify(self);
        if (self.voiceBlock){
            self.voiceBlock(self.indexPath);
        }
    }];
    
    [_voiceView bk_whenTapped:^{
        @strongify(self);
        if (self.voiceBlock){
            self.voiceBlock(self.indexPath);
        }
    }];
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self.dynamicCollectionView registerClass:[DynamicImageItemCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([DynamicImageItemCollectionViewCell class])];
    }
    
    return self;
}

- (void)bindModel:(DynamicListModelFrame *)modelFrame
{
    if (modelFrame == _modelFrame)
        return;
    
    _modelFrame = modelFrame;
    
    DynamicListModel *model = modelFrame.model;

    
    _sexIV.image = [UIImage sex2ImageWithType:model.user.sex];
    //改变内容高度
    CGFloat imgContentHeight = modelFrame.imageContenHieght;
    [_dynamicCollectionView layoutIfNeeded];
    [_dynamicCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_userlogoImageView.mas_bottom).with.offset(28);
        make.height.offset(imgContentHeight);
        make.width.equalTo(self);
        make.left.with.right.mas_equalTo(0);
    }];

    
    [_userlogoImageView sd_setImageWithURL:model.user.profilePhoto placeholderImage:[UIImage userPlaceholder]];
    
    _heightCons.constant = 281*SCREEN_H_POINT;

    _userNameLable.text = model.user.userName;
    
  //  _distanceLable.text = [NSString stringWithFormat:@"%@",model.district];
    NSString *address = [NSString stringWithFormat:@"%@%@", model.provice, model.city];
    _addressLable.text = address.length>0?address:@"未知";
    _contentLable.text = model.content.length > 0 ? model.content : @"";
 //   _praiseLable.text = [NSString stringWithFormat:@"点赞 (%d)",model.praise];

   // int distance =  (int)[self getDintance:location]/1000;
    _distanceLable.text = model.district;

    _criticismLable.text = [NSString stringWithFormat:@"评论 (%@)",model.criticismCount];
    _praiseLable.textColor = model.ispraise ? [UIColor redColor] : [UIColor grayColor];
    if(model.images.count==0){
        _heightCons.constant = 0;

    }
    
    _timeLable.text = model.timeGap;
  
    [_praiseBtn setTitle:[NSString stringWithFormat:@"  点赞(%d)",model.praise] forState:UIControlStateNormal];
    [_praiseBtn setTitleColor:model.ispraise ? APPDefaultColor : [UIColor lightGrayColor] forState:UIControlStateNormal];
    [_praiseBtn setImage:[UIImage praiseWithType:model.ispraise] forState:UIControlStateNormal];

    
    _userTagView.contentAlignType = 1;
    _userTagView.model = model;
    
    
    _appointmentBtn.hidden = !model.user.isbound_bar;
    
    //判断
    //三种情况1.有语音&&有文本。2,语音不存在，单单有文本。3,单单存在语音
    
    //情况1
    if (model.voicelen && model.content.length)
    {
        //存在语音
        _voiceBtn.hidden = NO;
        [_voiceBtn mas_updateConstraints:^(MASConstraintMaker *make)
        {
            make.left.equalTo(_voiceBtn.superview).offset(18);
        }];
        _voiceView.hidden = YES;
    }
    
    // 情况2
    if (!model.voicelen){
        _voiceBtn.hidden = YES;
        _voiceView.hidden = YES;
        [_voiceBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_voiceBtn.superview).offset(-26.5);
           // make.right.equalTo(_voiceBtn.superview).offset(-11.5);
        }];
    }
    
    // 情况三
    if (model.voicelen && model.content.length == 0){
        _voiceBtn.hidden = YES;
        _voiceView.hidden = NO;
        _voicelenLabel.text = [model.duration getMMSS];
    }
    
    [_contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(modelFrame.contentHeight);
    }];
    
     [self.dynamicCollectionView reloadData];

    // 如果是超过三张图片默认滚动到第二个
//    if (_dynamicCollectionView)
//    {
//        if (model.images.count == 3 || model.images.count == 4)
//        {
//            [_dynamicCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//        }else if (model.images.count > 3)
//        {
//            [_dynamicCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//        }
//    }
    

//    [_voiceBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_contentLable.mas_top);
//    }];
}

//+ (CGFloat)cellHeightWithObj:(id)obj{
//    
//    CGFloat cellHeight = 0;
//    if ([obj isKindOfClass:[DynamicListModel class]]) {
//        DynamicListModel *model = (DynamicListModel *)obj;
//        CGFloat curWidth = kScreenWidth-14*2;
//        //无图
//        if (model.images.count==0) {
//            cellHeight += 41+16+7 +351*SCREEN_H_POINT- 281*SCREEN_H_POINT+ [model.content getHeightWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(curWidth, CGFLOAT_MAX)];
//
//        }else{//有图片
//           // cellHeight += 41+16+7 +351*SCREEN_H_POINT + [model.content getHeightWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(curWidth, CGFLOAT_MAX)];
//            
//            NSInteger count = 1;
//            
//            if (model.images.count > 0 && model.images.count < 3)
//                count = 1;
//            else if (model.images.count >= 2 && model.images.count < 6)
//                count = 2;
//            else
//                count = 3;
//        
//            CGFloat imgWidth = (([UIScreen mainScreen].bounds.size.width - 40) / 3) * count;
//            
//            cellHeight += (41 + 16 + 7 + [model.content getHeightWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(curWidth, CGFLOAT_MAX)] + imgWidth);
//        }
//    }
//    return cellHeight;
//}

- (CGFloat)getDintance:(CLLocation *)location
{
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:22.52  longitude:22.52];
    CLLocationDistance kilometers = [location distanceFromLocation:location2];
    return kilometers;
}

#pragma mark - UIColloection Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    DynamicListModel *model =  _modelFrame.model;
    
    return model.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicListModel *model = _modelFrame.model;
    DynamicImageItemCollectionViewCell * currentCell = (DynamicImageItemCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    for (UIView *view in currentCell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    DynamicImageItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([DynamicImageItemCollectionViewCell class]) forIndexPath:indexPath];
    
 //   cell.backgroundColor = [UIColor blueColor];
   // [cell.itemImageView sd_setImageWithURL:URL(model.images[indexPath.row]) placeholderImage:[UIImage picturePlaceholder] options:SDWebImageProgressiveDownload];
    
    if (indexPath.row < model.images.count)
    {
        [cell.itemImageView sd_setImageWithURL:URL(model.images[indexPath.row]) placeholderImage:[UIImage picturePlaceholder] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell.itemImageView autoAdjustWidth];
        }];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_imageClickBlock)
    {
        _imageClickBlock([NSIndexPath indexPathForRow:indexPath.row inSection:self.tag]);
    }
}

#pragma mark - 设置进度
- (void)setPlayStateImageWithTag:(NSInteger)tag
{
    if (tag == 2)
    {
        NSArray *animationImage = @[KGetImage(@"play1"),KGetImage(@"play2"),KGetImage(@"play3"),KGetImage(@"play4")];
        
        [_playBtn setAnimationImages:animationImage];
        [_playBtn setAnimationImages:animationImage];
        [_playBtn setAnimationRepeatCount:0];
        [_playBtn setAnimationDuration:1.5];
        [_playBtn startAnimating];
    }
    else if (tag == 0 || tag == 3){
        [_playBtn stopAnimating];
        [_playBtn setImage:KGetImage(@"icon_voice")];
    }
}

#pragma mark - Gest Action
#pragma mark - Button click
- (IBAction)praiseClick:(id)sender
{
    if (_praiseBlock)
        _praiseBlock(nil);
}

#pragma mark - Getter
-  (CMPhoto3DFlowLayout *)layout3D{
    if (!_layout3D){
        CMPhoto3DFlowLayout *layout3D = [[CMPhoto3DFlowLayout alloc] init];
        layout3D.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout3D = layout3D;
    }
    return _layout3D;
}

- (UICollectionViewFlowLayout *)layoutFlow{
    if (!_layoutFlow){
        UICollectionViewFlowLayout *layoutflow = [[UICollectionViewFlowLayout alloc] init];
        layoutflow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layoutflow.minimumLineSpacing = 8;
        layoutflow.minimumInteritemSpacing = 8;

        layoutflow.sectionInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _layoutFlow = layoutflow;
    }
    return _layoutFlow;
}

#pragma mark - Public Method
- (void)switchLayout:(NSInteger)tag imageCount:(NSInteger)count
{
    [_dynamicCollectionView.collectionViewLayout invalidateLayout];
    
    // 切换布局类型
    if (tag == 0)
    {
        CGFloat width;
        CGFloat height;
        if (count == 1){
            width = SCREEN_WIDTH * (343.0/375.0);
            height = width * (200./343.0);
            self.layoutFlow.itemSize = CGSizeMake(width, height);
        }
        else{
            width = SCREEN_WIDTH * (120.0 / 375.0);
            height = width;
            self.layoutFlow.minimumLineSpacing = 3;
            self.layoutFlow.minimumInteritemSpacing = 3;
            self.layoutFlow.itemSize = CGSizeMake(width, height);
        }
        
        [_dynamicCollectionView setCollectionViewLayout:self.layoutFlow];
    }
    else{
        // 图片超过3张
        [_dynamicCollectionView setCollectionViewLayout:self.layout3D animated:NO];
     //   [_dynamicCollectionView reloadDataInMain];
        
    }
}

@end
