//
//  OrderListCell.m
//  NightclubLive
//
//  Created by RDP on 2017/4/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "OrderListCell.h"
#import "MineModelList.h"



@implementation OrderListCell

- (void)awakeFromNib{
    [super awakeFromNib];

}

- (void)setModel:(OrderListModel *)model
{
    [super setModel:model];

    [_logoIV sd_setImageWithURL:model.image placeholderImage:[UIImage picturePlaceholder]];
    
    _barNameLabel.text = model.merchant.name;
    _seatAndPersonLabel.text = [NSString stringWithFormat:@"%@(%@)",model.tableNo,model.mealNumber];
    _costLabel.text = model.total;
    NSArray *status = @[@"待支付",@"待接单",@"待出品",@"已出品",@"待评价",@"已完成",@"退款中",@"已退款",@"拒单",@"订单取消",@"退单(订单超时)",@"删除"];
    NSString *str = [status stringAtIndex:(model.status - 1)];
    [_stateBtn setTitle:str forState:UIControlStateNormal];
    _packageLabel.text = model.name;
    
    if  (!(model.status == 5)){
        [_stateBtn setBorderColor:APPDefaultColor borderWidth:0.4];
    }
    else{
        [_stateBtn setBorderColor:[UIColor grayColor] borderWidth:0.4];
    }
}
@end
