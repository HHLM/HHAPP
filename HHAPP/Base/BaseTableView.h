//
//  BaseTableView.h
//  HHAPP
//
//  Created by Now on 2019/5/1.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTableView : UITableView
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) RACSubject *subject;
@end

NS_ASSUME_NONNULL_END
