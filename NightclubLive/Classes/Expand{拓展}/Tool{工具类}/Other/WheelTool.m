//
//  WheelTool.m
//  NightclubLive
//
//  Created by RDP on 2017/3/20.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "WheelTool.h"
#import "WheelView.h"
#import "Gift.h"
#import "GroupRequest.h"
#import "GiftWheelModel.h"

@interface WheelTool()
@property (nonatomic, strong) WheelView *wheelV;
@property (nonatomic, strong) NSArray *gifts;
@end

@implementation WheelTool

- (void)appear{
    
    //先获取图片
    ShowLoading
    
    [GetWheelLeafRequest startRequestWithCompleted:^(ResponseState *state) {
        
        CloseLoading
        
        if (state.isSuccess){
            
            self.wheelV.leafImageURL = [state.data firstObject][@"img_url"];
            [self.wheelV appear];
        }
        else{
            
            ShowError(state.msg);
        }
    }];
    
}

- (WheelView *)wheelV{
    
    kWeakSelf(self);
    if (!_wheelV){
        
        _wheelV = [WheelView wheel];
        
        //开始转动
        _wheelV.startAnmitaion = ^(id value){
            
            GroupRequest *group = [GroupRequest new];
            
            //获取奖品列表
            [group addRequests:[GetWheelListRequest new]];
            //获取本次抽奖结果
            GetResultRequest *r = [GetResultRequest new];
            r.param = @{@"giver_id":[UserInfo shareUser].userID,@"receiver_id":weakself.receiverID,@"subject_id":weakself.subjectID};
            [group addRequests:r];
            
            [group startRequestWithFinishBlock:^(NSArray *resutls) {
                
                ObjectRequest *r = resutls[0];
                
                //检查奖品列表
                weakself.gifts = [GiftWheelModel arrayObjectWithDS:r.responseState.data];
                
                //获取结果
                r = resutls[1];
                GiftWheelModel *resultModel = [GiftWheelModel objectWithDic:r.responseObject[@"result"]];
                weakself.wheelResultModel = resultModel;
                
                if (resultModel)
                    [weakself endAniatiomWithAngle:resultModel.angle];
                else{
                }
                
            }];

        };
        
        _wheelV.endAnimation = ^(id value){
            
            if (weakself.wheelResultBlock)
                weakself.wheelResultBlock(weakself.wheelResultModel);
        };
    }
    return _wheelV;
}

- (void)endAniatiomWithAngle:(NSInteger)angle{
    
    [_wheelV endAnmitionWithAngel:angle];
}
@end
