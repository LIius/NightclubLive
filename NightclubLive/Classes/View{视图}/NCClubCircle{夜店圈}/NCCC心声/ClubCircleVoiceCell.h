//
//  ClubCircleVoiceCell.h
//  NightclubLive
//
//  Created by WanBo on 16/12/2.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "VoiceListModel.h"
#import "ObjectTableViewCell.h"

@interface ClubCircleVoiceCell : ObjectTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *commentLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

- (void)bindModel:(VoiceListModel *)model;


@end
