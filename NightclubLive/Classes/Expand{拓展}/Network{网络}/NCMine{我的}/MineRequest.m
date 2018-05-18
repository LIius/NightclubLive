//
//  MineRequest.m
//  NightclubLive
//
//  Created by RDP on 2017/4/18.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "MineRequest.h"

#import "RSATool.h"

@implementation UpdateUserInfoRequest

- (instancetype)init{
    
    if (self = [super init]){
        
        self.emotion = -1;
        self.sex = -1;
    }
    return self;
}

- (NSString *)path{
    
    return @"user/updateUser.do";
}

- (NSDictionary *)parameters{

    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    //修改头像
    if (self.headURL)
        [param setValue:self.headURL forKey:@"profilePhoto"];
    
    //修改昵称
    if (self.name)
        [param setValue:self.name forKey:@"userName"];

    //修改城市
    if (self.city)
        [param setValue:self.city forKey:@"city"];
    
    //修改星座
    if (self.constellation)
        [param setValue:self.constellation forKey:@"constellation"];
    
    //修改出生日期
    if (self.birthday)
        [param setValue:self.birthday.YMDString forKey:@"birth_day"];
    
    if (self.role)
        [param setValue:self.role forKey:@"occupation"];
    //情感
    if (self.emotion >= 0)
        [param setValue:@(self.emotion) forKey:@"emotion"];
    
    //修改性别
    if (self.sex >= 0){
        [param setValue:@(_sex) forKey:@"sex"];
    }
    
    //修改收入
    if (self.income)
        [param setObject:self.income forKey:@"income"];
    
    //修改用户签名
    if (self.sign)
        [param setObject:self.sign forKey:@"autograph"];
    
    if ([UserInfo shareUser].userID.length >0) {
        [param setObject:[UserInfo shareUser].userID forKey:@"id"];
    }
    
    
    return param.mutableCopy;
}
@end

@implementation MyDynamicListRequest

- (NSString *)path{
    
    return @"dynamic/personDynamicList.do";
}
@end


@implementation PhotoAlbumListRequest

- (NSString *)path{
    
    return @"photo/getphotoList.do";
}

@end


@implementation MyAccountRequest


- (NSString *)path{
    
    return @"account/search.do";
}

- (NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *str = [RSATool rsaEncryptString:[UserInfo shareUser].userID];
    if (str) {
        [params setValue:str forKey:@"userId"];
    }

    return params.mutableCopy;
    //return @{@"userId":[RSATool rsaEncryptString:[UserInfo shareUser].userID]};
}

@end

@implementation DeletePhotoRequest

- (NSString *)path{
    
    return @"photo/editPersonPhoto.do";
}

- (NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *imgJSON = @"";
    if (self.imgs) {
        imgJSON = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self.imgs options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    }
    
    NSString *str = [RSATool rsaEncryptString:[UserInfo shareUser].userID];
    if (str) {
        [params setValue:str forKey:@"user_id"];
    }
    
    NSString *str2 = [RSATool rsaEncryptString:_photoID];
    if (str2) {
        [params setValue:str2 forKey:@"photo_id"];
    }
    
    if (imgJSON) {
        [params setValue:imgJSON forKey:@"urls"];
    }
 
    return params.mutableCopy;
    //return @{@"user_id":[RSATool rsaEncryptString:[UserInfo shareUser].userID],@"photo_id":[RSATool rsaEncryptString:_photoID],@"urls":imgJSON};
}

@end

@implementation FenGZRequest

- (NSString *)path{
    
    return @"follow/getFollow.do";
}

- (NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    
    if (self.tag == 1){
        if (CurrentUser.userID.length >0) {
            [params setValue:CurrentUser.userID forKey:@"follow_user_id"];
        }
        if (self.pageNow) {
            [params setValue:@(self.pageNow) forKey:@"pageNow"];
        }
        
        //return @{@"follow_user_id":CurrentUser.userID,@"pageNow":@(self.pageNow)};
    }else{
        if (CurrentUser.userID.length >0) {
            [params setValue:CurrentUser.userID forKey:@"user_id"];
        }
        if (self.pageNow) {
            [params setValue:@(self.pageNow) forKey:@"pageNow"];
        }
        
        //return @{@"user_id":CurrentUser.userID,@"pageNow":@(self.pageNow)};
    }

    return params.mutableCopy;
}

@end

@implementation AddGZRequest

- (NSString *)path{
    
    return @"follow/addFollow.do";
}

- (NSDictionary *)parameters{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.model) {
        [params setValue:self.model forKey:@"follow_user_id"];
    }
    if (CurrentUser.userID.length > 0) {
        [params setValue:CurrentUser.userID forKey:@"user_id"];
    }
    
    return params.mutableCopy;
    //return @{@"follow_user_id":self.model,@"user_id":CurrentUser.userID};
}

@end

@implementation MyPrizeListRequest

- (NSString *)path{
    
    return @"prize_receive/list.do";
}

- (NSDictionary *)parameters{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.model) {
        [params setValue:self.model forKey:@"pageNow"];
    }
    if (CurrentUser.userID.length > 0) {
        [params setValue:CurrentUser.userID forKey:@"userId"];
    }
    
    return params.mutableCopy;
    //return @{@"userId":CurrentUser.userID,@"pageNow":self.model};
}

@end

@implementation MyNextListRequest

- (NSString *)path{

    return @"user/lowerLevel.do";
}

- (NSDictionary *)parameters{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.model) {
        [params setValue:self.model forKey:@"pageNow"];
    }
    if (CurrentUser.userID.length > 0) {
        [params setValue:CurrentUser.userID forKey:@"userId"];
    }
    
    return params.mutableCopy;
    //return @{@"userId":CurrentUser.userID,@"pageNow":self.model};
}


@end


@implementation GetPrizeReqeust

- (NSString *)path{
    
    return @"prize_receive/receive_prize.do";
}

@end

@implementation GetMyGiftListRequest

- (NSString *)path{
    
    return @"gift/getGiftList.do";
}

- (NSDictionary *)param{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    if (self.pageNow){
        [param setValue:self.pageNow forKey:@"pageNow"];
    }
    
    if (CurrentUser.userID.length >0) {
        [param setValue:CurrentUser.userID forKey:@"receiver_id"];
    }
    
    
    return param.mutableCopy;
}

@end

@implementation WithdrawRequest

- (NSString *)path{
    
    return @"withdraw/withdrawal.do";
}

- (NSDictionary *)param{
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    NSString *strUserID = RSAEncryptString(CurrentUser.userID);
    if (strUserID) {
        [param setValue:strUserID forKey:@"user_id"];
    }
    
    if (_name.length >0) {
        [param setValue:_name forKey:@"user_name"];
    }
    
    NSString *strMoney = RSAEncryptString(_money);
    if (strMoney) {
        [param setValue:strMoney forKey:@"amount"];
    }
    
    NSString *strAccount = RSAEncryptString(_account);
    if (strAccount) {
        [param setValue:strAccount forKey:@"payee_account"];
    }
    
    if (_type) {
        [param setValue:@(_type) forKey:@"from_where"];
    }
    
    
    NSString *str = [[NSString alloc] initWithData:[NSJSONSerialization    dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    NSString *jsonStr = RSAEncryptString(str);
    
    NSMutableDictionary *dictParam = [[NSMutableDictionary alloc] init];
    if (jsonStr) {
        [dictParam setValue:jsonStr forKey:@"jsonStr"];
    }
    
    return dictParam.mutableCopy;

}

@end


@implementation GetBarListRequest

- (NSString *)path{
    
    return  @"merchant/getMerchantList";
}

- (NSString *)baseUrl{
    
    return URL_TTPBASE;
}

@end

@implementation BindBarRequest

- (NSString *)path{
    
    return @"user/bindMerchant";
}

- (NSString *)baseUrl{
    
    return URL_TTPBASE;
    
}
@end


@implementation GetMyBarListRequest

- (NSString *)path{
    
    return @"merchant/getBindedMerchantList";
}

- (NSString *)baseUrl{
    
    return URL_TTPBASE;
}

@end

@implementation AlertBindRequest

- (NSString *)path{
    
    return @"user/notifyMerchant";
}

- (NSString *)baseUrl{
    
    return URL_TTPBASE;
}

@end

@implementation OrderListRequest

- (NSString *)path{
    
    return @"order/getOrderList";
}

- (NSString *)baseUrl{
    
    return URL_TTPBASE;
}

@end


@implementation UnBindBarRequest

- (NSString *)path{
    
    return @"user/unbindMerchant";
}

- (NSString *)baseUrl{
    
    return URL_TTPBASE;
}

@end

@implementation ConvertNVRequest

- (NSString *)path{
    
    return @"account/moneyToNightBit.do";
}

- (NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *str = RSAEncryptString(CurrentUser.userID);
    if (str) {
        [params setValue:str forKey:@"userId"];
    }
    if (_nc) {
        [params setValue:@(_nc) forKey:@"nightBit"];
    }
    
    return  params.mutableCopy;
    //return @{@"userId":RSAEncryptString(CurrentUser.userID),@"nightBit":@(_nc)};
}

@end

@implementation BarPackageRequest

- (NSString *)path{
    
    return @"/combo/getComboList";
}

- (NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (_barID) {
        [params setValue:_barID forKey:@"merchant.id"];
    }
    [params setValue:@(-1) forKey:@"page"];
    
    return  params.mutableCopy;
    //return @{@"merchant.id":_barID,@"page":@(-1)};
}

- (NSString *)baseUrl{
    
    return URL_TTPBASE;
}
@end


@implementation DownOrderRequest

- (NSString *)path{
    
    return @"/order/placeOrder";
}

- (NSString *)baseUrl{
    
    return URL_TTPBASE;
}
@end


@implementation OrderDetailsRequest

- (NSString *)path{
    
    return @"/order/getOrderDetail";
}

- (NSString *)baseUrl{
    
    return URL_TTPBASE;
}

@end

@implementation IncomeListRequest

- (NSString *)path{
    
    return @"follow/getIncomeList.do";
}
@end


@implementation ExpenditureListRequest

- (NSString *)path{
    
    return @"follow/getExpenditureList.do";
}

@end

@implementation RechargeLogListRequest

- (NSString *)path{
    
    return @"order/getRechargeList.do";
}

@end


@interface ContributionListRequest ()
/** 对象模型 */
@property (nonatomic, strong) NSNumber *model;

@end

@implementation ContributionListRequest

- (NSString *)path{
    
    return @"ranking/contribution_list.do";
}

- (NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (CurrentUser.userID.length >0) {
        [params setValue:CurrentUser.userID forKey:@"userId"];
    }
    if (self.model) {
        [params setValue:self.model forKey:@"serach_period"];
    }
    
    return params.mutableCopy;
    //return @{@"userId":CurrentUser.userID,@"serach_period":self.model};
}

@end

@implementation PersonRankListRequest

- (NSString *)path{
    return @"ranking/person_ranking.do";
}

- (NSDictionary *)param{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.model) {
        [params setValue:self.model forKey:@"userId"];
    }
    
    return params.mutableCopy;
    //return @{@"userId":self.model};
}
@end


@implementation MyVoiceListRequest

- (NSDictionary *)parameters{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (CurrentUser.userID.length >0) {
        [params setValue:CurrentUser.userID forKey:@"userId"];
    }
    if (self.pageNow) {
        [params setValue:@(self.pageNow) forKey:@"pageNow"];
    }
    
    return params.mutableCopy;
    //return @{@"userId":CurrentUser.userID,@"pageNow":@(self.pageNow)};
}

- (NSString *)path{
    return @"heartsound/getHeartList.do";
}

@end
