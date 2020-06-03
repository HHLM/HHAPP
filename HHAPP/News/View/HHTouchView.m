//
//  HHTouchView.m
//  HHAPP
//
//  Created by Now on 2020/5/25.
//  Copyright © 2020 任他疾风起. All rights reserved.
//

#import "HHTouchView.h"

@implementation HHTouchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.subject sendNext:self];
    [self touchViewClicked:@"clieked" name:@"touchView" age:@"18"];
}
@end
