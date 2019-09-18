//
//  BaseTableViewCell.m
//  HHAPP
//
//  Created by Now on 2019/9/18.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

+ (instancetype)creatCellWithTable:(UITableView *)tableView {
    return  [BaseTableViewCell creatCellWithTable:tableView reuseIdentifier:NSStringFromClass([self class])];
}

+ (instancetype)creatCellWithTable:(UITableView *)tableView
                   reuseIdentifier:(NSString *)reuseIdentifier {
    return [BaseTableViewCell creatCellWithTable:tableView
                               reuseIdentifier:reuseIdentifier
                                     cellStyle:UITableViewCellStyleDefault];
}

+ (instancetype)creatCellWithTable:(UITableView *)tableView
                         cellStyle:(UITableViewCellStyle)cellStyle {
    return [BaseTableViewCell creatCellWithTable:tableView
                               reuseIdentifier:NSStringFromClass([self class])
                                     cellStyle:cellStyle];
}

+ (instancetype)creatCellWithTable:(UITableView *)tableView
                   reuseIdentifier:(NSString *)reuseIdentifier
                         cellStyle:(UITableViewCellStyle)cellStyle {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
