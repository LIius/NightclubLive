//
//  AddressBookCell.m
//  NightclubLive
//
//  Created by RDP on 2017/4/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AddressBookCell.h"
#import "AddressBookModel.h"

@interface AddressBookCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@property (assign, nonatomic) BOOL isFriend;

@end

@implementation AddressBookCell


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

- (void)configureDataWithModel:(id)model isFriend:(BOOL)isFriend
{
    self.isFriend = isFriend;
    
    if (isFriend) {
        _actionBtn.hidden = YES;
        _locationBtn.hidden = NO;
    } else {
        _actionBtn.hidden = NO;
        _locationBtn.hidden = YES;
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    [super setIndexPath:indexPath];
    
    NSString *imagename = indexPath != nil ? @"icon_checkin" : @"icon_checkoff";
    
    _checkIV.image = KGetImage(imagename);
}

- (void)setAddressModel:(AddressBookModel *)addressModel
{
    _addressModel = addressModel;

    self.nameLab.text = addressModel.name;
    [self.headerImg sd_setImageWithURL:nil placeholderImage:KGetImage(@"icon_tongxinlu")];
    self.actionBtn.hidden = NO;
    
    NSString *imagename = [addressModel.isChoose boolValue] ? @"icon_checkin" : @"icon_checkoff";
    _checkIV.image = KGetImage(imagename);
}

@end
