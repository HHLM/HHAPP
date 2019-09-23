//
//  HHRacTableView.h
//  HHAPP
//
//  Created by Now on 2019/9/18.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHRacTableView : UITableView
@property (nonatomic, strong) RACSubject *subject;
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) RACReplaySubject *replay;
@end

NS_ASSUME_NONNULL_END
