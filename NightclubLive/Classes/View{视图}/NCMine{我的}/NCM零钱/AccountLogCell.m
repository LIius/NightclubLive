
//
//  AccountLogCell.m
//  NightclubLive
//
//  Created by rdp on 2017/5/25.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AccountLogCell.h"
#import "MineModelList.h"


@implementation AccountLogCell

- (void)setModel:(AccountLogModel *)model{
    [super setModel:model];
    
    _timeLabel.text = model.create_time.YMDSlashString;
    
    NSArray *strArray = @[@"icon_giftincome",@"icon_jiushui",@"icon_moneyincome",@"icon_buyoutcome",@"icon_yiebiteoutcome",@"icon_moneyincome"];
    NSString *str = [strArray stringAtIndex:model.record_type];
    NSString *typeimage = str;
    
    NSArray *strArray2 = @[@"收获礼物",@"酒水分成",@"提现",@"消费订单",@"兑换夜比特",@"分佣获利"];
    NSString *str2 = [strArray2 stringAtIndex:model.record_type];
    NSString *typeName =  str2;
                           
    if (model.record_type == RecordTypedWithdraw){//提现分两种
        NSArray *strArray3 = @[@"icon_weixinoutcome",@"icon_alipayoutcome"];
        NSString *str3 = [strArray3 stringAtIndex:(model.from_pay - 1)];
        typeimage = str3;
        
        NSArray *strArray4 = @[@"提现(支付宝)",@"提现(微信)"];
        NSString *str4 = [strArray4 stringAtIndex:(model.from_pay-1)];
        typeName = str4;
    }
    
    _typeIV.image = KGetImage(typeimage);
    _logNameLabel.text = typeName;

    NSString *rmb = [NSString stringWithFormat:@"%@%@零钱",[NSString stringFromeArray:@[@"+",@"-"] index:self.tag],model.rmb_value];
    _moneyLabel.text = rmb;
}

@end
