//
//  TestOneVC.m
//  SGTopScrollMenu
//
//  Created by Sorgle on 16/8/15.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "TestOneVC.h"

@interface TestOneVC ()

@end

@implementation TestOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor purpleColor];
    
    UIButton *test = [UIButton buttonWithType:(UIButtonTypeCustom)];
    test.frame = CGRectMake((self.view.frame.size.width - 100) * 0.5, 200, 100, 50);
    test.backgroundColor = [UIColor brownColor];
    [test addTarget:self action:@selector(testButton_action) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:test];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)testButton_action {
    NSLog(@"testButton_action");
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
