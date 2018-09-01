//
//  SGNavigationController.m
//  SGPagingViewExample
//
//  Created by SGQ on 2018/8/31.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SGNavigationController.h"

@interface SGNavigationController ()<UINavigationControllerDelegate>

@end

@implementation SGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.interactivePopGestureRecognizer.delegate = nil;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    BOOL isRootVC = (viewController == navigationController.viewControllers.firstObject);
    navigationController.interactivePopGestureRecognizer.enabled = !isRootVC;
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
