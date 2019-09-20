//
//  HHTabBarController.m
//  HHAPP
//
//  Created by Now on 2019/5/1.
//  Copyright © 2019 任他疾风起. All rights reserved.
//

#import "HHTabBarController.h"
#import "HHAdminViewController.h"
#import "HHNewsViewController.h"
#import "HHVideoViewController.h"
#import "HHRacViewController.h"
#import "HHNavigationController.h"
@interface HHTabBarController ()<UITabBarDelegate,UITabBarControllerDelegate>

@end

@implementation HHTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *infoArray = @[
  @[@"新闻",@"视频",@"推荐",@"我的"],
  @[@"page",@"video",@"like",@"home"],
  @[@"page_selected",@"video_selected",@"like_selected",@"home_selected"]];
    NSArray *controllers = @[@"HHNewsViewController",
                                 @"HHVideoViewController",
                                 @"HHLikeViewController",
                                 @"HHRacViewController"];
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (int i = 0; i < controllers.count; i ++) {
        [viewControllers addObject: [self addChildName:controllers[i]
                                                 title:infoArray[0][i]
                                                 image:infoArray[1][i]
                                            hightImage:infoArray[2][i]]];
    }
    self.viewControllers = viewControllers;
    //设置字体颜色 字体大小
    NSDictionary *info = @{NSForegroundColorAttributeName : [UIColor lightGrayColor],
                           NSFontAttributeName:[UIFont systemFontOfSize:10]};
    NSDictionary *selectInfo = @{NSForegroundColorAttributeName : [UIColor magentaColor],
                                 NSFontAttributeName:[UIFont systemFontOfSize:10]};
    [[UITabBarItem appearance] setTitleTextAttributes:selectInfo
                                             forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:info
                                             forState:UIControlStateNormal];
    
    self.tabBar.translucent = NO;
    
    
}
- (HHNavigationController *)addChildName:(NSString *)childName
                                   title:(NSString *)title
                                   image:(NSString *)image
                              hightImage:(NSString *)hightImage {
    BaseViewController *vc = [NSClassFromString(childName) new];
    vc.tabBarItem.title = title;
    //使用图片原来的颜色
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:hightImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.imageInsets = UIEdgeInsetsMake(-1.5, 0, 1.5, 0);
    [vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -5)];
    return [[HHNavigationController alloc] initWithRootViewController:vc];
    
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}
@end
