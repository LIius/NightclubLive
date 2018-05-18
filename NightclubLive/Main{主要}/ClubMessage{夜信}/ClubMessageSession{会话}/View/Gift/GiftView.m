//
//  GiftView.m
//  NightclubLive
//
//  Created by RDP on 2017/3/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GiftView.h"
#import "GiftCollectionViewCell.h"
#import "GlobalModel.h"
#import "RDPDataPickView.h"
#import "UIAlertController+Factory.h"
#import "UIWindow+CurrentViewController.h"
#import "GiftCountView.h"
#import "ScottAlertController.h"
#import "UIView+ScottAlertView.h"

@interface GiftView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, weak) NSArray *model;
/** 发送数量 */
@property (nonatomic, assign) NSInteger sendNum;
/** 送礼物选定的路径 */
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@end

@implementation GiftView
@dynamic model;

//+ (instancetype)giftView{
//    
//    GiftView *view = [[[NSBundle mainBundle] loadNibNamed:@"GiftView" owner:nil options:nil] firstObject];
//
//    [view setLineWithButton:view.rechargeBtn];
//    [view setLineWithButton:view.countBtn];
//    
//    [view.giftCollectionView registerClass:[GiftCollectionViewCell class] forCellWithReuseIdentifier:GiftCollectionViewCellReuseID];
//    view.giftCollectionView.pagingEnabled = YES;
//    return view;
//}


- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setLineWithButton:self.rechargeBtn];
    [self setLineWithButton:self.countBtn];
    [self.giftCollectionView registerClass:[GiftCollectionViewCell class] forCellWithReuseIdentifier:GiftCollectionViewCellReuseID];
    self.giftCollectionView.pagingEnabled = YES;
}

- (void)setLineWithButton:(UIButton *)btn{
    
    NSString *title = btn.titleLabel.text;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [btn setAttributedTitle:str forState:UIControlStateNormal];
}

- (void)show{
    //设置初始数量
    self.sendNum = 1;
 //   self.sendBtn.layer.cornerRadius = self.sendBtn.height * 0.5;
    
    float pageCountFloat = self.model.count / 8.0;
    int pageCountInt = ceilf(pageCountFloat);
    _pageControl.numberOfPages = pageCountInt;
    _giftCollectionView.contentSize = CGSizeMake(pageCountInt * SCREEN_WIDTH, 0);
    _giftCollectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, SCREEN_WIDTH / 1);
    _giftCollectionView.pagingEnabled = YES;
    [self layoutIfNeeded];
    
    self.sendNum = 1;

    [_giftCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition: UICollectionViewScrollPositionTop];

    ScottAlertViewController *ac = [ScottAlertViewController alertControllerWithAlertView:self preferredStyle:ScottAlertControllerStyleActionSheet];
    ac.tapBackgroundDismissEnable = YES;
    [[ShareWindow zf_currentViewController] presentViewController:ac animated:YES completion:nil];
    
    ac.dismissCompleteBlock = ^{
        if (self.closeBlock)
            self.closeBlock(nil);
    };
}

- (void)close{
    [self dismiss];
    [self removeFromSuperview];
}

#pragma mark - Setter

- (void)setSendNum:(NSInteger)sendNum{
    
    
    if (!(sendNum >= 1 && sendNum <= 2000)){
        ShowError(@"数值输入错误(1-2000)");
        return;
    }
    
    _sendNum = sendNum;
    
    [_countBtn setAttributedTitle:nil forState:UIControlStateNormal];
    NSString *title = [NSString stringWithFormat:@"数量：%ld",sendNum];
    _countBtn.titleLabel.text = title;
    [_countBtn setTitle:title forState:UIControlStateNormal];

    
    if (_selectNumBlock)
        _selectNumBlock(@(sendNum));
    
    [self jsSumPrice];
}


- (void)setSelectIndexPath:(NSIndexPath *)selectIndexPath{
    
    _selectIndexPath = selectIndexPath;
    
    [self jsSumPrice];
}

- (void)jsSumPrice{
    
    
    GiftModel * m = self.model[_selectIndexPath.row];
    
    NSString *moneyText = [NSString stringWithFormat:@"%ld",[m.night_bit integerValue] * _sendNum];
    
    self.moneyLabel.text = moneyText;
    
}

#pragma mark - Button Click


- (IBAction)sendClick:(id)sender {
    
    if (_sendBlock)
        _sendBlock(_selectIndexPath);
}


- (IBAction)countClick:(id)sender {
    
    GiftCountView *countView = [GiftCountView initFromXIB];
    
    countView.okBlock = ^(id param) {
        
        if (self.selectNumBlock){
            self.selectNumBlock(param);
        }
        
        self.sendNum = [param integerValue];
    };
    
    ScottAlertViewController *ac = [ScottAlertViewController alertControllerWithAlertView:countView preferredStyle:ScottAlertControllerStyleAlert];
    ac.tapBackgroundDismissEnable = YES;
    [[ShareWindow zf_currentViewController] presentViewController:ac animated:YES completion:nil];
    countView.count = self.sendNum;
}

#pragma mark - UICollection Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.model.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GiftCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GiftCollectionViewCellReuseID forIndexPath:indexPath];
    
    cell.model = self.model[indexPath.row];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self layoutIfNeeded];
    CGFloat width = (collectionView.width - 3) / 4;
    CGFloat height = (collectionView.height - 1) / 2;
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 1.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.selectIndexPath != indexPath){
        self.selectIndexPath = indexPath;
        self.sendNum = 1;
    }
    else{
        self.sendNum += 1;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    NSInteger currentIndex = (self.giftCollectionView.contentOffset.x + self.giftCollectionView.width * 0.5) / self.giftCollectionView.width;
    
    self.pageControl.currentPage = currentIndex;
}


@end
