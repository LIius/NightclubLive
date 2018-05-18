//
//  ReportViewController.m
//  NightclubLive
//
//  Created by SuperDanny on 2017/1/5.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportRequest.h"
#import "UITextView+WZB.h"

@interface ReportViewController ()

@property (weak, nonatomic) IBOutlet UITextView *contentTV;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation ReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _contentTV.placeholder = @"请填写您举报的内容(80个字)";
    [_contentTV becomeFirstResponder];
    [_contentTV becomeFirstResponder];
}

- (IBAction)okClick:(id)sender
{
    [self.view endEditing:YES];

    if (_contentTV.text.length == 0){
        ShowError(@"请填写举报内容");
        return;
    }
    
    if (_contentTV.text.length > 80){
        ShowError(@"举报内容80个字以内");
        return;
    }
    
    [self setupReportRequest];
}

- (void)setupReportRequest
{
    @weakify(self);
    ReportRequest *r = [ReportRequest new];
    r.subjectTypeId = _subjectTypeId;
    r.subjectId = _subjectId;
    r.reportType = _reportType;
    r.content = _contentTV.text;
    [r startRequestWithCompleted:^(ResponseState *state) {
        @strongify(self);
        if (state.isSuccess){
            ShowSuccess(@"举报成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            ShowError(@"举报失败");
        }
    }];
}

#pragma mark - 关闭键盘
- (IBAction)closeClick:(id)sender
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
