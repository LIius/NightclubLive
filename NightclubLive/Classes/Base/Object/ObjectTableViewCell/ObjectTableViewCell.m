//
//  ObjectTableViewCell.m
//  YIDAI
//
//  Created by RDP on 2017/1/17.
//  Copyright © 2017年 RDP. All rights reserved.
//

#import "ObjectTableViewCell.h"

@implementation ObjectTableViewCell

#pragma mark - Getter

#pragma mark - Setter

- (void)setModel:(id)model{
 
    _model = model;
}

- (void)setOptional:(NSDictionary *)optional{
    
    if (self.optional == optional)
        return;
    
    _optional = optional;
}

- (void)setTableView:(UITableView *)tableView{
    
    if (self.tableView == tableView)
        return;
    
    _tableView = tableView;
}

- (void)setIndexPath:(NSIndexPath *)indexPath{

    _indexPath = indexPath;
}

+ (UITableViewCell *)dequeueReusableWithTableView:(UITableView *)tableView{
 
    NSString *reuseID = NSStringFromClass([self class]);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (!cell){
        cell =  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    
    return cell;
}

+ (NSString *)getCellReuseID{
    
    NSString *reuseID = NSStringFromClass([self class]);
    
    return reuseID;
}
@end
