//
//  PackageDetailsView.m
//  NightclubLive
//
//  Created by RDP on 2017/6/29.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "PackageDetailsView.h"
#import "UIView+ScottAlertView.h"
#import "PackageDetailsCell.h"
#import "ClubCircleModelList.h"
#import "MineModelList.h"

@interface PackageDetailsView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *backView;
/** 模型 */
@property (nonatomic, strong) NSArray *model;
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *packNewPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@end

@implementation PackageDetailsView
@dynamic model;

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
    
    _backView.layer.cornerRadius = 5;
    _backView.layer.masksToBounds = YES;
    
    //注册
    
  //  [_tableView registerClass:[PackageDetailsCell class] forCellReuseIdentifier:PackageDetailsCellReuseID];
}

- (IBAction)closeClick:(id)sender {
    
    [self dismiss];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.model.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return TABLE_HEAD_FOOT_SPACE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 43;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PackageDetailsCell *cell = [PackageDetailsCell dequeueReusableWithTableView:tableView];
    
    cell.model = self.model[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)reloadDataToView{
    
    _nameLabel.text = _packagemodel.name;
    [_logoIV sd_setImageWithURL:_packagemodel.imageURL];
    _contentLabel.text = _packagemodel.shortIntr;
    _packNewPriceLabel.text = [NSString stringWithFormat:@"¥ %@", _packagemodel.price];
    NSString *market =  [NSString stringWithFormat:@"原价¥%@", _packagemodel.originalPrice];
    
    NSMutableAttributedString *attributeMarket = [[NSMutableAttributedString alloc] initWithString:market];
    [attributeMarket setAttributes:@{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle], NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,market.length)];
    
    
    _oldPriceLabel.attributedText = attributeMarket;
    
    [self.tableView reloadInMain];
    
}

@end
