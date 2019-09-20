//
//  BaseViewController.h
//  HHAPP
//
//  Created by Now on 2019/5/1.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "HHRacTableView.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
@property (nonatomic, strong) HHRacTableView *tableView;
- (void)config;
- (void)addDataView;
@end

NS_ASSUME_NONNULL_END
