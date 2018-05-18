//
//  Campaign.h
//  NightclubLive
//
//  Created by RDP on 2017/2/28.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ModelObject.h"
#import "User.h"

@class User;
@interface CampaignModel : ModelObject

@property (nonatomic, copy) NSString *cover_url;

@property (nonatomic, copy) NSDate *end_time;

@property (nonatomic, copy) NSString* ID;

@property (nonatomic, copy) NSString *video_url;

@property (nonatomic, strong) NSURL *describe_url;

@property (nonatomic, strong) NSURL *picture_url;

@property (nonatomic, assign) NSInteger campaign_state;

@property (nonatomic, assign) NSInteger user_id;

@property (nonatomic, strong) NSDate *start_time;

@property (nonatomic, strong) NSDate *create_time;

@property (nonatomic, copy) NSString *campaign_title;

@property (nonatomic, copy) NSString *campaign_slogan;


@end

@interface  CampaignJoinListModel: ModelObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *list_title;

@property (nonatomic, strong) NSURL *list_video_url;

@property (nonatomic, copy) NSString *list_duration;

@property (nonatomic, copy) NSString *list_latitude;

@property (nonatomic, strong) NSString *list_img_url;

@property (nonatomic, strong) NSArray *contentImages;

@property (nonatomic, assign) NSInteger election_campaign_id;

@property (nonatomic, copy) NSString *list_longitude;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, assign) NSInteger usercp;

@property (nonatomic, assign) NSInteger list_state;

@property (nonatomic, copy) NSString *list_create_time;

@property (nonatomic, strong) NSURL *list_picture_url;

@property (nonatomic, copy) NSString *list_details;

@property (nonatomic, copy) NSString *list_city;

@property (nonatomic, strong) DataUser *user;

@property (nonatomic, copy) NSString *ranking_num;

@property (nonatomic, copy) NSString *difference_value;

@end

@interface CampaignJoinGiftListModel : ModelObject


@property (nonatomic, assign) NSInteger usercp;

@property (nonatomic, copy) NSString *describe_content;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NSInteger list_state;

@property (nonatomic, assign) NSInteger user_id;

@property (nonatomic, assign) NSInteger election_campaign_id;

@property (nonatomic, strong) DataUser *user;


@end

