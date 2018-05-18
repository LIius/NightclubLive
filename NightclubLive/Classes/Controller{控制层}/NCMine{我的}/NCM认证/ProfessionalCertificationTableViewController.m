//
//  ProfessionalCertificationTableViewController.m
//  NightclubLive
//
//  Created by SuperDanny on 2016/12/11.
//  Copyright © 2016年 WanBo. All rights reserved.
//

#import "ProfessionalCertificationTableViewController.h"
#import "DDCustomPickerView.h"
#import "QiNiuSystemService.h"
#import "GlobalModel.h"
#import "GlobalRequest.h"
#import "QiniuTool.h"
#import "AuthRequest.h"
#import "UIAlertController+Factory.h"
#import "BlocksKit+UIKit.h"
#import "NCAlert.h"
@interface ProfessionalCertificationTableViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *IDCardTf;
@property (weak, nonatomic) IBOutlet UIButton *idCardfrontBtn;
@property (weak, nonatomic) IBOutlet UIButton *IDCarBackBtn;
@property (weak, nonatomic) IBOutlet UIButton *IDHandCarBtn;
///职业
@property (weak, nonatomic) IBOutlet UIButton *professionBtn;
///当前选择图片操作是否是证件照
@property (assign, nonatomic) BOOL isSelectIDCard;
/** 保存职业信息 */
@property (nonatomic, strong) NSArray *jobs;
@property (nonatomic, assign) NSInteger selectJobIndex;
/** 正面 */
@property (nonatomic, strong) UIImage *frontImage;
/** 背面 */
@property (nonatomic, strong) UIImage *backImage;
/** 手持 */
@property (nonatomic, strong) UIImage *handImage;

@end

@implementation ProfessionalCertificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorHex(0xF3F3F3);
    [self createContentView];
    
    [JobRequest startRequestWithCompleted:^(ResponseState *state) {
        
        self.jobs = [JobModel arrayObjectWithDS:state.data];
    }];
}

- (void)createContentView {
    _nameTf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    _nameTf.leftViewMode = UITextFieldViewModeAlways;
    
    _IDCardTf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    _IDCardTf.leftViewMode = UITextFieldViewModeAlways;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSUInteger row = indexPath.row;
//    if (row == 1 || row == 5) {
//        return 46;
//    } else if (row == 7) {
//        return (kScreenWidth-2*15-40)/2;
//    } else if (row == 8) {
//        return 100;
//    } else {
//        return 44;
//    }
//}

#pragma mark - 提交
- (IBAction)commitAction:(id)sender {
    
    [self.view endEditing:YES];
    
    if (_nameTf.text.length == 0) {
        ShowError(@"姓名不能为空");
        [_nameTf becomeFirstResponder];
        return;
    } else if (_IDCardTf.text.length == 0) {
        ShowError(@"身份证号不能为空");
        [_IDCardTf becomeFirstResponder];
        return;
    } else if (![CheckTools isValidateIdentityCard:_IDCardTf.text]) {
        ShowError(@"身份证号格式不正确");
        [_IDCardTf becomeFirstResponder];
        return;
    } else if (!_frontImage) {
        ShowError(@"身份证正面照不能为空");
        return;
    }
    else if (!_backImage){
        ShowError(@"身份证反面照不能为空");
        return;
    }
    else if (!_handImage) {
        ShowError(@"手持证件照不能为空");
        return;
    }

    ShowLoading
    //开始上传图片 图片上传顺序正面 -> 反面 -> 手持身份证
    QiniuTool *tool = [QiniuTool shareTool];
    [tool uploadImages:@[_frontImage,_backImage,_handImage] type:UploadTypeSpaceTypeAuth success:^(id value) {
        
        NSArray *imageURLs = value;
        
        //开始上传到NC服务器
        JobModel *m = _jobs[_selectJobIndex];
        AuthJobRequest *r = [AuthJobRequest new];
        NSDictionary *imageDic = @{@"backImage":imageURLs[0],@"positiveImage":imageURLs[1],@"handheldImage":imageURLs[2]};
        NSData *imageData = [NSJSONSerialization dataWithJSONObject:imageDic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *imageJson = [[NSString alloc] initWithData:imageData encoding:NSUTF8StringEncoding];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        if ([UserInfo shareUser].userID.length >0) {
            [params setValue:[UserInfo shareUser].userID forKey:@"userId"];
        }
        if (_nameTf.text.length > 0) {
            [params setValue:_nameTf.text forKey:@"userName"];
        }
        if (m.ID.length > 0) {
            [params setValue:m.ID forKey:@"occupation"];
        }
        
        if (_IDCardTf.text.length > 0) {
            [params setValue:_IDCardTf.text forKey:@"IDNumber"];
        }
        if (imageJson) {
            [params setValue:imageJson forKey:@"IDImageUrl"];
        }
        
        r.param = params;
        //r.param = @{@"userId":[UserInfo shareUser].userID,@"userName":_nameTf.text,@"occupation":m.ID,@"IDNumber":_IDCardTf.text,@"IDImageUrl":imageJson};
        
        [r startRequestWithCompleted:^(ResponseState *state) {
            
            CloseLoading
            
            if (state.isSuccess){
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }
        }];
        
        
    } failure:^(NSError *error) {
    }];
}

#pragma mark - 选择职业
- (IBAction)chooseProfession:(UIButton *)sender {
    
    [self.view endEditing:YES];
    
    NSMutableArray *jobs = [NSMutableArray array];
    
    for (JobModel *m  in self.jobs){
        
        [jobs addObject:m.name];
    }
    
    NSArray *tempArr = [jobs copy];
    
    @weakify(self);
    __block NSString *professionStr = tempArr[0];
    DDCustomPickerView *pk = [[DDCustomPickerView alloc] initWithStyle:DDPickerStyle_1];
    [pk setNumberOfRowsBlock:^NSUInteger(NSInteger component) {
        return tempArr.count;
    }];
    [pk setTitleForRowBlock:^NSString *(NSInteger row, NSInteger component) {
        if (row < tempArr.count) {
            return tempArr[row];
        }
        return @"";
    }];
    [pk setSelectBlock:^(NSInteger row, NSInteger component) {
        if (row < tempArr.count) {
            professionStr = tempArr[row];
        }
        @strongify(self);
        self.selectJobIndex = row;
    }];
    [pk setChooseBlock:^{
        @strongify(self);
        [self.professionBtn setTitle:professionStr forState:UIControlStateNormal];
    }];
    [pk showInView:self.view];
}

#pragma mark - 证件正面照
- (IBAction)IDCardAction:(UIButton *)sender {
   // _isSelectIDCard = YES;
    [self chooseImageWithType:0];
}

- (IBAction)IDCardBackAction:(id)sender {
   // _isSelectIDCard = YES;
    [self chooseImageWithType:1];

}


#pragma mark - 手持证件照
- (IBAction)handHeldDocumentAction:(UIButton *)sender {
   // _isSelectIDCard = NO;
    [self chooseImageWithType:2];
}

- (void)chooseImageWithType:(NSInteger)type{
    [self.view endEditing:YES];
//    DDAlertController *alert = [DDAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    alert.title = @"选择照片";
//    //统一标题颜色
////    alert.tintColor = UIColorHex(0x343435);
//    
//    [alert addAction:[DDAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self openTheCamera];
//    }]];
//    
//    [alert addAction:[DDAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self openThePhotoLibrary];
//    }]];
//    [alert addAction:[DDAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//    [self presentViewController:alert animated:YES completion:nil];
    
    @weakify(self);
    
    [NCAlert showActionSheetWithDataSource:@[@"图库",@"相机"] blockHandel:^(NSInteger index) {
        if (index == 0 || index == 1)
        {
            UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
            imagePC.sourceType = index;
            
            [imagePC setBk_didFinishPickingMediaBlock:^(UIImagePickerController *pc, NSDictionary *param)
             {
                 @strongify(self);
                 UIImage *image = param[UIImagePickerControllerOriginalImage];
                 
                 if (type == 0){
                     [self.idCardfrontBtn setImage:image forState:UIControlStateNormal];
                     self.frontImage = image;
                 }
                 else if(type == 1){
                     [self.IDCarBackBtn setImage:image forState:UIControlStateNormal];
                     self.backImage = image;
                 }
                 else{
                     [self.IDHandCarBtn setImage:image forState:UIControlStateNormal];
                     self.handImage = image;
                 }
                 
                 [self dismissViewControllerAnimated:YES completion:nil];
                 
             }];
            
            [self presentViewController:imagePC animated:YES completion:nil];
        }
    }];

}

#pragma mark 打开相册
- (void)openThePhotoLibrary {
    if (iOS7) {
        if ([CheckTools isPermissionsWithType:PhotoPermissions])  {
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                //不显示视频文件
                //        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            }
            pickerImage.delegate = self;
            pickerImage.allowsEditing = YES;
            [self presentViewController:pickerImage animated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"对不起，您已将相册权限关闭"
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"设置", nil];
            
            [alert bk_setHandler:^{
                if (IOS_VERSION >= 8.0) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                } else {
                    //                    OpenPermissionGuideViewController *vc = [[OpenPermissionGuideViewController alloc] init];
                    //                    vc.type = CameraGuide;
                    //                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            } forButtonAtIndex:1];
            
            [alert show];
        }
    }
}

#pragma mark 打开相機
- (void)openTheCamera {
    if (iOS7) {
        if ([CheckTools isPermissionsWithType:CameraPermissions]) {
            //先设定sourceType为相機，然后判断相機是否可用（ipod）没相機，不可用将sourceType设定为相片库
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            //如果没有相機功能，则打开相册
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                //        [self openThePhotoLibrary];
                return;
            }
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
            picker.delegate      = self;
            picker.allowsEditing = YES;//设置可编辑
            picker.sourceType    = sourceType;
            [self presentViewController:picker animated:YES completion:nil];//进入照相界面
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"对不起，您已将相机权限关闭"
                                                           delegate:nil
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"设置", nil];
            
            [alert bk_setHandler:^{
                if (IOS_VERSION >= 8.0) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                }
            } forButtonAtIndex:1];
            
            [alert show];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
// This method is called when an image has been chosen from the library or taken from the camera.
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    DLog(@"%@", info);
//    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    // 判断获取类型：图片
//    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
//        UIImage *theImage = nil;
//        // 判断，图片是否允许修改
//        if ([picker allowsEditing]){
//            //获取用户编辑之后的图像
//            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
//        } else {
//            // 照片的元数据参数
//            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//        }
//        if (_isSelectIDCard) {
//            [_IDCardBtn setBackgroundImage:theImage forState:UIControlStateNormal];
//        } else {
//            [_HandIDCardBtn setBackgroundImage:theImage forState:UIControlStateNormal];
//        }
////        _userPicImg.image = theImage;
//    }
//    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    
//    //选取完图片就上传
////    [self requestSaveHeaderImage];
//}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Request
#pragma mark 上传图片
- (void)uploadImage:(UIImage *)handheldImage positiveImage:(UIImage *)positiveImage {
    WEAKSELF
//    __block NSString *handheldImageURL, *positiveImageURL;
//    [QiNiuSystemService uploadImage:handheldImage currentIndex:0 progress:^(NSString *key, float percent) {
//        [SVProgressHUD showProgress:percent];
//    } success:^(NSString *url) {
//        [SVProgressHUD dismiss];
//        handheldImageURL = url;
//        DLog(@"手持图片地址：%@", url);
//        [QiNiuSystemService uploadImage:positiveImage currentIndex:1 progress:^(NSString *key, float percent) {
//            [SVProgressHUD showProgress:percent];
//        } success:^(NSString *url) {
//            [SVProgressHUD dismiss];
//            positiveImageURL = url;
//            DLog(@"证件图片地址：%@", url);
//            //提交认证信息
//            [weakSelf requestAddProfession:handheldImageURL positiveImageUrl:positiveImageURL];
//        } failure:^{
//            [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
//        }];
//        
//    } failure:^{
//        [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
//    }];
}

#pragma mark 添加职业认证内容
- (void)requestAddProfession:(NSString *)handheldImageUrl positiveImageUrl:(NSString *)positiveImageUrl
{
    NSString *serverURL = nil;
    
#ifdef DEBUG
    serverURL = URL_DEV;
#else
    serverURL = URL_ONLINE;
#endif
    
    NSString *request = [NSString stringWithFormat:@"%@%@/%@.do", serverURL, @"profession", @"add"];
    //userId 用户ID
    //userName 真实姓名
    //occupation 职业ID 暂时先写死传入1
    //IDNumber 身份证号码
    //IDImageUrl 认证照片传入JSON对象 范例:{\"handheldImage\":\"http://odp9ddz40.bkt.clouddn.com/1484880537497ac345982b2b7d0a280dcd3ccc9ef76094b369a4e.jpg\",\"positiveImage\":\"http://odp9ddz40.bkt.clouddn.com/14848805374877acb0a46f21fbe09022d2ecb6f600c338644adfa.jpg\"}
    //请注意: handheldImage代表手持照片
    //positiveImage 代表正面照片
    /*if (![LoginTools isLogin]) {
      //  [LoginTools jumpToLoginView];
        return;
    }
    NSDictionary *param = @{@"userId":[LoginTools sharedLoginTools].loginModel.token,
                            @"userName":_nameTf.text,
                            @"occupation":@"1",
                            @"IDNumber":_IDCardTf.text,
                            @"IDImageUrl":@{@"handheldImage":handheldImageUrl, @"positiveImage":positiveImageUrl}.mj_JSONString};
    
    [[AFHTTP shareInstanced] sendRequest:request
                              parameters:param
                          fileDictionary:nil
                                userInfo:AFHTTP_UserInfo(request)
                                withType:request_Post
                               isShowHUD:YES
                            SuccessBlock:^(id responseObject) {
                                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                    if ([responseObject[@"state"] isEqualToString:@"true"]) {
                                        //[SVProgressHUD dismiss];
                                    } else {
                                        [SVProgressHUD showErrorWithStatus:responseObject[@"errorMsg"]];
                                    }
                                }
                            }
                            FailureBlock:^(NSURLSessionDataTask *task, NSError *error) {
                            }];*/
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
