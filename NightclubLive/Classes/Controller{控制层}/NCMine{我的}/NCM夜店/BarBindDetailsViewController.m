//
//  BarBindDetailsViewController.m
//  NightclubLive
//
//  Created by rdp on 2017/5/24.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "BarBindDetailsViewController.h"
#import "MineModelList.h"
#import "UIAlertController+Factory.h"

#import "MineRequest.h"
#import "NCAlert.h"

@interface BarBindDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statueLabel;
/** 对象模型 */
@property (nonatomic, weak) BarBindModel *model;

@end

@implementation BarBindDetailsViewController

@dynamic model;

- (void)viewDidLoad {
    [super viewDidLoad];

    //加载数据
    [_logoIV sd_setImageWithURL:self.model.image placeholderImage:[UIImage picturePlaceholder]];
    _nameLabel.text = self.model.name;
    _statueLabel.text = self.model.bindStatus ? @"已绑定" : @"申请中";
    
    _logoIV.isRound = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)rightClick:(id)sender {
    
    @weakify(self);
    [NCAlert showActionSheetWithDataSource:@[@"我要解绑"] blockHandel:^(NSInteger index) {

        if (index == 0)
        {
            //先获取绑定ID
            [CurrentUser getYWBToken:^(id param) {
                @strongify(self);
                
                UnBindBarRequest *unbindR = [UnBindBarRequest new];
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                if (param ) {
                    [params setValue:param forKey:@"token"];
                }
                if (self.model.ID.length > 0) {
                    [params setValue:self.model.ID forKey:@"merchant.id"];
                }
                
                unbindR.param = params;
                //unbindR.param = @{@"token":param,@"merchant.id":self.model.ID};
                [unbindR startRequestWithCompleted:^(ResponseState *state) {
                    @strongify(self);
                    if (state.isSuccess){
                        ShowSuccess(state.message);
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else{
                        ShowError(state.message);
                    }
                }];
            }];
        }
    }];

}

@end
