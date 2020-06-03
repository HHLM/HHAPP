//
//  HHLikeHeaderView.m
//  HHAPP
//
//  Created by Now on 2019/5/22.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHLikeHeaderView.h"

@implementation HHLikeHeaderView
{
    UIView *v;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)addFirstView {
    v = [[UIView alloc] init];
    [self addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(100);
        make.center.mas_equalTo(self);
    }];
    v.backgroundColor = [UIColor greenColor];
}

- (void)layoutSubviews {
    NSLog(@"刷新子视图");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [v mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(200);
    }];
}

@end
