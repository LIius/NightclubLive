//
//  MessageModelList.m
//  NightclubLive
//
//  Created by RDP on 2017/7/6.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MessageModelList.h"
#import "DynamicListModel.h"
#import "PaiPaiModel.h"
#import "MineModelList.h"
#import "VoiceListModel.h"

@implementation CommentModel

- (void)setMap:(NSDictionary *)map{
    
    _map = map;
    
    if (self.typeId == 1){
        DynamicListModel  *m = [[DynamicListModel alloc] initWithDic:[map[@"data"] firstObject]];
        self.m = m;
    }
    else if (self.typeId == 4){
        PaiPaiModel *m = [[PaiPaiModel alloc] initWithDic:[map[@"data"] firstObject]];
        self.m = m;
    }
    else if (self.typeId == 2){
        VoiceListModel *m = [[VoiceListModel alloc] initWithDic:[map[@"data"] firstObject]];
        self.m = m;
    }
}

@end
