//
//  HHRacSubjectViewController.m
//  HHAPP
//
//  Created by Now on 2019/9/18.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHRacSubjectViewController.h"

@interface HHRacSubjectViewController ()

@end

@implementation HHRacSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.subject) {
        [self.subject sendNext:@"来自于RacSubjectViewController的信号"];
        [self.subject sendNext:@"来自于RacSubjectViewController的信号1"];
        [self.subject sendCompleted];
        [self.subject sendNext:@"来自于RacSubjectViewController的信号2"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
