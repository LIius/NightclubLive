//
//  VoiceCommentModel.h
//  NightclubLive
//
//  Created by WanBo on 17/1/9.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface VoiceCommentUser : NSObject

@property (nonatomic, copy)NSString *typeID;
@property (nonatomic, copy)NSString *remark;
@property (nonatomic, copy)NSString *modifytime;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *autograph;
@property (nonatomic, copy)NSString *sex;
@property (nonatomic, copy)NSString *videoCertification;
@property (nonatomic, copy)NSString *constellation;
@property (nonatomic, copy)NSString *vehicleCertification;
@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *sign;
@property (nonatomic, copy)NSString *passWord;
@property (nonatomic, copy)NSString *profilePhoto;
@property (nonatomic, copy)NSString *age;
@property (nonatomic, copy)NSString *sellerCertification;
@property (nonatomic, copy)NSString *userName;
@property (nonatomic, copy)NSString *phoneNum;
@property (nonatomic, copy)NSString *emotion;
@property (nonatomic, copy)NSString *profeCertification;
@property (nonatomic, copy)NSString *address;
@property (nonatomic, copy)NSString *createtime;

@end

@interface VoiceCommentListModel : ModelObject

@property (nonatomic, copy)NSString *typeId;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *ID;
@property (nonatomic, copy)NSString *status;
@property (nonatomic, copy)NSString *count;
@property (nonatomic, copy)NSString *subjectId;
@property (nonatomic, copy)NSString *createtime;
@property (nonatomic, copy)NSString *toUserId;
@property (nonatomic, copy)NSString *modifytime;
/*"ispraise": 0,
"praise": 0,*/
@property (nonatomic, assign) NSInteger ispraise;
@property (nonatomic, assign) NSInteger praise;
@property (nonatomic, strong)VoiceCommentUser *toUser;
@property (nonatomic, strong)VoiceCommentUser *user;
@property (nonatomic, strong) NSURL *from_user_img;
@property (nonatomic, copy) NSString *from_user_name;
/** cell 高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end


@interface VoiceCommentModel : NSObject

@property (nonatomic, strong)NSArray<VoiceCommentListModel*> *result;

@property (nonatomic, copy)NSString *state;

@end



