//
//  GiftTool.m
//  NightclubLive
//
//  Created by RDP on 2017/4/5.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "GiftTool.h"
#import "GiftView.h"
#import "RMStore.h"
#import "MyAccountCollectionViewController.h"
#import "GlobalRequest.h"
#import "GlobalModel.h"
#import "GiftTool.h"
#import "Gift.h"
#import "CharmHUD.h"
#import "UIWindow+CurrentViewController.h"
#import "ScottAlertController.h"
#import "UIView+ScottAlertView.h"
#import "RankViewController.h"
#import "UIWindow+CurrentViewController.h"
#import "UIAlertController+Factory.h"
#import "BlocksKit+UIKit.h"
@interface GiftTool()<SKProductsRequestDelegate>
/** 礼物列表 */
@property (nonatomic, strong) NSArray *gifts;
@property (nonatomic, weak) GiftView *giftView;
/** 送礼数量 */
@property (nonatomic,strong) NSNumber *giftNum;
/** 送礼的路径 */
@property (nonatomic, strong) NSIndexPath *selectIndexPath;
/** 获取魅力值 */
@property (nonatomic, copy) NSString *charValue;

@end

@implementation GiftTool

+ (instancetype)defaultGiftTool{
    
    static GiftTool *shareClass;
    
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        
        shareClass = [[GiftTool alloc] init];
    });
    
    return shareClass;
}

#pragma mark - Public Method

- (void)buyByGiftID:(NSString *)giftID{
}

- (void)startGetGiftList{
    

}

#pragma mark - Getter

- (GiftView *)giftView{
    
    kWeakSelf(self);
    if (!_giftView){
        
        _giftView = [GiftView initFromXIB];
        
        CGFloat width = SCREEN_WIDTH;
        CGFloat height = SCREEN_HEIGHT * (195 / 667);
        _giftView.size = CGSizeMake(width, height);
        UIViewController *currentVC = [ShareWindow zf_currentViewController];
        kWeakSelf(_giftView);
        //充值
        [_giftView.rechargeBtn bk_whenTapped:^{
            
            [self.giftView dismiss];
        //    [weakself.giftView close];
            //跳转到我的账户页面
            [currentVC.navigationController pushViewController:[MyAccountCollectionViewController initSBWithSBName:@"MyAccountSB"] animated:YES];
        }];
        
        //修改数量
        _giftView.selectNumBlock = ^(NSNumber *num){
            
            if ([num integerValue] < 0 || [num integerValue] > 2000){
                ShowError(@"数值输入错误(1-2000)");
                return;
            }
            
            weakself.giftNum = num;
            
        };
        
        //送礼
        _giftView.sendBlock = ^(id value){
            [weak_giftView.sendBtn setUserInteractionEnabled:NO];
            weakself.selectIndexPath = value;
            GiftModel *m = weakself.gifts[weakself.selectIndexPath.row];
            //1.先调用接口等待接口完成即调用图像
            SendGiftRequest *sendR = [[SendGiftRequest alloc] init];
            sendR.receiverID = _receiverID;
            sendR.giftID = m.ID;
            sendR.giftType = _giftType;
            sendR.giftCount = _giftNum;
            sendR.projectID = _projectID;
            sendR.phoneNum = _phoneNum;
            [sendR startRequestWithCompleted:^(ResponseState *state) {
                
                if (state.isSuccess){
                    //1.扣除本地夜比特的值
                    //更新账号信息
                    [CurrentUser updateUserAccountCompletion:^(id param) {
                    }];
                    //2.调用图像
                    [weakself showGiftAnimationWithURL:m.gift_img_url];
                    
                    _charValue = state.alert_msg;
                    
                    if (self.giftBlock)
                        self.giftBlock(m.gift_name);
                }else{
                    if (state.responseCode == 4){
                        
                        UIAlertController *ac = [UIAlertController alertCancelAndOKWithTitle:nil message:@"夜比特不足，是否前往充值？" okCalk:^(id param) {
                            
                            NSInteger select = [param integerValue];
                            if(select == 0){//跳转到充值页面
                                //跳转到我的账户页面
                                [self.giftView dismiss];
                                [currentVC.navigationController pushViewController:[MyAccountCollectionViewController initSBWithSBName:@"MyAccountSB"] animated:YES];

                            }
                        }];
                        
                        [[ShareWindow zf_currentViewController] presentViewController:ac animated:YES completion:nil];
                    }
                    else{
                        ShowError(state.message);
                    }
                    [weak_giftView.sendBtn setUserInteractionEnabled:YES];

                }
            }];

        };
    }
    return _giftView;
}


#pragma mark - 礼物视图部分

- (void)showGiftView
{
    if (![SKPaymentQueue canMakePayments]){
        
        ShowError(@"请打开内购功能");
        return;
    }
    
    //获取礼物列表
    
    ShowLoading
    [GiftListRequest startRequestWithCompleted:^(ResponseState *state) {
        
        CloseLoading
        if (state.isSuccess){
            
            NSArray *array = [GiftModel arrayObjectWithDS:state.data];
            self.giftView.model = array;
//            ScottAlertViewController *giftAC = [ScottAlertViewController alertControllerWithAlertView:self.giftView preferredStyle:ScottAlertControllerStyleActionSheet];
//            giftAC.tapBackgroundDismissEnable = YES;
//            UIViewController *currentVC = [ShareWindow zf_currentViewController];
//            [currentVC presentViewController:giftAC animated:YES completion:nil];
               [self.giftView show];
         //   _giftView.moneyLabel.text = CurrentUser.account.night_bit;
            _gifts = array;
            
            self.giftView.closeBlock = ^(id param) {
                
                if (self.closeBlock)
                    self.closeBlock(nil);
            };
        }
        
        else{
            ShowError(@"获取礼物列表失败");
        }
    }];
    
}

#pragma mark - Private Method

/**
 *  启动礼物动画
 */
- (void)showGiftAnimationWithURL:(NSURL *)url{
    
    //设置初始化大小
    UIImageView *giftIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    giftIV.center = ShareWindow.center;

    [ShareWindow addSubview:giftIV];
    //等待下载完图片
    ShowLoading
    [giftIV sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [_giftView.sendBtn setUserInteractionEnabled:YES];
        
        CloseLoading
        if (!error){
            
            //启动动画
            [UIView animateWithDuration:1.5 animations:^{
                CGFloat width = SCREEN_WIDTH * 0.5;
                CGFloat height = (image.size.height / image.size.width) * width;
                CGFloat x = width * 0.5;
                CGFloat y = (SCREEN_HEIGHT - height) * 0.5;
                giftIV.frame = CGRectMake(x, y, width, height);
                giftIV.center = ShareWindow.center;
                
            } completion:^(BOOL finished) {
                
                //1秒后移除对象
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [giftIV removeFromSuperview];
                    
                    //显示弹框
                    CharmHUD *hud =  [CharmHUD showCharHUDWithCharValue:_charValue];
                    hud.removeBlock = ^(id param) {
                        //关闭页面
                        [self.giftView close];
                        //跳转
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            UIViewController *currentVC = [ShareWindow zf_currentViewController];
                            RankViewController *rankVC = [RankViewController initSBWithSBName:@"RankSB"];
                            [currentVC.navigationController pushViewController:rankVC animated:YES];
                            
                        });
                    };
                    
                });
            }];
        }
        else{
            
            ShowError(@"送礼成功,但动画加载失败");
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //显示弹框
               CharmHUD *hud =  [CharmHUD showCharHUDWithCharValue:_charValue];
                hud.removeBlock = ^(id param) {
                    //关闭页面
                    [self.giftView close];
                    //跳转
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        UIViewController *currentVC = [ShareWindow zf_currentViewController];
                        RankViewController *rankVC = [RankViewController initSBWithSBName:@"RankSB"];
                        [currentVC.navigationController pushViewController:rankVC animated:YES];
                        
                    });
                };
                
            });

            //显示弹框
        }
        
    }];
    
}
@end
