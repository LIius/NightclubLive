//
//  MineModelList.h
//  NightclubLive
//
//  Created by RDP on 2017/4/21.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ModelObject.h"


/**
 *  相册模型
 */

@interface PhotoAlbumList : ModelObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, strong) NSDate *create_time;

@property (nonatomic, copy) NSString *img_url;

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) BOOL selectAll;
@property (nonatomic, strong) NSMutableArray *selects;
- (void)setSelectWithBool:(NSInteger)select;
@end


/**
 *  我的账号信息
 */
@interface AccountModel : ModelObject
/** 魅力值 */
@property (nonatomic, copy) NSString *charm_value;
/** 夜比特 */
@property (nonatomic, copy) NSString *night_bit;
/** 小夜币 */
@property (nonatomic, copy) NSString *saya_currency;
/** 魅力值校验码 */
@property (nonatomic, copy) NSString *charm_code;
/** 夜比特校验码 */
@property (nonatomic, copy) NSString *night_code;
/** 小夜币校验码 */
@property (nonatomic, copy) NSString *saya_code;
/** 输出字段 */
@property (nonatomic, copy) NSString *out_status;
/** 人民币 */
@property (nonatomic, copy) NSString *rmb;
/** 零钱 */
@property (nonatomic, copy) NSString *user_rmb;

/** 小夜币转成夜比特的值 */
@property (nonatomic, copy) NSString *saya_currency_to_night_bit;
//等级称号
@property (nonatomic, copy) NSString *rankName;
/** 等级 */
@property (nonatomic, assign) NSInteger rank;
/**
 *  更新夜比特的值
 *
 *  @param nvValue 新的值
 */
- (void)updateNCValue:(NSString *)nvValue;
@end

@interface FenGZModel : ModelObject

@property (nonatomic, copy) NSString *ID;

/** 职业认证 */
@property (nonatomic, assign) BOOL profe_certification;
/** 认证车辆名称 */
@property (nonatomic, copy) NSString *car_name;
/** 创建时间 */
@property (nonatomic, copy) NSString *createtime;
/** 性别 */
@property (nonatomic, assign) NSInteger sex;
/** 汽车logo */
@property (nonatomic, strong) NSURL *logo_url;
/** 用户LOGO */
@property (nonatomic, strong) NSURL *profile_photo;
/** 粉丝用户ID */
@property (nonatomic, copy) NSString *follow_user_id;

@property (nonatomic, copy) NSString *modifytime;
/** 用户ID */
@property (nonatomic, copy) NSString  *user_id;
/** 公司认证 */
@property (nonatomic, assign) BOOL company_certification;
/** 视频认证 */
@property (nonatomic, assign) BOOL video_certification;
/** 职业认证 */
@property (nonatomic, assign) BOOL seller_certification;
/** 是否已经关注 */
@property (nonatomic, assign) BOOL follow;
/** 用户姓名 */
@property (nonatomic, copy) NSString *user_name;
/** 车辆认证 */
@property (nonatomic, assign) BOOL vehicle_certification;
@end


@interface PrizeListModel: ModelObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *start_date;

@property (nonatomic, strong) NSDate *end_date;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *campaign_title;

@property (nonatomic, copy) NSString *ranking;

@property (nonatomic, copy) NSString *prize_img;
@property (nonatomic, strong) NSArray *prizeImgs;
@property (nonatomic, copy) NSString *details_img;
@property (nonatomic, strong) NSArray *detailsImgs;

@property (nonatomic, assign) NSInteger election_campaign_ranking_id;

@property (nonatomic, copy) NSString *receive_code;

@property (nonatomic, copy) NSString *prize_name;

@property (nonatomic, copy) NSString *receive_time;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *winning_time;

@end

/**
 *  我的下线
 */
@interface MyNextListModel : ModelObject

@property (nonatomic, strong) NSDate *createtime;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, strong) NSURL *profile_photo;

@end

/**
 *  我的礼物列表
 */
@interface MyGiftListModel: ModelObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NSInteger gift_id;

@property (nonatomic, copy) NSString *describe_content;

@property (nonatomic, assign) NSInteger gift_count;

@property (nonatomic, assign) NSInteger gift_type;

@property (nonatomic, assign) NSInteger giver_id;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *saya_currency_value;

@property (nonatomic, assign) NSInteger project_id;

@property (nonatomic, assign) NSInteger receiver_id;

@property (nonatomic, strong) NSDate *create_time;

@property (nonatomic, strong) NSURL *profile_photo;

@property (nonatomic, copy) NSString *gift_name;

@end

/**
 *  酒吧封装类
 */
@interface BarModel : ModelObject

@property (nonatomic, copy) NSString *distance;

@property (nonatomic, copy) NSString *address;
/** 地址 */
@property (nonatomic, copy) NSString *address2;


@property (nonatomic, copy) NSString *tel;

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, assign) CGFloat longitude;

@property (nonatomic, strong) NSURL *image;

@property (nonatomic, assign) CGFloat latitude;

@property (nonatomic, copy) NSString *shortIntr;

@property (nonatomic, copy) NSString *name;

- (void)onlySetLogoWithURL:(NSURL *)url;

/** 酒吧营业时间 */
@property (nonatomic, copy) NSString *businessHours;

/** 营业时间段 */
@property (nonatomic, strong) NSArray *dobusinessArray;


@end

/**
 *  酒吧绑定封装类
 */
@interface BarBindModel : BarModel
/** 封装状态 0-请求中 1-通过*/
@property (nonatomic, assign) NSInteger bindStatus;
@end

@interface BarPackageModel : ModelObject
/** ID */
@property (nonatomic, copy) NSString *ID;
/** imge */
@property (nonatomic, copy) NSString *image;
/** 套餐连接地址 */
@property (nonatomic, strong) NSURL *imageURL;

/** name */
@property (nonatomic, copy) NSString *name;
/** 原价 */
@property (nonatomic, copy) NSString *originalPrice;
/** 现价 */
@property (nonatomic, copy) NSString *price;
/** 介绍 */
@property (nonatomic, copy) NSString *shortIntr;
@end


/**
 *  下单
 */
@interface DownOrderModel : ModelObject
/** 酒吧对象 */
@property (nonatomic, weak) BarBindModel *barModel;
/** 到场时间 */
@property (nonatomic, strong) NSDate *date;
/** 到场人数 */
@property (nonatomic, copy) NSString *personCount;
/** 座位类型 0-吧台 1-卡座 2-包厢 */
@property (nonatomic, assign) NSInteger reatType;
/** 套餐 */
@property (nonatomic, strong) BarPackageModel *packgeModel;
/** 姓名 */
@property (nonatomic, copy) NSString *name;
/** 电话 */
@property (nonatomic, copy) NSString *phone;
/** 备注 */
@property (nonatomic, copy) NSString *remark;
/** 单类型 */
@property (nonatomic, assign) NSInteger bookType;
/** 台号 */
@property (nonatomic, copy) NSString *tableNo;

@end


@interface OrderListModel : ModelObject

@property (nonatomic, assign) NSInteger discount;

@property (nonatomic, assign) NSString *ID;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) BarModel *merchant;

@property (nonatomic, copy) NSString *total;

@property (nonatomic, copy) NSString *mealNumber;

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, strong) NSDate *createTime;

@property (nonatomic, strong) NSURL *image;

@property (nonatomic, copy) NSString *orderType;

@property (nonatomic, copy) NSString *tableNo;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *paid;
/** 到达时间 */
@property (nonatomic, strong) NSDate *arrivalTime;
/** 联系电话 */
@property (nonatomic, copy) NSString *contactMobile;
/** 联系人名称 */
@property (nonatomic, copy) NSString *contactName;
/** 备注 */
@property (nonatomic, copy) NSString *remarks;
/** 被邀请用户的ID */
@property (nonatomic, copy) NSString *inviteAppUserId;

@end




/**
 *  提现类型
 */
typedef  enum{
    WithdrawTypeWeiChat = 1,//微信支付
    WithdrawTypeAliPay,//支付宝
}WithdrawType;

/**
 *  记录类型
 */
typedef enum{
    RecordTypeGift = 0,//送礼
    RecordTypeShare,//酒吧提成
    RecordTypedWithdraw,//提现
    RecordTypeAppointment,//约台
    RecordTypeConvert,//兑换夜比特
}RecordType;

/**
 *  账户支出收入类型
 */
@interface AccountLogModel : ModelObject

/**
 *  提现来源类型
 */
@property (nonatomic, assign) WithdrawType from_pay;
/**
 *  类型
 */
@property (nonatomic, assign) RecordType record_type;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, strong) NSDate *create_time;
/**
 *  增加还是支出
 */
@property (nonatomic, assign) NSInteger add_or_subtract;
/** 人民币数量 */
@property (nonatomic, copy) NSString *rmb_value;

@end


@interface RechargeLogModel : ModelObject
/** 时间 */
@property (nonatomic, strong) NSDate *purchase_date;
/** 话费 */
@property (nonatomic, copy) NSString *total_price;
/** 充值夜比特 */
@property (nonatomic, copy) NSString *order_subject;


@end

/**
 *  土豪登录
 */
@interface TheRichModel : ModelObject

/** 土豪值 */
@property (nonatomic, copy) NSString *daifug_value;

/** 等级 */
@property (nonatomic, assign) NSInteger rankNum;

@property (nonatomic, copy) NSString *profile_photo;

@property (nonatomic, assign) NSInteger charm_rownum;

@property (nonatomic, assign) NSInteger charm_value;

@property (nonatomic, assign) NSInteger user_id;

@property (nonatomic, copy) NSString *autograph;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *phone_num;

@property (nonatomic, assign) NSInteger sex;

@end
