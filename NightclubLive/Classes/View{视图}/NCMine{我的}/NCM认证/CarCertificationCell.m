//
//  CarCertificationCell.m
//  NightclubLive
//
//  Created by RDP on 2017/5/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "CarCertificationCell.h"
#import "AuthModel.h"
@implementation CarCertificationCell

- (void)setModel:(CarAuthModel *)model{
    
    [super setModel:model];

    [_carIV sd_setImageWithURL:model.sign placeholderImage:[UIImage picturePlaceholder]];
    
    _carNameLabel.text = model.car_name;
    
    NSString *name = [NSString stringFromeArray:@[@"icon_shenhezhong",@"认证通过",@""] index:model.status];
    _statusIV.image = KGetImage(name);
  //  _passLabel.hidden = !(model.status == 1);
    
    _passLabel.text = [NSString stringFromeArray:@[@"本车辆等待平台认证",@"本车辆已通过夜店网平台认证"] index:model.status];
}

@end
