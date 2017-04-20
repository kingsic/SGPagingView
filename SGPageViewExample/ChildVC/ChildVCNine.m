//
//  ChildVCNine.m
//  SGPageViewExample
//
//  Created by apple on 17/4/19.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "ChildVCNine.h"

@interface ChildVCNine ()

@end

@implementation ChildVCNine

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];

    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [btn setTitle:@"点击控制器 view - dismiss" forState:(UIControlStateNormal)];
    
    [btn sizeToFit];
    CGPoint center = self.view.center;
    center.y = 150;
    btn.center = center;
    
    [btn addTarget:self action:@selector(btnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnAction {
    NSLog(@"%s", __FUNCTION__);
}


@end
