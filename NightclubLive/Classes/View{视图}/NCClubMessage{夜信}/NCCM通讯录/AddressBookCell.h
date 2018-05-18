//
//  AddressBookCell.h
//  NightclubLive
//
//  Created by RDP on 2017/4/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectTableViewCell.h"

@class  AddressBookModel;

@interface AddressBookCell : ObjectTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UIImageView *checkIV;

@property (nonatomic,strong)AddressBookModel *addressModel;

+ (CGFloat)cellHeight;
- (void)configureDataWithModel:(id)model isFriend:(BOOL)isFriend;

@end
