//
//  PhotoAlbumListHeadView.m
//  NightclubLive
//
//  Created by RDP on 2017/4/21.
//  Copyright © 2017年 WanBo. All rights reserved.
//

#import "PhotoAlbumListHeadView.h"
#import "MineModelList.h"


#import "BlocksKit+UIKit.h"
@implementation PhotoAlbumListHeadView

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    @weakify(self);
    
    [_allBtn bk_whenTapped:^{

        @strongify(self);
        self.model.selectAll = !self.model.selectAll;
        if (self.allBlock)
            self.allBlock(@{@"indexPath":self.indexPath,@"isSelect":@(self.model.selectAll)});
    }];
    
    [_deleteBtn bk_whenTapped:^{
        @strongify(self);
        if (self.deleteBlock)
            self.deleteBlock(self.indexPath);
    }];
    
    self.layer.cornerRadius = 5;
    self.backgroundColor = [UIColor whiteColor];
    
}
- (void)setModel:(PhotoAlbumList *)model{
    
    _model = model;
    
    _timeLabel.text = model.create_time.YDMMChinaString;

    _allBtn.titleLabel.text = model.selectAll ? @"取消全选" : @"全选";

    [_allBtn setTitle:model.selectAll ? @"取消全选" : @"全选" forState:UIControlStateNormal];
    
    [_allBtn.titleLabel sizeToFit];
}

- (void)setFrame:(CGRect)frame{

    
    frame.size.width -= 14;
    frame.size.height -= 14;
    frame.origin.x += 7;
    frame.origin.y += 7;
    
    [super setFrame:frame];
}

- (void)setHiddenOperation:(BOOL)hiddenOperation{
    

    _allBtn.hidden = hiddenOperation;
    _deleteBtn.hidden = hiddenOperation;
}
@end
