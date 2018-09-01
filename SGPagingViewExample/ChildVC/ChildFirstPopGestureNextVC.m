//
//  ChildFirstPopGestureNextVC.m
//  SGPagingViewExample
//
//  Created by kingsic on 2017/11/28.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "ChildFirstPopGestureNextVC.h"
#import "ChildTempPopGestureVC.h"

@interface ChildFirstPopGestureNextVC ()

@end

@implementation ChildFirstPopGestureNextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customLeftBarButtonItem];
}

- (IBAction)pushToNextVC:(id)sender {
    ChildTempPopGestureVC *tempVC = [[ChildTempPopGestureVC alloc] init];
    [self.navigationController pushViewController:tempVC animated:YES];
}

- (void)customLeftBarButtonItem {
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button setTitle:@"back" forState:(UIControlStateNormal)];
    [button sizeToFit];
    [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [button addTarget:self action:@selector(popGesture) forControlEvents:(UIControlEventTouchUpInside)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)popGesture {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
