//
//  BaseTableViewCell.h
//  HHAPP
//
//  Created by Now on 2019/9/18.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewCell : UITableViewCell

+ (instancetype)creatCellWithTable:(UITableView *)tableView;

+ (instancetype)creatCellWithTable:(UITableView *)tableView
                   reuseIdentifier:(NSString *)reuseIdentifier;

+ (instancetype)creatCellWithTable:(UITableView *)tableView
                         cellStyle:(UITableViewCellStyle)cellStyle;

+ (instancetype)creatCellWithTable:(UITableView *)tableView
                   reuseIdentifier:(NSString *)reuseIdentifier
                         cellStyle:(UITableViewCellStyle)cellStyle;
@end

NS_ASSUME_NONNULL_END
