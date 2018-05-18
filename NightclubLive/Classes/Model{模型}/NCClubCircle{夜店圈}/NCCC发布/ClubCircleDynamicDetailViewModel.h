//
//  ClubCircleDynamicDetailViewModel.h
//  NightclubLive
//
//  Created by WanBo on 17/1/2.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MRCTableViewModel.h"
#import "DynamicListModel.h"
#import "DynamicCommentListModel.h"

@interface ClubCircleDynamicDetailViewModel : MRCTableViewModel

@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *subjectID;
@property (nonatomic,copy)NSString *touserID;

@property (nonatomic, strong) DynamicListModel *model;
@property (nonatomic, strong, readonly) RACCommand *commentReuqesCommand;
@property (nonatomic, strong, readonly) RACCommand *reportReuqesCommand;
@property (nonatomic, strong) RACCommand *getReplyCommand;
@property (nonatomic, copy) NSArray *datas;


@property (nonatomic, assign) RefreshType refreshType;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong, readonly) RACCommand *likeReuqesCommand;
@property (nonatomic, strong)  RACCommand *unlikeRequestCommand;

@property (nonatomic,copy)NSString *comsubjectID;
@property (nonatomic,copy)NSString *comtypeID;

@end
