//
//  AddedValueHeadCollectionReusableView.h
//  NightclubLive
//
//  Created by RDP on 2017/4/14.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *AddedValueHeadCollectionReusableViewReuseID = @"AddedValueHeadCollectionReusableView";

@interface AddedValueHeadCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *ncBitLabel;

@end
