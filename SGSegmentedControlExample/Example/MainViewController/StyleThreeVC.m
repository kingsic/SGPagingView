//
//  StyleThreeVC.m
//  SGSegmentedControlExample
//
//  Created by Sorgle on 2016/10/6.
//  Copyright © 2016年 Sorgle. All rights reserved.
//

#import "StyleThreeVC.h"
#import "SGSegmentedControl.h"
#import "SGNavigationItemTitleView.h"

@interface StyleThreeVC ()

@end

@implementation StyleThreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;

    NSArray *title_arr = @[@"精选", @"电视剧", @"电影", @"综艺", @"NBA", @"新闻", @"娱乐", @"音乐", @"网络电影"];
    SGSegmentedControl *SG = [SGSegmentedControl segmentedControlWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44) delegate:nil segmentedControlType:(SGSegmentedControlTypeScroll) titleArr:title_arr];
    SG.titleColorStateNormal = [UIColor blueColor];
    SG.showsBottomScrollIndicator = NO;

    // 对navigationItem.titleView的包装，为的是让View占据整个视图宽度
    SGNavigationItemTitleView *view = [[SGNavigationItemTitleView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:SG];
    self.navigationItem.titleView = view;
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 270, self.view.frame.size.width - 40, 30);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"在此不做任何处理了";
    label.textColor = [UIColor purpleColor];
    label.font = [UIFont systemFontOfSize:27];
    [self.view addSubview:label];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
