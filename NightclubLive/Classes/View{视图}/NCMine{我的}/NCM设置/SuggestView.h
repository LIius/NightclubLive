//
//  SuggestView.h
//  NightclubLive
//
//  Created by RDP on 2017/6/26.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "ObjectView.h"

@interface SuggestView : ObjectView
@property (weak, nonatomic) IBOutlet UITextView *textView;
/** 提交回调 */
@property (nonatomic, copy) CalkBackBlock submitBlock;

@end
