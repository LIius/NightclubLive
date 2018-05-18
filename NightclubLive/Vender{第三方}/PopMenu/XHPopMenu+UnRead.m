
//
//  XHPopMenu+UnRead.m
//  NightclubLive
//
//  Created by RDP on 2017/4/12.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "XHPopMenu+UnRead.h"
#import "XHPopMenuItemView.h"
#import "UIView+WZLBadge.h"

NSString const *UNReadRowKey = @"UNReadRowKey";
NSString const *IsUnReadKey  = @"IsUnReadKey";

@implementation XHPopMenu (UnRead)

- (void)setUnReadRow:(NSInteger)unReadRow{
    
    objc_setAssociatedObject(self, &UNReadRowKey, @(unReadRow), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)unReadRow{
    
    return  [objc_getAssociatedObject(self, &UNReadRowKey) integerValue];
}

- (void)setIsUnRead:(BOOL)isUnRead{
    objc_setAssociatedObject(self, &isUnRead, @(isUnRead), OBJC_ASSOCIATION_ASSIGN);
    
    UITableView *tableView = [self valueForKeyPath:@"_menuTableView"];
    
    XHPopMenuItemView *view = tableView.visibleCells[self.unReadRow];
    
    if (!isUnRead){
      //  view.textLabel.backgroundColor = [UIColor blueColor];
        //view.textLabel.numberOfLines = 0;
        //[view.textLabel sizeToFit];
        [view.textLabel showBadgeWithStyle:WBadgeStyleRedDot value:1 animationType:0];
        CGRect frame = view.textLabel.badgeFrame;
        frame.size = CGSizeMake(7.5, 7.5);
        frame.origin.x = view.textLabel.width * 0.8;
        frame.origin.y = 10;
        view.textLabel.badgeFrame = frame;
    }else{
        [view.textLabel clearBadge];
    }
}

- (BOOL)isUnRead{
    
    return [objc_getAssociatedObject(self, &IsUnReadKey) integerValue];
}
@end
