//
//  FollowFanCell.m
//  NightclubLive
//
//  Created by RDP on 2017/4/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "FollowFanCell.h"

#import "MineModelList.h"
#import "BlocksKit+UIKit.h"
@interface FollowFanCell()

@end

@implementation FollowFanCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    @weakify(self);
    
    _logoIV.layer.cornerRadius = 17.5;
    _logoIV.layer.masksToBounds = YES;
    
    [_operationBtn bk_whenTapped:^{
        @strongify(self);
        if (self.followBlock)
            self.followBlock(self.indexPath);

    }];
}

- (void)setTag:(NSInteger)tag{
    
    [super setTag:tag];
    
    if (tag == 0){
        UIColor *color = RGBCOLOR(153, 153, 153);
        [_operationBtn setBorderColor:color borderWidth:1];
        [_operationBtn setTitleColor:color forState:UIControlStateNormal];
        [_operationBtn setTitle:@"已关注" forState:UIControlStateNormal];
        _operationBtn.enabled = NO;
    }
    else{

        [_operationBtn setBorderColor:APPDefaultColor borderWidth:1];
        [_operationBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
        [_operationBtn setTitleColor:APPDefaultColor forState:UIControlStateNormal];
    }
}


- (void)setModel:(FenGZModel *)model{
    
    [super setModel:model];
    
    [_logoIV sd_setImageWithURL:model.profile_photo placeholderImage:[UIImage userPlaceholder]];
    _nameLabel.text = model.user_name;

    if (model.follow && self.tag == 1){
        UIColor *color = RGBCOLOR(153, 153, 153);

        [_operationBtn setBorderColor:color borderWidth:1];
        [_operationBtn setTitleColor:color forState:UIControlStateNormal];
        [_operationBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }
    //_operationBtn.enabled = NO;
}
@end
