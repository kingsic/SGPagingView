//
//  ChildVCEight.m
//  SGPageViewExample
//
//  Created by apple on 17/4/19.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "ChildVCEight.h"

@interface ChildVCEight ()

@end

@implementation ChildVCEight

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    UILabel *label = [[UILabel alloc] init];
    CGFloat labelX = 0;
    CGFloat labelY = 100;
    CGFloat labelW = self.view.frame.size.width;
    CGFloat labelH = 44;
    label.frame = CGRectMake(labelX, labelY, labelW, labelH);
    label.text = @"点击控制器视图返回上一界面";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
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
