//
//  HHNavigationController.m
//  HHAPP
//
//  Created by Now on 2019/5/1.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHNavigationController.h"

@interface HHNavigationController ()<UINavigationControllerDelegate>
@property (nonatomic, weak) id popDelegate;
/** 隐藏导航的VC数组 */
@property (nonatomic, strong) NSArray *hiddenNavigationBarVCs;
@end

@implementation HHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.navigationBar.translucent = NO;
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
}


//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
    return [[self topViewController] preferredStatusBarStyle];
}

- (void)popViewController{
    
    UIViewController *vc = self.viewControllers.lastObject;
    SEL selector = NSSelectorFromString(@"hh_popViewController");
    if ([vc respondsToSelector:selector]) {
        IMP imp = [vc methodForSelector:selector];
        void (*func)(id, SEL) = (void *)imp;
        func(vc, selector);
    }else{
        [self popViewControllerAnimated:YES];
    }
}
//push时隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

//解决手势失效问题
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController == self.viewControllers.firstObject) {
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController {
    return UIInterfaceOrientationPortrait;
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if (self.rootViewController) {
//        self.rootViewController.tabBar.hidden = (navigationController.viewControllers.count > 1);
//    }
//
//    //隐藏与显示导航
    NSString *vcClass = [NSString stringWithFormat:@"%@",viewController.class];
    BOOL hidden =  [self.hiddenNavigationBarVCs containsObject:vcClass];
    viewController.navigationController.navigationBar.hidden = hidden;

    
    if ( navigationController.viewControllers.count > 1) {
        if (viewController.navigationItem.leftBarButtonItem == nil) {
            UIButton *backButton  = [UIButton buttonWithType:UIButtonTypeCustom];
            [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            [backButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
            backButton.frame = CGRectMake(0, 0, 24, 24);
            [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
            UIView *leftView = [[UIView alloc] initWithFrame:backButton.bounds];
            [leftView addSubview:backButton];
            backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15,0, 0);
            backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20,0, 0);
            UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
            viewController.navigationItem.leftBarButtonItems = @[backBarButtonItem];
//            viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftView];
        }
        
    }
}


#pragma mark - Getters and Setters Method getter和setter方法
- (NSArray *)hiddenNavigationBarVCs{
    if (_hiddenNavigationBarVCs == nil) {
        _hiddenNavigationBarVCs = @[@"",@"", @""];
    }
    return _hiddenNavigationBarVCs;
}


@end
