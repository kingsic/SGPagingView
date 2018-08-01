//
//  ChhildTempPopGestureVC.m
//  SGPagingViewExample
//
//  Created by kingsic on 2018/8/1.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "ChhildTempPopGestureVC.h"

@interface ChhildTempPopGestureVC ()

@end

@implementation ChhildTempPopGestureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customLeftBarButtonItem];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIViewController *VC = [[UIViewController alloc] init];
    VC.view.backgroundColor = [UIColor purpleColor];
    [self.navigationController pushViewController:VC animated:YES];
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
