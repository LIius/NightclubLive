//
//  AddedValueTool.m
//  NightclubLive
//
//  Created by RDP on 2017/4/13.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "AddedValueTool.h"
#import "AddedValueRequest.h"
#import <RMStore/RMStore.h>

@interface AddedValueTool()
/** 产品ID列表 */
@property (nonatomic, strong) NSArray *products;
@end

@implementation AddedValueTool

+(instancetype)shareTool{
    
    static dispatch_once_t token;
    
    static AddedValueTool *shareClass;
    dispatch_once(&token, ^{
        
        shareClass = [[AddedValueTool alloc] init];
    });
    
    return shareClass;
}

- (void)getIOSPackageListCompletion:(void (^)(NSArray *))completion
{
    GetPackageListRequest *r = [GetPackageListRequest new];
    
    [r startRequestWithCompleted:^(ResponseState *state) {
        
        if (state.isSuccess){
            
            NSArray *arr = [AddedValuePackageModel arrayObjectWithDS:state.data];
            
            self.packageList = arr;
            
        }
        
        if (completion)
            completion(self.packageList);
    }];
}

- (void)buyPackageWithID:(NSString *)packageID completion:(void (^)(id))completion
{
    
    //获取产品列表
    [WBLoadingHUD show];
    NSSet *productSet = [NSSet setWithArray:self.products];
    [[RMStore defaultStore] requestProducts:productSet success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        
        [WBLoadingHUD close];
        NSString *buyID = [NSString stringWithFormat:@"Package_%@",packageID];
        // 支付调用接口
        [[RMStore defaultStore] addPayment:buyID success:^(SKPaymentTransaction *transaction) {
            
            if (transaction.transactionState == SKPaymentTransactionStatePurchased)
            {
                // 验证凭据，获取到苹果返回的交易凭据
                // 从沙盒中获取到购买凭据
                NSData *receiptData = [NSData dataWithContentsOfURL:[NSBundle mainBundle].appStoreReceiptURL];
                NSLog(@"[凭据=%@]]",receiptData);
                NSString *str1 = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
                NSString *str2 = [receiptData base64EncodedStringWithOptions:0];
                NSLog(@"[str1=%@]-----[str2=%@]",str1,str2);
                NSLog(@"[沙盒中获取到购买凭据=%@]",transaction.transactionReceipt);
                
                
                [self appleCheckReceiptData:receiptData];
                // 完成购买后：向自己的服务器验证支付凭证
                VerifyReceiptRequest *r  = [VerifyReceiptRequest new];
                r.receiptData = transaction.transactionReceipt;
                
                [r startRequestWithCompleted:^(ResponseState *state)
                 {
                    if(state.isSuccess){
                        NSLog(@"成功购买");
                        [CurrentUser updateUserDataCompletion:^(id param) {
                        }];
                        
                        if (completion)
                            completion(nil);
                    }
                    else{
                        ShowError(state.message);
                    }
                }];
            }
            
            
        } failure:^(SKPaymentTransaction *transaction, NSError *error) {
            
        }];
        
    } failure:^(NSError *error) {
        
        [WBLoadingHUD close];
        
    }];
    

}

- (void)appleCheckReceiptData:(NSData *)receiptData
{
    // 发送网络POST请求，对购买凭据进行验证
    //测试验证地址:https://sandbox.itunes.apple.com/verifyReceipt
    //正式验证地址:https://buy.itunes.apple.com/verifyReceipt
    NSURL *url = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    NSMutableURLRequest *urlRequest =
    [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    urlRequest.HTTPMethod = @"POST";
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
    urlRequest.HTTPBody = payloadData;
    // 提交验证请求，并获得官方的验证JSON结果 iOS9后更改了另外的一个方法
    NSData *result = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    // 官方验证结果为空
    if (result == nil) {
        NSLog(@"验证失败");
        return;
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
    if (dict != nil) {
        // 比对字典中以下信息基本上可以保证数据安全
        // bundle_id , application_version , product_id , transaction_id
        NSLog(@"验证成功！购买的商品是：%@",dict);
    }

}

- (void)setPackageList:(NSArray *)packageList{
    
    _packageList = packageList;
    
    NSMutableArray *temp = [NSMutableArray array];
    for (AddedValuePackageModel *m in packageList){
        [temp addObject:[NSString stringWithFormat:@"Package_%@",m.ID]];
    }
    
    self.products = [temp copy];
}
@end
