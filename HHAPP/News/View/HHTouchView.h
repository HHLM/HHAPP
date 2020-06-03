//
//  HHTouchView.h
//  HHAPP
//
//  Created by Now on 2020/5/25.
//  Copyright © 2020 任他疾风起. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHTouchView : UIView

@property (nonatomic, strong) RACSubject *subject;
- (void)touchViewClicked:(NSString *)string name:(NSString *)name age:(NSString *)age;
@end

NS_ASSUME_NONNULL_END
