//
// AddressBookCellSectionOne.m
//  NightclubLive
//
//  Created by RDP on 2017/4/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AddressBookCellSectionOne.h"
#import "AddressBookModel.h"

@interface AddressBookCellSectionOne()
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (assign, nonatomic) BOOL isFriend;

@end

@implementation AddressBookCellSectionOne

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _headerImg.layer.masksToBounds = YES;
    _headerImg.layer.cornerRadius = 17.5;
}

+ (CGFloat)cellHeight
{
    return 50;
}

- (void)setUserModel:(NIMUser *)userModel
{
    _userModel = userModel;
    
    _nameLab.text = userModel.alias;
    
    if (!_nameLab.text){
        _nameLab.text =  userModel.userInfo.nickName;
    }
    
    [_headerImg sd_setImageWithURL:URL(userModel.userInfo.avatarUrl) placeholderImage:[UIImage userPlaceholder]];
}


@end
