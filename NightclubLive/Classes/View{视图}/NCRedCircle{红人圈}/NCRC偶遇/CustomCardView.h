//
//  CustomCardView.h
//  CCDraggableCard-Master
//
//  Created by jzzx on 16/7/9.
//  Copyright © 2016年 Zechen Liu. All rights reserved.
//

#import "LZSwipeableView.h"

@class User,UserTagView;

@interface CustomCardView : LZSwipeableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIButton *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UserTagView *userTagView;

@property (nonatomic, weak) User *model;

- (void)installData:(NSDictionary *)element;
+ (instancetype)customCardView;

@end
