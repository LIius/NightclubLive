//
//  AddressBookCell.m
//  NightclubLive
//
//  Created by SuperDanny on 2017/1/17.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "BlacklistCell.h"
#import "UIImageView+SDWebImage.h"

@interface BlacklistCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@end

@implementation BlacklistCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _headerImg.layer.masksToBounds = YES;
    _headerImg.layer.borderWidth = 1.5;
    _headerImg.layer.borderColor = UIColorFromRGB(0xc7699a).CGColor;
    _headerImg.layer.cornerRadius = 17.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (CGFloat)cellHeight {
    return 50;
}

- (void)configureDataWithModel:(id)model {
    
}

- (void)setNUserModel:(NIMUser *)nUserModel
{
    _nUserModel = nUserModel;
    
    _nameLab.text = nUserModel.userInfo.nickName;
//    [_headerImg setImage:<#(UIImage * _Nullable)#>];
    [_headerImg nim_setImageWithURL:URL(nUserModel.userInfo.avatarUrl) placeholderImage:[UIImage userPlaceholder]];
//    [_headerImg sd_setImageWithURL:URL(nUserModel.userInfo.avatarUrl) placeholderImage:[UIImage userPlaceholder]];
//    DLog(@"%@------%@",nUserModel.avatarUrlString,nUserModel.showName);
//    [_headerImg sd_setImageWithURL:[NSURL URLWithString:nUserModel.avatarUrlString] placeholderImage:[UIImage userPlaceholder]];
//    _headerImg.image = nUserModel.avatarImage;
//    _nameLab.text = nUserModel.showName;
}

//- (void)setModel:(NIMKitInfo *)model
//{
//    [super setModel:model];
//    
//    [_headerImg sd_setImageWithURL:URL(model.userInfo.avatarUrl) placeholderImage:[UIImage userPlaceholder]];
//    _nameLab.text = model.userInfo.nickName;
//}

@end
